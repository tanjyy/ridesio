//
//  RideOfferingTableViewCell.swift
//  rideshare
//
//  Created by Taha Afzal on 11/12/20.
//

import UIKit

class RideOfferingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var departureLocation: UILabel!
    @IBOutlet weak var arrivalLocation: UILabel!
    @IBOutlet weak var rideDetails: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var driverUserName: UILabel!
    
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalDate: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.makeRounded()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10
        cardView.addShadow(offset: CGSize.init(width: 3, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        // Initialization code
        // add shadow on cell
//        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.23
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 5, height: 5)
//        layer.shadowColor = UIColor.black.cgColor
//
//        // add corner radius on `contentView`
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
