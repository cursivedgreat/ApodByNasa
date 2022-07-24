//
//  Download.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import Foundation


///Class tracks Image download on background thread
class Download {
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    let url: URL
    
    init(withImageULR url: URL){
        self.url = url
    }
}
