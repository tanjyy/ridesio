//
//  AccountDetailsViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit
import Parse
import AlamofireImage

class AccountDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var rides = [PFObject]()
    var selectedPost: PFObject!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let user = PFUser.current()!
        nameLabel.text = "\(user["firstName"] as! String) \(user["lastName"] as! String)"
        emailLabel.text = user["username"] as! String
        
        let imagefile = user["profilePicture"] as! PFFileObject
        let urlString = (imagefile.url)!
        let url = URL(string: urlString)!
        
        profileImageView.af.setImage(withURL: url)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: animated)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
        // TODO: this should be updated; rides shouldn't be obtained by querying, but instead by listing out the rides that are saved in the user's list of rides
        
        let query = PFQuery(className: "Rides")
        query.whereKey("driverId", equalTo: PFUser.current())
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                self.rides = rides!
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if rides.count > 0 {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = .singleLine;
            return 1
        } else {
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = "You have no trips yet! Go out and ride 🙏"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "Inter", size: 26)
            messageLabel.sizeToFit()

            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = .none;
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ride = rides[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountDetailsTableViewCell") as! AccountDetailsTableViewCell
        
        // configure cell
        let user = PFUser.current() as! PFUser
        cell.driverUserName.text = user["firstName"] as? String
        let imagefile = user["profilePicture"] as! PFFileObject
        let urlString = (imagefile.url)!
        let url = URL(string: urlString)!
        
        cell.profilePicture.af.setImage(withURL: url)
        
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
