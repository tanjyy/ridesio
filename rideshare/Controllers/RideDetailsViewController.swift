//
//  RideDetailsViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit
import Parse

class RideDetailsViewController: UIViewController {
    
    @IBOutlet weak var departureLocation: UILabel!
    @IBOutlet weak var arrivalLocation: UILabel!
    
    @IBOutlet weak var departureDateTime: UILabel!
    
    @IBOutlet weak var returnDateTime: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    // TODO: this should become a Ride object after the Ride class is created, used to pass information from table view to this details page
    var ride: Trip?
    var poster: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ride == nil {
            let tripInfo = TripInfo(pickupLocation: "", arrivalLocation: "", departureTime: Date(), returnTime: Date())
            ride = Trip(tripId: "", posterId: "", tripInfo: tripInfo, cost: "", description: "")
        }
        
        departureLocation.text = ride?.tripInfo.pickupLocation
        arrivalLocation.text = ride?.tripInfo.arrivalLocation
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        
        departureDateTime.text = dateFormatter.string(from: (ride?.tripInfo.departureTime)!)
        returnDateTime.text = dateFormatter.string(from: (ride?.tripInfo.returnTime)!)
        
        descriptionLabel.text = ride?.description
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = self.poster?.lname.startIndex
        let name = "\(poster!.fname) \(poster!.lname[index!])."
        driverName.text = name
        
        profileImageView.af.setImage(withURL: poster!.profilePic)
    }
    
    @IBAction func onBookRide(_ sender: Any) {
        // TODO: open email app with relevant fields populated
        // TODO: add ride to user's list of rides
        print("ride booked!")
    }
    
    @IBAction func onClickProfilePic(_ sender: Any) {
        // if the profile being clicked is the current user, go to the account details page, otherwise go to the user's profile
        if poster?.user_id == PFUser.current()?.objectId {
            let storyboard = UIStoryboard(name:"AccountDetails", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AccountDetails") as! AccountDetailsViewController
            
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name:"Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "Profile") as! ProfileViewController
            vc.user = poster
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
