//
//  ApodInfo.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import Foundation

class ApodInfo: Codable {
    //
    //MARK: - Constants
    //
    let date: String
    let explanation: String
    let media_type: String
    let url: String
    let title: String
    
    //
    //MARK: - Variables & Properties
    //
    var hdurl: URL?
    var service_version: String?
    var downloaded: Bool? = false
    var isFavourtie: Bool? = false
    var localImageName: String?
    
    //
    //MARK: - Initialization
    //
    init(date: String, explanation: String, url: String, mediaType: String, title: String){
        self.date = date
        self.url = url
        self.title = title
        self.explanation = explanation
        self.media_type = mediaType
    }
}
