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
        if ride?.posterId == PFUser.current()?.objectId {
            print("can't book ride that you posted")
            return
        }
        
        let query = PFQuery(className: "Rides")
        query.whereKey("objectId", equalTo: ride?.tripId as! String)
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                let curr_ride = rides![0]
                
                var isAlreadyRider = false
                
                // TODO: add logic here to not add user if they are already a rider
                let riders = curr_ride["riders"] as! [PFObject]
                for rider in riders {
                    if rider.objectId == PFUser.current()?.objectId {
                        isAlreadyRider = true
                        break
                    }
                }
                
                if isAlreadyRider {
                    print("Can't book ride twice, not booking ride")
                    // TODO: add a popup dialog here that informs user of why the operation failed
                } else {
                    curr_ride.add(PFUser.current(), forKey: "riders")
                    
                    curr_ride.saveInBackground { (success, error)  in
                        if (success) {
                            print("ride booked!")
                            
                            // TODO: open email app with relevant fields populated
                            let email = self.poster?.email as! String
                            if let url = URL(string: "mailto:\(email)") {
                                print("opening mail app")
                                UIApplication.shared.open(url)
                            } else {
                                print("opening mail app failed")
                            }
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            // TODO: add a popup dialog here that informs user of why the operation failed
                            print("\(error?.localizedDescription)")
                        }
                    }
                }
                
                
            }
        }
        
        // TODO: add ride to user's list of rides
        
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
