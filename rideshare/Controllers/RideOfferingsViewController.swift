//
//  RideOfferingsViewController.swift
//  rideshare
//
//  Created by Taha Afzal on 11/12/20.
//

import UIKit

class RideOfferingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBAction func onNewRideButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewRide", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewRide")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = rideOfferingsTableView.dequeueReusableCell(withIdentifier: "RideOfferingTableViewCell") as! RideOfferingTableViewCell
        
        // configure cell
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
