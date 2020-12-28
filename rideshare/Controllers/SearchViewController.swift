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
    
    weak var delegate: SearchViewControllerDelegate?
    
    var fieldName = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCompleter.delegate = self
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        
        dismiss(animated: true, completion: nil)
    }
}
