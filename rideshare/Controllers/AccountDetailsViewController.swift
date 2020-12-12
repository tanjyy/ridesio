//
//  AccountDetailsViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit
import Parse
import AlamofireImage

class AccountDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var rides = [PFObject]()
    var selectedPost: PFObject!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user = PFUser.current()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onTapGesture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        profileImageView.image = scaledImage
        
        let imageData = profileImageView.image!.pngData()
        let profilePictureFile = PFFileObject(name: "image.png", data: imageData!)
        
        user?["profilePicture"] = profilePictureFile
        
        user?.saveInBackground(block: { (success, error) in
            if (success) {
                print("Profile picture saved in Parse")
                self.tableView.reloadData()
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner(onView: self.tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        profileImageView.makeRounded()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: animated)
        }
        
        if (user?["profilePicture"] != nil) {
            let imageFile = user?["profilePicture"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!

            profileImageView.af.setImage(withURL: url)
        //    profilePictureImage.setNeedsDisplay()
            
        }
        else {
            profileImageView.image = UIImage(systemName: "person")
        }
        
        nameLabel.text = "\(user?["firstName"] as! String) \(user?["lastName"] as! String)"
        emailLabel.text = (user?["username"] as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
        let query = PFQuery(className: "Rides")
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                var filtered_rides = [PFObject]()
                if let unwrapped_rides = rides {
                    for ride in unwrapped_rides {
                        let riders = ride["riders"] as! [PFObject]
                        for rider in riders {
                            if rider.objectId == PFUser.current()?.objectId {
                                filtered_rides.append(ride)
                            }
                        }
                    }
                }
                self.rides = filtered_rides
                self.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.removeSpinner()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if rides.count > 0 {
            self.tableView.restore()
            return 1
        } else {
            self.tableView.setEmptyMessage("You have no trips yet! Go out and ride 🙏")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ride = rides[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountDetailsTableViewCell") as! AccountDetailsTableViewCell
        
        cell.selectionStyle = .none

        // configure cell
        let poster = ride["driverId"] as! PFUser
        
        poster.fetchInBackground { (object, error) in
            if error == nil {
                cell.driverUserName.text = poster["firstName"] as? String
                if let imagefile = poster["profilePicture"] as? PFFileObject {
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
        
        // TODO: update this to pass the Ride object corresponding to this cell in the table view
        let rideObject = rides[indexPath.row]
        let departureDateTimeString = rideObject["departureDatetime"] as! String
        let arrivalDateTimeString = rideObject["arrivalDatetime"] as! String
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let departureDateTime = dateFormatter.date(from: departureDateTimeString) as! Date
        let arrivalDateTime = dateFormatter.date(from: arrivalDateTimeString) as! Date
        
        let departureCoordinate = CLLocationCoordinate2D(latitude: rideObject["departureLocationLat"] as! CLLocationDegrees, longitude: rideObject["departureLocationLong"] as! CLLocationDegrees)
        let arrivalCoordinate = CLLocationCoordinate2D(latitude: rideObject["arrivalLocationLat"] as! CLLocationDegrees, longitude: rideObject["arrivalLocationLong"] as! CLLocationDegrees)
        
        let tripInfo = TripInfo(pickupLocation: rideObject["departureLocation"] as? String ?? "", arrivalLocation: rideObject["arrivalLocation"] as? String ?? "", departureTime: departureDateTime as! Date, returnTime: arrivalDateTime as! Date, departureCoordinate: departureCoordinate, arrivalCoordinate: arrivalCoordinate)
        
        let ride = Trip(tripId: rideObject.objectId!, posterId: (rideObject["driverId"] as! PFUser).objectId!, tripInfo: tripInfo, cost: "n/a", description: rideObject["rideDetails"] as! String)
        
        vc.ride = ride
        
        // Pass the user object corresponding to this row to the next view
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: (rideObject["driverId"] as! PFUser).objectId!)
        
        query?.findObjectsInBackground{(users,error) in
            
            if users?.isEmpty != true {
                print("users not nil")
                let posterObj = users?[0]
                let fname = posterObj?["firstName"] as! String
                let lname = posterObj?["lastName"] as! String
                let uid = posterObj?.objectId as? String ?? ""
                let phone_number = posterObj?["phoneNumber"] as? String ?? "n/a"
                let email = posterObj?["username"] as! String
                var profilePic = URL(string: "www.ridesio.com")!
                if let imagefile = posterObj?["profilePicture"] as? PFFileObject {
                    let urlString = (imagefile.url)!
                    profilePic = URL(string: urlString)!
                }
                
                // TODO: remove tripHistory from User class?
                let tripHistory = [Trip]()
                
                let poster = User(fname: fname, lname: lname, user_id: uid, phone_number: phone_number, email: email, profilePic: profilePic, trip_history: tripHistory)
                
                vc.poster = poster
            }
            else {
                print("users is nil")
                print("Error: \(error?.localizedDescription)")
                let poster = User(fname: "First", lname: "Last", user_id: "userId", phone_number: "n/a", email: "n/a", profilePic: URL(string: "www.ridesio.com")!, trip_history: [Trip]())
                
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
