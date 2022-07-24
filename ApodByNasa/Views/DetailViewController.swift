//
//  DetailViewController.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    let queryService = QueryService()
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var apodInfo: ApodInfo?
    var downloadService = DownloadService.shared
    lazy var downloadSession: URLSession = {
      let configuration = URLSessionConfiguration.background(withIdentifier: "com.avinash.apodbynasa.download.image")
      return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downloadService.downloadSession = downloadSession
    }
    
    func update(withApodInfo apodInfo: ApodInfo){
        DispatchQueue.main.async {
            self.titleLabel.text = apodInfo.title
            self.detailLabel.text = apodInfo.explanation
            self.apodImageView.loadImage(withUrl: apodInfo.url)
        }
    }
    
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
}

extension DetailViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
//        let download = downloadService.activeDownloads[url]
        downloadService.activeDownloads[url] = nil
        
        let destinationURL = localFilePath(for: url)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.apodImageView.image = UIImage(contentsOfFile: destinationURL.path)
                imageCache.insert(destinationURL, forKey: url.absoluteString)
                self.apodImageView.removeActivityView()
            }
        } catch let error {
            print("Couldn't copy file to disk: \(error.localizedDescription)")
        }
    }
}
