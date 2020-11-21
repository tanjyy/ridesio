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
            
            // TODO: set fname and lname based on PFUser
            let fname = "First"
            let lname = "Last"
            // end update
            
            // TODO: update profile picture using profile pic of user
            
            cell.name.text = "\(fname) \(lname)"
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
    }
    

}
