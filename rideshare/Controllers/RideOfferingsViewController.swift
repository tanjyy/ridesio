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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = rideOfferingsTableView.dequeueReusableCell(withIdentifier: "RideOfferingTableViewCell") as! RideOfferingTableViewCell
        
        // configure cell
        //cell.layer.cornerRadius = 40

        return cell
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
