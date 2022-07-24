//
//  DownloadService.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import Foundation
import UIKit

///Class performs image download task in URLSession download configuration
class DownloadService {
    
    //
    //MARK: - Shared Instance
    //
    static let shared = DownloadService()
    
    //
    //MARK: - Variable
    //
    var activeDownloads: [URL: Download] = [:]
    var downloadSession: URLSession!
    
    //
    //MARK: - Internal Methods
    //
    func cancelDownload(_ url: URL){
        guard let download = activeDownloads[url] else { return }
        download.task?.cancel()
        download.isDownloading = false
    }
    
    func pauseDownload(_ url: URL){
        guard let download = activeDownloads[url] else { return }
        download.task?.cancel(byProducingResumeData: { resumeData in
            download.resumeData = resumeData
        })
        download.isDownloading = false
    }
    
    func resumeDownload(_ url: URL){
        guard let download = activeDownloads[url] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadSession.downloadTask(with: url)
        }
        download.task?.resume()
        download.isDownloading = true
    }
    
    func startDownload(_ url: URL){
        let download = Download(withImageULR: url)
        download.task = downloadSession.downloadTask(with: url)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[url] = download
    }
}
