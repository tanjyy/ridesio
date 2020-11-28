//
//  AccountDetailsTableViewCell.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit

class AccountDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var departureLocation: UILabel!
    @IBOutlet weak var arrivalLocation: UILabel!
    @IBOutlet weak var rideDetails: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var driverUserName: UILabel!
    
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalDate: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
