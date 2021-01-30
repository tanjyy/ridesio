//
//  Place.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 1/5/21.
//

import Foundation


class Place: Codable, Equatable, CustomStringConvertible {
    var latitude: Double
    var longitude: Double
    var userGivenName: String
    var name: String
    var description: String
    
    init(lat: Double, long: Double, userGivenName: String, name: String, description: String) {
        self.latitude = lat
        self.longitude = long
        self.userGivenName = userGivenName
        self.name = name
        // TODO: update this to a different name so that description can be used for string representation of the Place
        self.description = description
    }
    
    public static func loadPlaces() -> [Place] {
        let placeData = UserDefaults.standard.object(forKey: "places") as? NSData
        
        var placeArray = [Place]()
        if let placeData = placeData {
            placeArray = try! JSONDecoder().decode([Place].self, from: placeData as Data)
        }
        
        return placeArray
    }
    
    public static func savePlaces(places: [Place]) {
        let placesData = try! JSONEncoder().encode(places)
        UserDefaults.standard.set(placesData, forKey: "places")
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.userGivenName == rhs.userGivenName &&
            lhs.name == rhs.name &&
            lhs.description == rhs.description
    }
    
//    public var description: String { return "Place; userGivenName: \(userGivenName), name: \(name), description: \(description)" }
}
