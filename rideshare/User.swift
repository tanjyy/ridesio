//
//  User.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/22/20.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var objectId: String
    var email: String
    var profilePicture: URL
    var tripHistory: [Trip]
    init(firstName: String, lastName: String, objectId: String, phoneNumber: String, email: String, profilePicture: URL, tripHistory: [Trip]) {
        self.firstName = firstName
        self.lastName = lastName
        self.objectId = objectId
        self.email = email
        self.profilePicture = profilePicture
        self.tripHistory = tripHistory
    }
}
