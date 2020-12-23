//
//  NewRideViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit
import AlamofireImage
import Parse
import MapKit

class NewRideViewController: UIViewController, UINavigationControllerDelegate, SearchViewControllerDelegate {

    var departureLocationCL: MKMapItem?
    var arrivalLocationCL: MKMapItem?
    
    @IBOutlet weak var postNewRideButton: UIButton!
    // TODO: implement onTapPickupLocation and onTapArrivalLocation
    
    @IBAction func onTapDepartureLocation(_ sender: Any) {
        transitionToSearchView("departure")
    }
    
    @IBAction func onTapArrivalLocation(_ sender: Any) {
        transitionToSearchView("arrival")
    }
    
    func transitionToSearchView(_ fieldName: String) {
        let storyboard = UIStoryboard(name: "LocationSearch", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchView") as! SearchViewController
        vc.delegate = self
        vc.fieldName = fieldName
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBOutlet weak var departureLocationField: UITextField!
    
    @IBOutlet weak var arrivalLocationField: UITextField!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    @IBOutlet weak var arrivalDatePicker: UIDatePicker!
    @IBOutlet weak var rideDetailsTextView: UITextView!
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        rideDetailsTextView.layer.borderWidth = 1
        rideDetailsTextView.layer.borderColor = color.cgColor
        postNewRideButton.clipsToBounds = true
        postNewRideButton.layer.cornerRadius = 10
        postNewRideButton.addShadow(offset: CGSize.init(width: 2, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.5)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPostRideButton(_ sender: Any) {
        print("\n\nposting ride")
        let ride = PFObject(className:"Rides")
        ride["departureLocation"] = departureLocationField.text
        print(departureLocationCL as Any)
        ride["departureLocationLat"] = departureLocationCL!.placemark.coordinate.latitude
        ride["departureLocationLong"] = departureLocationCL!.placemark.coordinate.longitude
        ride["arrivalLocation"] = arrivalLocationField.text
        ride["arrivalLocationLat"] = arrivalLocationCL!.placemark.coordinate.latitude
        ride["arrivalLocationLong"] = arrivalLocationCL!.placemark.coordinate.longitude
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let departureDateTime = formatter.string(from: departureDatePicker.date)
        let arrivalDateTime = formatter.string(from: arrivalDatePicker.date)
        ride["departureDateTime"] = departureDateTime
        ride["arrivalDateTime"] = arrivalDateTime
        
        ride["driverId"] = PFUser.current()
        ride["rideDetails"] = rideDetailsTextView.text
        ride.add(PFUser.current() as Any, forKey: "riders")

        ride.saveInBackground { (success, error)  in
            if (success) {
                print("ride posted successfully")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func passBack(location: MKMapItem, fieldName: String) {
        print("in pass back")
        if fieldName == "departure" {
            self.departureLocationCL = location
            departureLocationField.text = location.name
            
            print(self.departureLocationCL!.placemark.coordinate)
            
        } else if fieldName == "arrival" {
            self.arrivalLocationCL = location
            arrivalLocationField.text = location.name
            
            print(self.arrivalLocationCL!.placemark.coordinate)
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
