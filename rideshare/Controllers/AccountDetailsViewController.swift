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

        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        // TODO: this should be updated; rides shouldn't be obtained by querying, but instead by listing out the rides that are saved in the user's list of rides
        
        let query = PFQuery(className: "Rides")
        query.whereKey("driverId", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground{(rides,error) in
            if rides != nil {
                self.rides = rides!
                self.tableView.reloadData()
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
//        vc.rideInfo = rides[indexPath]
        
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
