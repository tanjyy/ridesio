//
//  RideOfferingsViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/12/20.
//

import UIKit
import Parse

class RideOfferingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate {
    
    var rides = [PFObject]()
    var selectedPost: PFObject!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var rideOfferingsTableView: UITableView!
    
    @IBAction func onClickSettings(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Settings")

        let transition = CATransition.init()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push //Transition you want like Push, Reveal
        transition.subtype = CATransitionSubtype.fromLeft // Direction like Left to Right, Right to Left
        transition.delegate = self
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rideOfferingsTableView.delegate = self
        rideOfferingsTableView.dataSource = self
        rideOfferingsTableView.separatorStyle = .none
        sortButton.clipsToBounds = true
        sortButton.layer.cornerRadius = 10
        sortButton.addShadow(offset: CGSize.init(width: 2, height: 2), color: UIColor.black, radius: 2.0, opacity: 0.5)
        filterButton.clipsToBounds = true
        filterButton.layer.cornerRadius = 10
        filterButton.addShadow(offset: CGSize.init(width: 3, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.rideOfferingsTableView.indexPathForSelectedRow {
            rideOfferingsTableView.deselectRow(at: index, animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rideOfferingsTableView.reloadData()
        let query = PFQuery(className: "Rides")
        query.includeKeys(["driverId"])
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                self.rides = rides!
                self.rideOfferingsTableView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func onNewRideButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewRide", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewRide")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ride = rides[indexPath.row]
        let cell = rideOfferingsTableView.dequeueReusableCell(withIdentifier: "RideOfferingTableViewCell") as! RideOfferingTableViewCell
        
        cell.selectionStyle = .none
        
        // configure cell
        let user = ride["driverId"] as! PFUser
        cell.fullNameLabel.text = user["firstName"] as? String
        if  let imageFile = user["profilePicture"] as? PFFileObject {
            let urlString = (imageFile.url)!
            let url = URL(string: urlString)!
            
            cell.profilePictureImageView.af.setImage(withURL: url)
        }
        
        cell.departureLocationLabel.text = ride["departureLocation"] as? String
        cell.arrivalLocationLabel.text = ride["arrivalLocation"] as? String
        
        let str2Date = DateFormatter()
        str2Date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let departureTime = str2Date.date(from: ride["departureDateTime"] as! String)
        let arrivalTime = str2Date.date(from: (ride["arrivalDateTime"]) as! String)
        
        cell.arrivalDateLabel.text = dateFormatter.string(from: arrivalTime!)
        cell.departureDateLabel.text = dateFormatter.string( from: departureTime!)
        cell.arrivalTimeLabel.text = timeFormatter.string(from: arrivalTime!)
        cell.departureTimeLabel.text = timeFormatter.string( from: departureTime!)
        
        cell.rideDetailsLabel.text = ride["rideDetails"] as? String
        
        return cell
    }
    
    @IBAction func onViewDetailsButton(_ sender: UIButton) {
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ride at index \(indexPath.row)")
        
        let profile = UIStoryboard(name:"RideDetails", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "RideDetails") as! RideDetailsViewController
        
        // Pass the ride object corresponding to this row to the next view
        let rideObject = rides[indexPath.row]
        let departureDateTimeString = rideObject["departureDateTime"] as! String
        let arrivalDateTimeString = rideObject["arrivalDateTime"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let departureDateTime = dateFormatter.date(from: departureDateTimeString)!
        let arrivalDateTime = dateFormatter.date(from: arrivalDateTimeString)!
        
        let departureCoordinate = CLLocationCoordinate2D(latitude: rideObject["departureLocationLat"] as! CLLocationDegrees, longitude: rideObject["departureLocationLong"] as! CLLocationDegrees)
        let arrivalCoordinate = CLLocationCoordinate2D(latitude: rideObject["arrivalLocationLat"] as! CLLocationDegrees, longitude: rideObject["arrivalLocationLong"] as! CLLocationDegrees)
        
        let tripInfo = TripInfo(pickupLocation: rideObject["departureLocation"] as? String ?? "", arrivalLocation: rideObject["arrivalLocation"] as? String ?? "", departureTime: departureDateTime , arrivalTime: arrivalDateTime , departureCoordinate: departureCoordinate, arrivalCoordinate: arrivalCoordinate)
        
        let ride = Trip(tripId: rideObject.objectId!, posterId: (rideObject["driverId"] as! PFUser).objectId!, tripInfo: tripInfo, cost: "n/a", description: rideObject["rideDetails"] as! String)
        vc.ride = ride
        
        // Pass the user object corresponding to this row to the next view
        let query = PFUser.query()
        // TODO: make this get the user that posted the ride
//        query.includeKeys(["username"])
        query?.whereKey("objectId", equalTo: ride.posterId)
        
        query?.findObjectsInBackground{(users,error) in
            
            if users?.isEmpty != true {
                print("users not nil")
                let posterObj = users?[0]
                let firstName = posterObj?["firstName"] as! String
                let lastName = posterObj?["lastName"] as! String
                let objectId = posterObj?.objectId ?? ""
                let phoneNumber = posterObj?["phoneNumber"] as? String ?? "n/a"
                let email = posterObj?["username"] as! String
                var profilePicture = URL(string: "www.ridesio.com")!
                if let imageFile = posterObj?["profilePicture"] as? PFFileObject {
                    let urlString = (imageFile.url)!
                    profilePicture = URL(string: urlString)!
                }
                
                let tripHistory = [Trip]()
                
                let poster = User(firstName: firstName, lastName: lastName, objectId: objectId, phoneNumber: phoneNumber, email: email, profilePicture: profilePicture, tripHistory: tripHistory)
                
                vc.poster = poster
            }
            else {
                print("users is nil")
                print("Error: \(String(describing: error?.localizedDescription))")
                let poster = User(firstName: "First", lastName: "Last", objectId: "userId", phoneNumber: "n/a", email: "n/a", profilePicture: URL(string: "")!, tripHistory: [Trip]())
                
                vc.poster = poster
            }
        }
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
