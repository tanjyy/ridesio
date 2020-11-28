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

        let query = PFQuery(className: "User")
        // TODO: make this get the user that posted the ride
        query.whereKey("objectId", equalTo: ride?.posterId)
        
        query.findObjectsInBackground{(users: [PFObject]!,error) in
            print("got here")
            if users?.isEmpty != true {
                print("users not nil")
                let posterObj = users?[0]
                self.poster = User(fname: posterObj?["firstName"] as! String, lname: posterObj?["lastName"] as! String, user_id: posterObj?["objectId"] as! String, phone_number: posterObj?["phoneNumber"] as? String ?? "n/a", email: posterObj?["username"] as! String, profilePic: posterObj?["profilePicture"] as! Data, trip_history: [Trip]())
            }
            else {
                print("users is nil")
                print("Error: \(error?.localizedDescription)")
                let poster = User(fname: "First", lname: "Last", user_id: "userId", phone_number: "n/a", email: "n/a", profilePic: Data(), trip_history: [Trip]())
            }
        }
        let index = self.poster?.lname.startIndex
        let name = "\(poster?.fname) \(poster?.lname[index!])."

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBookRide(_ sender: Any) {
        // TODO: open email app with relevant fields populated
        // TODO: add ride to user's list of rides
        print("ride booked!")
    }
    
    @IBAction func onClickProfilePic(_ sender: Any) {
        let profile = UIStoryboard(name:"Profile", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "Profile") as! ProfileViewController
        
        // TODO: update this to pass the User object corresponding to the poster of this ride
//        vc.user = "look at this user!"
        
        navigationController?.pushViewController(vc, animated: true)
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
