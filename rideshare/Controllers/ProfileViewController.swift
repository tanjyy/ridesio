//
//  ProfileViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var user: User?
    var rides = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        if user == nil {
            user = User(fname: "First",lname: "Last",user_id: "<none>",phone_number: "n/a",email: "n/a",profilePic: URL(string: "")!,trip_history: [Trip]())
        }
        
        // TODO: set title to the User's name
        let index = user!.lname.startIndex
        let name = "\(user!.fname) \(user!.lname[index])."
        self.navigationItem.title = "\(name)'s Profile"
        nameLabel.text = name
        emailAddressLabel.text = user?.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: animated)
        }
        
        // TODO: set user profile picture
        
        let index = user!.lname.startIndex
        nameLabel.text = "\(user!.fname) \(user!.lname[index])"
        emailAddressLabel.text = (user!.email)
        
        profileImageView.af.setImage(withURL: user!.profilePic)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if rides.count > 0 {
            self.tableView.restore()
            return 1
        } else {
            print("rides.count = \(rides.count)")
            self.tableView.setEmptyMessage("This user has no trips yet")
            return 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
        // TODO: this should be updated; rides should be obtained from the user's trip history
        
        let query = PFQuery(className: "Rides")
        
        query.findObjectsInBackground{(temp_rides,error) in
            if temp_rides != nil {
                self.rides = [PFObject]()
                for ride in temp_rides! {
                    if (ride["driverId"] as! PFUser).objectId == self.user!.user_id {
                        self.rides.append(ride)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
        let ride = rides[indexPath.row]
        
        // TODO: UPDATE
        // configure cell
        cell.driver_name.text = user!.fname
        cell.profile_picture.af.setImage(withURL: user!.profilePic)
        
        cell.pickup_location.text = ride["departureLocation"] as? String
        cell.destination_location.text = ride["arrivalLocation"] as? String
        
        let str2Date = DateFormatter()
        str2Date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        let departureTime = str2Date.date(from: ride["departureDatetime"] as! String)
        let returnTime = str2Date.date(from: (ride["arrivalDatetime"]) as! String)
        
        cell.departureDate.text = dateFormatter.string( from: departureTime!)
        cell.returnDate.text = dateFormatter.string(from: returnTime!)
        
        cell.departureTime.text = timeFormatter.string( from: departureTime!)
        cell.returnTime.text = timeFormatter.string(from: returnTime!)
        
        cell.ride_description.text = ride["rideDetails"] as? String
        
        
        // END UPDATE
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ride at index \(indexPath.row)")
        
        let profile = UIStoryboard(name:"RideDetails", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "RideDetails") as! RideDetailsViewController
        
        // Pass the ride object corresponding to this row to the next view
        let rideObject = rides[indexPath.row]
        let departureDateTimeString = rideObject["departureDatetime"] as! String
        let returnDateTimeString = rideObject["arrivalDatetime"] as! String
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let departureDateTime = dateFormatter.date(from: departureDateTimeString)!
        let returnDateTime = dateFormatter.date(from: returnDateTimeString)!
        
        let tripInfo = TripInfo(pickupLocation: rideObject["departureLocation"] as? String ?? "", arrivalLocation: rideObject["arrivalLocation"] as? String ?? "", departureTime: departureDateTime, returnTime: returnDateTime)
        
        let ride = Trip(tripId: rideObject.objectId!, posterId: (rideObject["driverId"] as! PFUser).objectId!, tripInfo: tripInfo, cost: "n/a", description: rideObject["rideDetails"] as! String)
        vc.ride = ride
        
        vc.poster = user
        
        // TODO: update this to pass the Ride object corresponding to this cell in the table view
//        vc.rideInfo = "look at this info!"
        
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
