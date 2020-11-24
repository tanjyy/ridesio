//
//  LoginViewController.swift
//  rideshare
//
//  Created by Yao Yin on 11/14/20.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user["firstName"] = firstNameField.text
        user["lastName"] = lastNameField.text
        user.username = emailField.text
        user.password = signUpPasswordField.text

        user.signUpInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let successfulSignIn = true
        
        // TODO: implement sign in functionality
        
        if successfulSignIn {
            transitionToMain()
        } else {
            print("something went wrong")
        }
    }
    
    func transitionToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TabBar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
