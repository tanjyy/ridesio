//
//  AccountDetailsTableViewCell.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit

class AccountDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    @IBOutlet weak var rideDetailsLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView!.makeRounded()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10
        cardView.addShadow(offset: CGSize.init(width: 3, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
