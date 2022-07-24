//
//  FavouriteListController.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import UIKit

class FavouriteListController: UITableViewController {
    
    lazy var favoriteList = ApodCache.shared.getFavouriteList()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        title = "All Favourites"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteListCell", for: indexPath)

        // Configure the cell...
        let apodInfo = favoriteList[indexPath.row]
        cell.textLabel?.text = apodInfo.title
        cell.detailTextLabel?.text = apodInfo.date

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let apodViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ApodViewController.self)) as? ApodViewController {
            apodViewController.apodInfo = favoriteList[indexPath.row]
            navigationController?.pushViewController(apodViewController, animated: true)
        }
    }

}
