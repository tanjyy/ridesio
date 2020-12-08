//
//  ProfileTableViewCell.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pickup_location: UILabel!
    @IBOutlet weak var destination_location: UILabel!
    @IBOutlet weak var profile_picture: UIImageView!
    @IBOutlet weak var driver_name: UILabel!
    @IBOutlet weak var ride_description: UILabel!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var returnTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profile_picture.makeRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
