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
    
    let milesPerMeter = 0.000621371192
    
    @IBOutlet weak var postNewRideButton: UIButton!
    
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
        vc.displayDefaultLocations = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBOutlet weak var departureLocationField: UITextField!
    
    @IBOutlet weak var arrivalLocationField: UITextField!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    @IBOutlet weak var rideDetailsTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapKeyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        rideDetailsTextView.layer.borderWidth = 1
        rideDetailsTextView.layer.borderColor = color.cgColor
        postNewRideButton.clipsToBounds = true
        postNewRideButton.layer.cornerRadius = 10
        postNewRideButton.addShadow(offset: CGSize.init(width: 2, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func onPostRideButton(_ sender: Any) {
        
        if (departureLocationField.text!.isEmpty || arrivalLocationField.text!.isEmpty || rideDetailsTextView.text!.isEmpty || arrivalLocationCL == nil || departureLocationCL == nil) {
            let alert = UIAlertController(title: "Error", message: "All the fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
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
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: (departureLocationCL?.placemark.coordinate)!))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (arrivalLocationCL?.placemark.coordinate)!))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            request.departureDate = departureDatePicker.date
            
            let directions = MKDirections(request: request)
            
            directions.calculate { (response, error) in
                guard let unwrappedResponse = response else {return}
                
                if let route = unwrappedResponse.routes.first {
                    let travelTimeInSeconds = route.expectedTravelTime
                    print("travel time in [s]: \(travelTimeInSeconds)")
                    
                    let arrivalDate = request.departureDate! + travelTimeInSeconds
                    let arrivalDateTime = formatter.string(from: arrivalDate)
                    ride["arrivalDateTime"] = arrivalDateTime
                    
                    print("arrivalDateTime = \(arrivalDateTime)")
                    
                    ride["departureDateTime"] = departureDateTime
                    
                    ride["driverId"] = PFUser.current()
                    ride["rideDetails"] = self.rideDetailsTextView.text
                    ride.add(PFUser.current() as Any, forKey: "riders")
                    
                    ride.saveInBackground { (success, error)  in
                        if (success) {
                            print("ride posted successfully")
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("\(String(describing: error?.localizedDescription))")
                            let alert = UIAlertController(title: "Error", message: "There was an error posting the ride, please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
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
