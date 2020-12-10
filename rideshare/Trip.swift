//
//  Trip.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/22/20.
//

import Foundation
import MapKit

class TripInfo {
//    var isRoundTrip: Bool
    var pickupLocation: String
    var arrivalLocation: String
    var departureTime: Date
    var returnTime: Date
    
    var departureCoordinate: CLLocationCoordinate2D
    var arrivalCoordinate: CLLocationCoordinate2D
    
    init(pickupLocation: String, arrivalLocation: String, departureTime: Date, returnTime: Date, departureCoordinate: CLLocationCoordinate2D, arrivalCoordinate: CLLocationCoordinate2D) {
        self.pickupLocation = pickupLocation
        self.arrivalLocation = arrivalLocation
        self.departureTime = departureTime
        self.returnTime = returnTime
        self.departureCoordinate = departureCoordinate
        self.arrivalCoordinate = arrivalCoordinate
    }
}

class Trip {
    var tripId: String
    var posterId: String
    var tripInfo: TripInfo
    var cost: String
    var description: String
//    var isFullyBooked: Bool
    init(tripId: String, posterId: String, tripInfo: TripInfo, cost: String, description: String) {
        self.tripId = tripId
        self.posterId = posterId
        self.tripInfo = tripInfo
        self.cost = cost
        self.description = description
//        self.isFullyBooked = isFullyBooked
    }
}
