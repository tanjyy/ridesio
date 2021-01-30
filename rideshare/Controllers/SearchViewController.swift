//
//  SearchViewController.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 12/8/20.
//  Inspired by George McDonnell's AutocompleteExample
//  https://github.com/gm6379/MapKitAutocomplete
//

import UIKit
import MapKit
import CoreLocation

protocol SearchViewControllerDelegate : NSObjectProtocol{
    func passBack(location: MKMapItem, fieldName: String)
}

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: SearchViewControllerDelegate?
    
    var fieldName = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var places: [Place] = [Place]()
    
    var displayDefaultLocations: Bool?
    
    var currentLocationDisplayed = false
    
    let locationManager = CLLocationManager()
    
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        places = Place.loadPlaces()
        
        // Add current location to list of places to show if displaying default locations. If displayDefaultLocations is not initialized, assume it's false
        if displayDefaultLocations ?? false {
            isAuthorizedToGetUserLocation()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                print("Couldn't request location")
            }
        }
    }
    
    func isAuthorizedToGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User authorized accessing location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager failed with error: \(error.localizedDescription)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated")
        userLocation = locations[0]

        print("user location; lat = \(userLocation!.coordinate.latitude)", terminator:"")
        print("long = \(userLocation!.coordinate.longitude)")

        if currentLocationDisplayed {
            places.removeFirst()
            currentLocationDisplayed = false
        }
        if let place = getCurrentLocation() {
            if !currentLocationDisplayed {
                places.insert(place, at: 0)
                print(place)
                currentLocationDisplayed = true
                searchResultsTableView.reloadData()
            }
        }
        print("places.count = \(places.count)")
    }
    
    func getCurrentLocation() -> Place? {
        var currLocation: Place?
        if let locValue = userLocation {
            print("Got current location from locationManager")
            // TODO: https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
            let currLocationName = "Current Location"
            currLocation = Place(lat: locValue.coordinate.latitude, long: locValue.coordinate.longitude, userGivenName: "Current Location", name: currLocationName, description: "User's current location")
        } else {
            print("Couldn't get current location from locationManager")
        }

        return currLocation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        
        if searchText == "" {
            print("UISearchBar.text cleared")
            searchResults = [MKLocalSearchCompletion]()
            searchResultsTableView.reloadData()
        }
    }
    
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // if searchCompleter.queryFragment == "", want to show UserDefault locations, but only if not being displayed from preferences screen
        if searchResults.count > 0 || (displayDefaultLocations! && searchCompleter.queryFragment == "") {
            self.searchResultsTableView.restore()
            return 1
        } else {
            print("searchResults.count = \(searchResults.count)")
            self.searchResultsTableView.setEmptyMessage("No matches!")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count > 0 || searchCompleter.queryFragment != ""  {
            return searchResults.count
        } else if displayDefaultLocations! {
            return places.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchCompleter.queryFragment != "" {
            let searchResult = searchResults[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
        } else if displayDefaultLocations! {
            let place = places[indexPath.row]
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = place.userGivenName
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            return cell
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchCompleter.queryFragment != "" {
            let completion = searchResults[indexPath.row]
            
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            var location: MKMapItem?
            search.start { (response, error) in
                location = response?.mapItems[0]
                
                if let delegate = self.delegate {
                    if let location = location {
                        delegate.passBack(location: location, fieldName: self.fieldName)
                    }
                }
            }
        } else if displayDefaultLocations! {
            let place = places[indexPath.row]
            let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            let location = MKMapItem(placemark: placemark)
            location.name = place.name
            
            if let delegate = self.delegate {
                delegate.passBack(location: location, fieldName: self.fieldName)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
