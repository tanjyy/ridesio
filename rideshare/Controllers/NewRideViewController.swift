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
    @IBOutlet weak var rideDetails: UITextView!
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        rideDetails.layer.borderWidth = 1
        rideDetails.layer.borderColor = color.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPostRideButton(_ sender: Any) {
        
        // TODO: add logic to validate the entries before posting
        let success = true
        if success {
            print("ride posted!")
        } else {
            // TODO: have a popup here that informs the user of the error
            
        }
        
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
        ride.add(PFUser.current(), forKey: "riders")

        ride.saveInBackground { (success, error)  in
            if (success) {
                print("ride posted successfully")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        // TODO: add logic to update this user's list of rides
        
        
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
