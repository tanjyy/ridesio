//
//  SignUpViewController.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/24/20.
//

import UIKit
import Parse
import AlamofireImage

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    let user = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictureImageView.makeRounded()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        
        profilePictureImageView.image = scaledImage
        
        let imageData = (profilePictureImageView.image?.pngData())!
        let profilePictureFile = PFFileObject(name: "image.png", data: imageData)
        
        user["profilePicture"] = profilePictureFile
        user.saveInBackground { (success, error) in
            if (success) {
                print("profile picture saved in Parse.")
            }
            else {
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        user["firstName"] = firstNameField.text
        user["lastName"] = lastNameField.text
        user.username = emailField.text
        user["email"] = emailField.text
        user.password = passwordField.text
        
        if (firstNameField.text!.isEmpty || lastNameField.text!.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "First and Last Names are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }

        user.signUpInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
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
