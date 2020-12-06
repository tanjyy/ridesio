//
//  SignUpViewController.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/24/20.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user["firstName"] = firstNameField.text
        user["lastName"] = lastNameField.text
        user.username = emailField.text
        user["email"] = emailField.text
        user.password = passwordField.text

        user.signUpInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
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
