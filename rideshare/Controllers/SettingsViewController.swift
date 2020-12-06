//
//  SettingsViewController.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/20/20.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let numSections = 1;
    let user = PFUser.current()
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var cells: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.tableFooterView = UIView(frame:CGRect.zero)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.title = "Settings"
        
        cells = ["Legal", "Preferences", "Logout"]
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: animated)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // cells + profile + blank space in between profile and cells
        return cells.count + 2;
    }
    
    // want spacer cell between profile and the rest of the cells, don't let this one be selectable, kind of like spotify settings page
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.row == 1) {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsProfileCell") as! SettingsProfileCell
            
            // TODO: update profile picture using profile pic of user
            
            cell.name.text = "\(user?["firstName"] as! String) \(user?["lastName"] as! String)"
            return cell
        } else if indexPath.row == 1 {
            let cell : UITableViewCell = UITableViewCell()
            return cell
        } else {
            let text = cells[indexPath.row - 2]
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsContentCell") as! SettingsContentCell
            cell.content.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath.row)")
        if indexPath.row == 0 {
            print("navigate to profile")
            let profile = UIStoryboard(name:"AccountDetails", bundle: nil)
            let vc = profile.instantiateViewController(identifier: "AccountDetails")
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            print("do nothing")
        } else if indexPath.row == cells.count + 1 { // last element in table view, i.e. logout button
            print("logout")
            
            // transition back to login screen
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            PFUser.logOut()
            
            let loginScreen = UIStoryboard(name:"LoginScreen", bundle: nil)
            let vc = loginScreen.instantiateViewController(identifier: "LoginScreen")
            
            window.rootViewController = vc
            
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.4
            
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
            
        } else {
            print("navigate to relevant screen")
        }
    }
    

}
