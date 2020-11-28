//
//  ProfileViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/14/20.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        if user == nil {
            user = User(fname: "First",lname: "Last",user_id: "<none>",phone_number: "n/a",email: "n/a",profilePic: Data(),trip_history: [Trip]())
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
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
