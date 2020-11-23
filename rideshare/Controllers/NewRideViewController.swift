//
//  NewRideViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit

class NewRideViewController: UIViewController {

    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPostRideButton(_ sender: Any) {
        // TODO: add logic to post the ride to Parse and update this user's list of rides
        
        // TODO: add logic to validate the entries
        let success = true
        if success {
            print("ride posted!")
            self.dismiss(animated: true, completion: nil)
        } else {
            // TODO: have a popup here that informs the user of the error
            print("something went wrong")
        }
        
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
