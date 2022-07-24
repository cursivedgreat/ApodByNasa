//
//  ApodViewController.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import UIKit

///This details out the APOD in a page
class ApodViewController: UITableViewController {
    
    ///All cellIdentifiers used
    enum CellIdentifier: String {
        case titleCell
        case imageCell
        case favouriteCell
        case explanationCell
    }
    
    ///All cell types
    enum CellType: Int {
        case title, image, favorite, explanation, count
    }

    //MARK: - Constants
    let queryService = QueryService()
    let downloadService = DownloadService.shared
    
    //MARK: - Variables
    var apodInfo: ApodInfo? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var downloadSession: URLSession = {
      let configuration = URLSessionConfiguration.background(withIdentifier: "com.avinash.apodbynasa.download.image")
      return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        downloadService.downloadSession = downloadSession
        title = apodInfo?.date
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.titleCell.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.explanationCell.rawValue)
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count.rawValue
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == CellType.title.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.titleCell.rawValue, for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = .boldSystemFont(ofSize: 17)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = apodInfo?.title
        } else if indexPath.row == CellType.explanation.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.titleCell.rawValue, for: indexPath)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = apodInfo?.explanation
        } else if indexPath.row == CellType.image.rawValue {
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.imageCell.rawValue, for: indexPath) as? ImageCell {
                cell = imageCell
                imageCell.configureCell(withApodInfo: self.apodInfo)
                
            }
        } else if indexPath.row == CellType.favorite.rawValue {
            if let favouriteCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favouriteCell.rawValue, for: indexPath) as? FavouriteButtonCell {
                favouriteCell.delegate = self
                favouriteCell.favouriteButton.isSelected = apodInfo?.isFavourtie ?? false
                cell = favouriteCell
            }
        }
        return cell
    }
    
    ///Utility methods to get file path in sandbox
    func localFilePath(for url: URL) -> URL {
      return documentDirectory!.appendingPathComponent(url.lastPathComponent)
    }
}

///URLSession Download delegate
extension ApodViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        downloadService.activeDownloads[url] = nil
        
        let destinationURL = localFilePath(for: url)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            self.apodInfo?.localImageName = destinationURL.lastPathComponent
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: CellType.image.rawValue, section: 0)], with: .automatic)
            }
            ApodCache.shared.persistStorage()
        } catch let error {
            print("Couldn't copy file to disk: \(error.localizedDescription)")
        }
    }
}

///Favourite button (Cell) Delegate
extension ApodViewController: FavouriteButtonCellDelegate {
    func toggleFavourite() {
        if let apod = apodInfo {
            apod.isFavourtie = !(apod.isFavourtie ?? false)
            ApodCache.shared.addApodToFavoriteList(apodInfo: apod)
        }
    }
}
