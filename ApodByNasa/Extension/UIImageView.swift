//
//  UIImageView.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import Foundation
import UIKit

///Extentions to handle activity animator and downloaded image handling.
extension UIImageView {
    
    func loadImage(withUrl urlString : String) {
        
        guard let url = URL(string: urlString) else {return}
        self.image = nil
        
        addActivityView()
        
        //Download image from url
        DownloadService.shared.startDownload(url)
    }
}

extension UIImageView {
    func addActivityView() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            self.addSubview(activityIndicator)
            activityIndicator.center = CGPoint(x:self.frame.width/2,
                                               y: self.frame.height/2)
            activityIndicator.startAnimating()
        }
    }
    
    func removeActivityView() {
        for aView in self.subviews {
            if let activitityView = aView as? UIActivityIndicatorView {
                activitityView.removeFromSuperview()
            }
        }
    }
}
