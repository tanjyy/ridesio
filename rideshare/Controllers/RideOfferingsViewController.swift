//
//  RideOfferingsViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/12/20.
//

import UIKit
import Parse

class RideOfferingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rides = [PFObject]()
    var selectedPost: PFObject!
    
    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var SortButton: UIButton!
    
    @IBOutlet weak var rideOfferingsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rideOfferingsTableView.delegate = self
        rideOfferingsTableView.dataSource = self
        rideOfferingsTableView.separatorStyle = .none
        SortButton.clipsToBounds = true
        SortButton.layer.cornerRadius = 10
        SortButton.addShadow(offset: CGSize.init(width: 3, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        FilterButton.clipsToBounds = true
        FilterButton.layer.cornerRadius = 10
        FilterButton.addShadow(offset: CGSize.init(width: 3, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)

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
        
        
        // configure cell
        let user = ride["driverId"] as! PFUser
        cell.driverUserName.text = user["firstName"] as? String
        if  let imagefile = user["profilePicture"] as? PFFileObject {
            let urlString = (imagefile.url)!
            let url = URL(string: urlString)!
            
            cell.profilePicture.af.setImage(withURL: url)
        }
        
        cell.departureLocation.text = ride["departureLocation"] as? String
        cell.arrivalLocation.text = ride["arrivalLocation"] as? String
        
        let str2Date = DateFormatter()
        str2Date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let departureTime = str2Date.date(from: ride["departureDatetime"] as! String)
        let arrivalTime = str2Date.date(from: (ride["arrivalDatetime"]) as! String)
        
        cell.arrivalDate.text = dateFormatter.string(from: arrivalTime!)
        cell.departureDate.text = dateFormatter.string( from: departureTime!)
        cell.arrivalTime.text = timeFormatter.string(from: arrivalTime!)
        cell.departureTime.text = timeFormatter.string( from: departureTime!)
        
        cell.rideDetails.text = ride["rideDetails"] as? String
        
        //cell.layer.cornerRadius = 40
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ride at index \(indexPath.row)")
        
        let profile = UIStoryboard(name:"RideDetails", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "RideDetails") as! RideDetailsViewController
        
        // Pass the ride object corresponding to this row to the next view
        let rideObject = rides[indexPath.row]
        let departureDateTimeString = rideObject["departureDatetime"] as! String
        let arrivalDateTimeString = rideObject["arrivalDatetime"] as! String
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let departureDateTime = dateFormatter.date(from: departureDateTimeString)!
        let arrivalDateTime = dateFormatter.date(from: arrivalDateTimeString)!
        
        let tripInfo = TripInfo(pickupLocation: rideObject["departureLocation"] as? String ?? "", arrivalLocation: rideObject["arrivalLocation"] as? String ?? "", departureTime: departureDateTime as! Date, returnTime: arrivalDateTime )
        
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
                let fname = posterObj?["firstName"] as! String
                let lname = posterObj?["lastName"] as! String
                let uid = posterObj?.objectId ?? ""
                let phone_number = posterObj?["phoneNumber"] as? String ?? "n/a"
                let email = posterObj?["username"] as! String
                var profilePic = URL(string: "www.ridesio.com")!
                if let imagefile = posterObj?["profilePicture"] as? PFFileObject {
                    let urlString = (imagefile.url)!
                    profilePic = URL(string: urlString)!
                }
                
                let tripHistory = [Trip]()
                
                let poster = User(fname: fname, lname: lname, user_id: uid, phone_number: phone_number, email: email, profilePic: profilePic, trip_history: tripHistory)
                
                vc.poster = poster
            }
            else {
                print("users is nil")
                print("Error: \(error?.localizedDescription)")
                let poster = User(fname: "First", lname: "Last", user_id: "userId", phone_number: "n/a", email: "n/a", profilePic: URL(string: "")!, trip_history: [Trip]())
                
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
