//
//  User.swift
//  rideshare
//
//  Created by Nashir Janmohamed on 11/22/20.
//

import Foundation

class User {
    var fname: String
    var lname: String
    var user_id: String
    var email: String
    var profilePic: URL
    var trip_history: [Trip]
    init(fname: String, lname: String, user_id: String, phone_number: String, email: String, profilePic: URL, trip_history: [Trip]) {
        self.fname = fname
        self.lname = lname
        self.user_id = user_id
        self.email = email
        self.profilePic = profilePic
        self.trip_history = trip_history
    }
}
