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

protocol SearchViewControllerDelegate : NSObjectProtocol{
    func passBack(location: MKMapItem, fieldName: String)
}

class SearchViewController: UIViewController {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCompleter.delegate = self
        
        places = Place.loadPlaces()
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
            cell.textLabel?.text = place.name
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
