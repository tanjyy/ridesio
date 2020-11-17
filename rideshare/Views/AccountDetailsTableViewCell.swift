//
//  AccountDetailsTableViewCell.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit

class AccountDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var pickup_location: UILabel!
    @IBOutlet weak var destination_location: UILabel!
    @IBOutlet weak var profile_picture: UIImageView!
    @IBOutlet weak var driver_name: UILabel!
    @IBOutlet weak var ride_description: UILabel!
    
    @IBAction func onBookRide(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
