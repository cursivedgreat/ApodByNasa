//
//  DownloadService.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import Foundation
import UIKit
import Network

///Class performs image download task in URLSession download configuration
class DownloadService {
    
    //
    //MARK: - Shared Instance
    //
    static let shared = DownloadService()
    
    //MARK: - Network monitoring
    let monitor = NWPathMonitor()
    private init() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = {[weak self] path in
            if path.status == .satisfied {
                // Indicate network status, e.g., back to online
                self?.resumeAllDownloads()
            } else {
                // Indicate network status, e.g., offline mode
                self?.pauseAllDownloads()
            }
        }
    }
    
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
    
    func pauseAllDownloads() {
        for url in activeDownloads.keys {
            pauseDownload(url)
        }
    }
    
    func resumeAllDownloads() {
        for url in activeDownloads.keys {
            resumeDownload(url)
        }
    }
}
