//
//  ApodCache.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import Foundation

///Persisting object
class Storage: Codable {
    var favourites: [ApodInfo] = []
    var lastResponses = [String: ApodInfo]()
}

class ApodCache {
    
    ///Shared Instance
    static let shared = ApodCache()
    
    //
    //MARK: - Private variables
    static private var plistURL: URL {
        let documents = documentDirectory!
        let urlPath = documents.appendingPathComponent("Storage.plist")
        if let path = Bundle.main.path(forResource: "Storage", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              FileManager.default.fileExists(atPath: urlPath.path) == false {

              FileManager.default.createFile(atPath: urlPath.path, contents: data, attributes: nil)
            }
        return urlPath
      }
    
    private var storage = Storage()
   
    //
    //MARK: - designated private initializer
    //
    private init(){
        if  let data = try? Data.init(contentsOf: ApodCache.plistURL){
            do {
                storage =  try PropertyListDecoder().decode(Storage.self, from: data)
            } catch let error {
                print("ApodCache:: Error: \(error.localizedDescription)")
            }
        }
    }
    
    //
    //MARK: - APIs
    ///Returns  saved response if available
    /// - parameter date: date string in form of YYYY-MM-dd
    func getLastResponse(forDateString date: String) -> ApodInfo? {
        return storage.lastResponses[date]
    }
    
    /// Returns list of favourites APODs
    func getFavouriteList() -> [ApodInfo] {
        return storage.favourites
    }
    
    ///Adds new APOD to favourite list & persists
    func addApodToFavoriteList(apodInfo: ApodInfo) {
        if !storage.favourites.contains(where: { element in
            return apodInfo.title == element.title
        }) {
            storage.favourites.append(apodInfo)
        } else {
            if let index = storage.favourites.firstIndex(where: { element in
                return apodInfo.title == element.title
            }) {
               storage.favourites.remove(at: index)
           }
        }
        persistStorage()
    }
    
    ///Persist response for the given date string
    /// - parameter apodInfo: response
    /// - parameter dateString: dateString in the form of YYYY-MM-dd
    func saveResponse(apodInfo: ApodInfo, forDateString dateString: String){
        storage.lastResponses[dateString] = apodInfo
        persistStorage()
    }
    
    ///Persists the current storage object on the disk
    ///in the plist file `Storage.plist`
    func persistStorage() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(storage),
            let plistURL = documentDirectory?.appendingPathComponent("Storage.plist"){
            try? data.write(to: plistURL)
         }
    }
}
