//
//  Trip.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/22/20.
//

import Foundation

class TripInfo {
    var isRoundTrip: Bool
    var pickupLocation1: String
    var dropoffLocation1: String
    var pickupLocation2: String
    var dropoffLocation2: String
    var departureTime1: Date
    var arrivalTime1: Date
    var departureTime2: Date
    var arrivalTime2: Date
    
    init(isRoundTrip: Bool, pickupLocation1: String, dropoffLocation1: String, pickupLocation2: String, dropoffLocation2: String, departureTime1: Date, arrivalTime1: Date, departureTime2: Date, arrivalTime2: Date) {
        self.isRoundTrip = isRoundTrip
        self.pickupLocation1 = pickupLocation1
        self.dropoffLocation1 = dropoffLocation1
        self.pickupLocation2 = pickupLocation2
        self.dropoffLocation2 = dropoffLocation2
        self.departureTime1 = departureTime1
        self.arrivalTime1 = arrivalTime1
        self.departureTime2 = departureTime2
        self.arrivalTime2 = arrivalTime2
    }
}

class Trip {
    var tripId: String
    var posterId: String
    var tripInfo: TripInfo
    var cost: String
    var description: String
    var isFullyBooked: Bool
    init(tripId: String, posterId: String, tripInfo: TripInfo, cost: String, description: String, isFullyBooked: Bool) {
        self.tripId = tripId
        self.posterId = posterId
        self.tripInfo = tripInfo
        self.cost = cost
        self.description = description
        self.isFullyBooked = isFullyBooked
    }
}
