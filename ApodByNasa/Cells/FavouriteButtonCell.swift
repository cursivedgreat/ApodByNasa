//
//  FavoriteButtonCell.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 24/07/22.
//

import UIKit

protocol FavouriteButtonCellDelegate: AnyObject {
    func toggleFavourite()
}

class FavouriteButtonCell: UITableViewCell {

    @IBOutlet weak var favouriteButton: UIButton!
    
    weak var delegate: FavouriteButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.toggleFavourite()
    }
}
