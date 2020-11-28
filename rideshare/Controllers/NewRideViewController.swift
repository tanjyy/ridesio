//
//  NewRideViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit
import AlamofireImage
import Parse

class NewRideViewController: UIViewController,UINavigationControllerDelegate {

    

    @IBOutlet weak var departureLocation: UITextField!
    
    @IBOutlet weak var arrivalLocation: UITextField!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    @IBOutlet weak var arrivalDatePicker: UIDatePicker!
    @IBOutlet weak var rideDetails: UITextField!

    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPostRideButton(_ sender: Any) {
        // TODO: add logic to post the ride to Parse and update this user's list of rides
        
        let ride = PFObject(className:"Rides")
        ride["departureLocation"] = departureLocation.text
        ride["arrivalLocation"] = arrivalLocation.text

        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let departure_datetime = formatter.string(from: departureDatePicker.date)
        let arrival_datetime = formatter.string(from: arrivalDatePicker.date)
        ride["departureDatetime"] = departure_datetime
        ride["arrivalDatetime"] = arrival_datetime
        
        ride["driverId"] = PFUser.current()
        ride["rideDetails"] = rideDetails.text

        ride.saveInBackground { (success, error)  in
            if (success) {
               self.dismiss(animated: true, completion: nil)
            } else {
                print("something went wrong")
            }
        }
        
        // TODO: add logic to validate the entries
        let success = true
        if success {
            print("ride posted!")
            self.dismiss(animated: true, completion: nil)
        } else {
            // TODO: have a popup here that informs the user of the error
           
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
