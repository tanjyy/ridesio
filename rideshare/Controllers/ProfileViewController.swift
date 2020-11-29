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
//            self.tableView.restore()
            self.tableView.setEmptyMessage("This user has \(rides.count) trips! Check back later to see the details")
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
        query.whereKey("driverId", equalTo: user!.user_id)
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                self.rides = rides!
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
        let arrivalTime = str2Date.date(from: (ride["arrivalDatetime"]) as! String)
        
        cell.departureDate.text = dateFormatter.string( from: departureTime!)
        cell.returnDate.text = dateFormatter.string(from: arrivalTime!)
        
        cell.departureTime.text = timeFormatter.string( from: departureTime!)
        cell.returnTime.text = timeFormatter.string(from: arrivalTime!)
        
        cell.ride_description.text = ride["rideDetails"] as? String
        
        
        // END UPDATE
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ride at index \(indexPath.row)")
        
        let profile = UIStoryboard(name:"RideDetails", bundle: nil)
        let vc = profile.instantiateViewController(identifier: "RideDetails") as! RideDetailsViewController
        
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
