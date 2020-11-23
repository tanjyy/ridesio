//
//  RideDetailsViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit

class RideDetailsViewController: UIViewController {
    
    // TODO: this should become a Ride object after the Ride class is created, used to pass information from table view to this details page
    var rideInfo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        vc.user = "look at this user!"
        
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
