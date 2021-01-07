//
//  PreferencesViewController.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 1/5/21.
//

import UIKit
import MapKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchViewControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var locationMK: MKMapItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: [Place] = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        places = Place.loadPlaces()
        print("places count = \(places.count)")
        
        // TODO: initialize places
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        print("button pressed")
        if let location = locationMK, let userGivenName = nameTextField.text {
            print("location and nameTextfield valid")
            
            let lat = location.placemark.coordinate.latitude
            let long = location.placemark.coordinate.longitude
            let name = location.name!
            let description = location.description
            
            let newPlace = Place(lat: lat, long: long, userGivenName: userGivenName, name: name, description: description)
            
            places = Place.loadPlaces()
            for place in places {
                if newPlace.userGivenName == place.userGivenName {
                    let alert = UIAlertController(title: "Error", message: "That name has already been used for one of your saved locations.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
            }
            
            places.append(newPlace)
            Place.savePlaces(places: places)
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: animated)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("places.count = \(places.count)")
        if places.count > 0 {
            self.tableView.restore()
            return 1
        } else {
            self.tableView.setEmptyMessage("You have no saved locations yet")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = place.userGivenName
        cell.detailTextLabel?.text = place.name
        return cell
    }
    
    
    @IBAction func onTapLocation(_ sender: Any) {
        transitionToSearchView("location")
    }
    
    func transitionToSearchView(_ fieldName: String) {
        let storyboard = UIStoryboard(name: "LocationSearch", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchView") as! SearchViewController
        vc.delegate = self
        vc.fieldName = fieldName
        vc.displayDefaultLocations = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func passBack(location: MKMapItem, fieldName: String) {
        print("in pass back")
        if fieldName == "location" {
            self.locationMK = location
            locationTextField.text = location.name
            
            print(self.locationMK!.placemark.coordinate)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let _place = places[indexPath.row]
            if let index = places.firstIndex(of: _place) {
                places.remove(at: index)
            }
            Place.savePlaces(places: places)
            self.tableView.reloadData()
        }
    }
}
