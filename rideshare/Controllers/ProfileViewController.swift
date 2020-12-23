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
        
        self.showSpinner(onView: self.tableView)

        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorColor = UIColor.clear

        // Do any additional setup after loading the view.
        
        if user == nil {
            user = User(firstName: "First", lastName: "Last", objectId: "<none>", phoneNumber: "n/a", email: "n/a", profilePicture: URL(string: "")!,tripHistory: [Trip]())
        }
        
        // TODO: set title to the User's name
        let index = user!.lastName.startIndex
        let name = "\(user!.firstName) \(user!.lastName[index])."
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
        
        let index = user!.lastName.startIndex
        nameLabel.text = "\(user!.firstName) \(user!.lastName[index])"
        emailAddressLabel.text = (user!.email)
        
        profileImageView.makeRounded()
        profileImageView.af.setImage(withURL: user!.profilePicture)
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
        
        let query = PFQuery(className: "Rides")

        query.findObjectsInBackground{(rides, error) in
            if rides != nil {
                self.rides = [PFObject]()
                for ride in rides! {
                    if (ride["driverId"] as! PFUser).objectId == self.user!.objectId {
                        self.rides.append(ride)
                    }
                }
                self.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.removeSpinner()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.selectionStyle = .none

        let ride = rides[indexPath.row]
        
        // configure cell
        let poster = ride["driverId"] as! PFUser
        
        poster.fetchInBackground { (object, error) in
            if error == nil {
                cell.fullNameLabel.text = poster["firstName"] as? String
                if let imagefile = poster["profilePicture"] as? PFFileObject {
                    let urlString = (imagefile.url)!
                    let url = URL(string: urlString)!
                    
                    cell.profilePictureImageView.af.setImage(withURL: url)
                }

                cell.pickupLocationLabel.text = ride["departureLocation"] as? String
                cell.destinationLocationLabel.text = ride["arrivalLocation"] as? String

                let str2Date = DateFormatter()
                str2Date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"

                let departureTime = str2Date.date(from: ride["departureDateTime"] as! String)
                let arrivalTime = str2Date.date(from: (ride["arrivalDateTime"]) as! String)

                cell.returnDateLabel.text = dateFormatter.string(from: arrivalTime!)
                cell.departureDateLabel.text = dateFormatter.string( from: departureTime!)
                cell.returnTimeLabel.text = timeFormatter.string(from: arrivalTime!)
                cell.departureTimeLabel.text = timeFormatter.string( from: departureTime!)

                cell.rideDetailsLabel.text = ride["rideDetails"] as? String
            } else {
                print("failed to fetch")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ride at index \(indexPath.row)")
        
        let profile = UIStoryboard(name:"RideDetails", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "RideDetails") as! RideDetailsViewController
        
        // Pass the ride object corresponding to this row to the next view
        let rideObject = rides[indexPath.row]
        let departureDateTimeString = rideObject["departureDateTime"] as! String
        let returnDateTimeString = rideObject["arrivalDateTime"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let departureDateTime = dateFormatter.date(from: departureDateTimeString)!
        let returnDateTime = dateFormatter.date(from: returnDateTimeString)!
        
        let departureCoordinate = CLLocationCoordinate2D(latitude: rideObject["departureLocationLat"] as! CLLocationDegrees, longitude: rideObject["departureLocationLong"] as! CLLocationDegrees)
        let arrivalCoordinate = CLLocationCoordinate2D(latitude: rideObject["arrivalLocationLat"] as! CLLocationDegrees, longitude: rideObject["arrivalLocationLong"] as! CLLocationDegrees)
        
        let tripInfo = TripInfo(pickupLocation: rideObject["departureLocation"] as? String ?? "", arrivalLocation: rideObject["arrivalLocation"] as? String ?? "", departureTime: departureDateTime, returnTime: returnDateTime, departureCoordinate: departureCoordinate, arrivalCoordinate: arrivalCoordinate)
        
        let ride = Trip(tripId: rideObject.objectId!, posterId: (rideObject["driverId"] as! PFUser).objectId!, tripInfo: tripInfo, cost: "n/a", description: rideObject["rideDetails"] as! String)
        vc.ride = ride
        
        // Pass the user object corresponding to this row to the next view
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: (rideObject["driverId"] as! PFUser).objectId!)
        
        query?.findObjectsInBackground{(users, error) in
            
            if users?.isEmpty != true {
                print("users not nil")
                let posterObj = users?[0]
                let firstName = posterObj?["firstName"] as! String
                let lastName = posterObj?["lastName"] as! String
                let objectId = posterObj?.objectId ?? ""
                let phoneNumber = posterObj?["phoneNumber"] as? String ?? "n/a"
                let email = posterObj?["username"] as! String
                var profilePicture = URL(string: "www.ridesio.com")!
                
                if let imagefile = posterObj?["profilePicture"] as? PFFileObject {
                    let urlString = (imagefile.url)!
                    profilePicture = URL(string: urlString)!
                }
                // TODO: construct Trip History array from this
                let tripHistory = [Trip]()
                
                let poster = User(firstName: firstName, lastName: lastName, objectId: objectId, phoneNumber: phoneNumber, email: email, profilePicture: profilePicture, tripHistory: tripHistory)
                
                vc.poster = poster
            }
            else {
                print("users is nil")
                print("Error: \(String(describing: error?.localizedDescription))")
                let poster = User(firstName: "First", lastName: "Last", objectId: "userId", phoneNumber: "n/a", email: "n/a", profilePicture: URL(string: "www.ridesio.com")!, tripHistory: [Trip]())
                
                vc.poster = poster
            }
        }
        
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
