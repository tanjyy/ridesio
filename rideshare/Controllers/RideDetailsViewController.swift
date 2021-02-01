//
//  RideDetailsViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit
import Parse
import MapKit

class RideDetailsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripTimeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var arrivalLocationLabel: UILabel!
    
    @IBOutlet weak var departureDateTimeLabel: UILabel!
    
    @IBOutlet weak var arrivalDateTimeLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookRideButton: UIButton!
    
    @IBOutlet weak var testArrivalTime: UILabel!
    
    // TODO: this should become a Ride object after the Ride class is created, used to pass information from table view to this details page
    var ride: Trip?
    var poster: User?
    
    // do this in one of the init methods
    let milesPerMeter = 0.000621371192
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    @IBAction func onPressOpenRide(_ sender: Any) {
        //create two dummy locations
        let loc1 = ride!.tripInfo.departureCoordinate
        let loc2 = ride!.tripInfo.arrivalCoordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: loc1)
        let source = MKMapItem(placemark: sourcePlacemark)

        source.name = ride!.tripInfo.pickupLocation
        
        let destPlacemark = MKPlacemark(coordinate: loc2)
        let destination = MKMapItem(placemark: destPlacemark)

        destination.name = ride!.tripInfo.arrivalLocation

        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner(onView: self.view)
        
        profileImageView.makeRounded()
        
        if ride == nil {
            
            let tripInfo = TripInfo(pickupLocation: "", arrivalLocation: "", departureTime: Date(), arrivalTime: Date(), departureCoordinate: kCLLocationCoordinate2DInvalid, arrivalCoordinate: kCLLocationCoordinate2DInvalid)
            ride = Trip(tripId: "", posterId: "", tripInfo: tripInfo, cost: "", description: "")
        }
        
        departureLocationLabel.text = ride?.tripInfo.pickupLocation
        arrivalLocationLabel.text = ride?.tripInfo.arrivalLocation
        
        let rawDepartureTime = ride!.tripInfo.departureTime
        let rawArrivalTime = ride!.tripInfo.arrivalTime

        print("raw arrival time = \(rawArrivalTime)")
        
        dateFormatter.dateFormat = "MMM d"
        timeFormatter.dateFormat = "h:mm a"
        
        let depTimeStr = "\(dateFormatter.string(from: rawDepartureTime)) \(timeFormatter.string(from: rawDepartureTime))"
        departureDateTimeLabel.text = depTimeStr
        
        descriptionLabel.text = ride?.description
        
        bookRideButton.clipsToBounds = true
        bookRideButton.layer.cornerRadius = 10
        bookRideButton.addShadow(offset: CGSize.init(width: 2, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.5)
        
        mapView.delegate = self

        let loc1 = ride!.tripInfo.departureCoordinate
        let loc2 = ride!.tripInfo.arrivalCoordinate
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = loc1
        annotation1.title = ride!.tripInfo.pickupLocation
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = loc2
        annotation2.title = ride!.tripInfo.arrivalLocation
        mapView.addAnnotations([annotation1, annotation2])
        
        //find route
        showRouteOnMap(departureCoordinate: loc1, arrivalCoordinate: loc2)

        // Do any additional setup after loading the view.
    }
    
    func showRouteOnMap(departureCoordinate: CLLocationCoordinate2D, arrivalCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: departureCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: arrivalCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        request.departureDate = ride?.tripInfo.departureTime

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                let distanceInMeters = route.distance
                let distanceInMiles = distanceInMeters * milesPerMeter
                let travelTimeInSeconds = route.expectedTravelTime
                print("travel time in [s]: \(travelTimeInSeconds)")
                
                let arrivalDate = request.departureDate! + travelTimeInSeconds
                
                arrivalDateTimeLabel.text = "\(dateFormatter.string(from: arrivalDate)) \(timeFormatter.string(from: arrivalDate))"
                
                var travelTimeStr: String
                if travelTimeInSeconds > 3600 {
                    let remainder = Int(travelTimeInSeconds.rounded(.up)) % 3600
                    let hours = Int(travelTimeInSeconds) - remainder
                    travelTimeStr = "\(hours/3600)h \(remainder/60)m"
                } else {
                    travelTimeStr = "\(Int((travelTimeInSeconds/60).rounded(.up)))m"
                }
                
                tripDistanceLabel.text = "Trip Distance: \(String(format: "%.1f", (10 * distanceInMiles).rounded()/10))mi"
                tripTimeLabel.text = "Trip Time: \(travelTimeStr)"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.removeSpinner()
                }
                
                //show on map
                self.mapView.addOverlay(route.polyline)
                //set the map area to show the route
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }

            //if you want to show multiple routes then you can get all routes in a loop in the following statement
            //for route in unwrappedResponse.routes {}
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.red
         renderer.lineWidth = 5.0
         return renderer
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = self.poster?.lastName.startIndex
        let name = "\(poster!.firstName) \(poster!.lastName[index!])."
        fullNameLabel.text = name
        
        profileImageView.af.setImage(withURL: poster!.profilePicture)
    }
    
    @IBAction func onBookRide(_ sender: Any) {
        
        // TODO: update this later, in viewDidLoad, should check if the user has booked this ride already
        bookRideButton.isEnabled = false
        bookRideButton.backgroundColor = UIColor.gray
        bookRideButton.setTitle("Ride booked!", for: .normal)
        
        if ride?.posterId == PFUser.current()?.objectId {
            print("can't book ride that you posted")
            return
        }
        
        let query = PFQuery(className: "Rides")
        query.whereKey("objectId", equalTo: ride?.tripId as Any)
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                let ride = rides![0]
                
                var isAlreadyRider = false
                
                // TODO: add logic here to not add user if they are already a rider
                let riders = ride["riders"] as! [PFObject]
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
                    ride.add(PFUser.current() as Any, forKey: "riders")
                    
                    ride.saveInBackground { (success, error)  in
                        if (success) {
                            print("ride booked!")
                            
                            // TODO: open email app with relevant fields populated
                            let email = self.poster?.email
                            if let url = URL(string: "mailto:\(String(describing: email))") {
                                print("opening mail app")
                                UIApplication.shared.open(url)
                            } else {
                                print("opening mail app failed")
                            }
                            
//                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            // TODO: add a popup dialog here that informs user of why the operation failed
                            print("\(String(describing: error?.localizedDescription))")
                        }
                    }
                }
                
                
            }
        }
        
    }
    
    @IBAction func onClickProfilePic(_ sender: Any) {
        // if the profile being clicked is the current user, go to the account details page, otherwise go to the user's profile
        if poster?.objectId == PFUser.current()?.objectId {
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
