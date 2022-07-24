//
//  ImageCell.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var imageAspectRatioConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withApodInfo apodInfo: ApodInfo?){
        if let imageName = apodInfo?.localImageName,
           let imageURL = documentDirectory?.appendingPathComponent(imageName){
            apodImageView.removeActivityView()
            if let image = UIImage(contentsOfFile: imageURL.path) {
                apodImageView.image = image
                imageAspectRatioConstraint.constant = CGFloat(image.size.height/image.size.width)
            }
        } else if let url = apodInfo?.url {
            self.apodImageView?.loadImage(withUrl: url)
        }
    }

}
