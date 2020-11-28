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

    @IBOutlet weak var rideOfferingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rideOfferingsTableView.delegate = self
        rideOfferingsTableView.dataSource = self

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
        vc.rideInfo = "look at this info!"
        
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
