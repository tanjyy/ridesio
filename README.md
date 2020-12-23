# Ridesio

## Demo GIF
![](./ridesio-v3.gif)

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Ridesio is a rideshare bulletin board iOS app for college campuses that lets users request or post upcoming rides. Ridesio provides a communal, sustainable way of ridesharing for college students.
2nd Place winner for CodePath's Virtual Demo Day 2020. Read more <a href="https://blog.codepath.org/2020-codepath-org-fall-semester-demo-day-ios-winners-announced/?utm_content=149195058&utm_medium=social&utm_source=linkedin&hss_channel=lcp-18305024" target="_blank">here</a>.

## Product Spec

### 1. User Stories (Already implemented and Optional) and Screen Archetypes

#### Launch screen/AppIcon
- [x] User sees app icon in home screen and styled launch screen.

#### Get started Screen
- [x] User sees a login screen when opening the app for the first time (like Lyft/Uber)
- [x] User stays logged in across restarts and goes straight to the Feed Screen.
- [x] User can sign up to create a new account.
    - first name
    - last name
    - phone number
    - school email address (*Optional* verify this somehow with institution)
    - password
    - profile picture (can upload from camera or camera roll)
- [x] User can log in.

#### Feed screen (both ride request and ride offering)
- [x] User can click button to open settings menu (like on Uber/Lyft).
- [x] User can view their profile in a profile tab.
- *Optional*: User can sort rides by different criteria (distance, cost)
- *Optional*: User can search for rides

#### Feed: Ride offering screen
- [x] User can see a list of all nearby ride offerings.
- [x] User can create a new ride offering.
- [x] User can accept a nearby ride offering.
- [x] User can click a ride offering to see the details page.
- [x] User sees button that links to their own profile.

#### Create ride offering screen
- [x] User can specify
    - pickup *Optionally can use current location to specify pickup*
    - destination
    - *Optional* seats available (for v2 have confirmation/messaging through app and auto update seats available)
    - cost (or alternative form of payment)
    - special requests/conditions (i.e. no pets? luggage? etc)
    - *Optional* negotiable? if so, users can message poster to discuss alternate pickup/destination/cost

#### Ride offering details Screen
- [x] User sees
    - pickup
    - destination
    - *Optional* seats available (for v2 have confirmation/messaging through app and auto update seats available)
    - *Optional*: map data (like on Uber or Lyft)
    - cost (or alternative form of payment)
    - special requests/conditions (i.e. no pets? luggage? etc)
    - *Optional* negotiable? if so, users can message poster to discuss alternate pickup/destination/cost
- [x] User can press button to contact poster of offering.
    - "To confirm your trip, email poster and let them know how many seats you need."
- *Optional* Creator of ride offering can edit details.
- *Optional* User can message poster of offering.

#### Profile screen (for others)
- [x] User can see
    - Profile picture
    - First name
    - Last initial
    - *Optional* Number of trips taken (add when the userbase is more established)
    - Trips currently being offered (slightly different UI so that it's clear this isn't the main feed)
    - *Optional*: Star rating

#### Settings screen
- [x] Account details
- *Optional* Messsages
- [x] User can log out

#### Account details screen (user's own profile)
- [x] User can see their own
    - First name
    - Last name
    - Phone number
    - Email
    - Profile picture
        - By touching the profile picture, users can open the camera or pick a camera from the camera roll.
- *Optional* User can edit their email
- *Optional* Trip History (past rides)
- [x] Upcoming trips (same as on profile screen for others)
    - User can click trip to go to details page.
- *Optional* Driver sees requests to book their ride offerings.
    - *Optional* Driver can confirm booking.
    - *Optional* This propagates back to the user.

#### *Optional* Feed: Ride request screen
- User can see a list of all nearby ride requests.
- User can create a new ride request.
- User can accept a nearby ride request.

#### *Optional* Create ride request screen
- User can specify
    - pickup *Optionally can use current location to specify pickup*
    - destination
    - amount willing to pay (or alternative form of payment)
    - *Optional* negotiable? if so, users can message poster to discuss alternate pickup/destination/cost

#### *Optional* Ride request details Screen
- User sees
    - pickup
    - destination
    - *Optional*: map data (like on Uber or Lyft)
    - amount willing to pay (or alternative form of payment)
    - negotiable? if so, users can message poster to discuss alternate pickup/destination/cost
- User can accept request.
- *Optional* User can message poster of request.

#### *Optional* Trip history screen
- User can see list of trips
    - Date, whether driver or rider, origin, destination.
- User can click a trip to see the details of the trip

#### *Optional* Trip details screen
- User can see map data of trip (*optional*), date and time, cost, origin, destination, people they rode with.

#### *Optional* Messages screen
- More details to come

#### *Optional* Message details screen
- More details to come

#### *Optional* Rating screen
- After completing a trip, user can rate their experience (need to dig into this more - would each passenger rate only the driver? and driver rate each passenger? or does everyone have opportunity to rate everyone?)


### 2. Navigation

**Tab Navigation** (Tab to Screen)

* Ride Offerings (and requests) Feed
* **Optional** Messages
* Create New Ride Offering Button
* User Profile (account details)


## Wireframes

### [Hand Drawn Sketch](https://github.com/tanjyy/ridesio/blob/main/notes/Ride%20share%20wireframes.pdf)

### Digital Wireframes & Mockups
![Post Ride](https://github.com/tanjyy/ridesio/blob/main/notes/MVP-wireframes.png?raw=true)

## Schema
### Networking

#### Log in screen
- (Create/POST) User signup
``` Swift
func myMethod() {
  var user = PFUser()
  user.username = "myUsername"
  user.password = "myPassword"
  user.email = "email@example.com"
  // other fields can be set just like with PFObject
  user["phone"] = "415-392-0202"

  user.signUpInBackground {
    (succeeded: Bool, error: Error?) -> Void in
    if let error = error {
      let errorString = error.localizedDescription
      // Show the errorString somewhere and let the user try again.
    } else {
      // Hooray! Let them use the app now.
    }
  }
}
```
- (Read/GET) User login
``` Swift
PFUser.logInWithUsername(inBackground:"myname", password:"mypass") {
  (user: PFUser?, error: Error?) -> Void in
  if user != nil {
    // Do stuff after successful login.
  } else {
    // The login failed. Check error to see why.
  }
}
```

#### Feed screen
- (Read/GET) Query all rides *optionally satisfying filters*
``` Swift
let query = PFQuery(className:"Rides")
query.whereKey("destination", equalTo:"New York")
query.includeKey("poster")
query.findObjectsInBackground { (objects: rides, error: error) in
    if rides != nil {
        self.rides = rides!
        self.tableView.reloadData()
    }
    else
        print ("Error: \(error.localizedDescription)")
}
```

#### Filters screen
- No request, but apply new filters and reload feed screen (which makes a GET request for all rides matching filters)

#### Post ride screen
- (Create/POST) Create new ride offering
``` Swift
let ride = PFObject(className:"Rides")
ride["pickup_location"] = pickup_location.text
ride["destination_location"] = destination_location.text

ride["departure"] = departure.text
ride[arrival"] = arrival.text
ride["departure2"] = departure2.text
ride[arrival2"] = arrival2.text

let imageData = profile_picture.image!.pngData()
let file = PFFileObject(data: imageData)

ride["profile_picture"] = file
ride["driver_name"] = PFUser.current()["name"]
ride["ride_description"] = ride_description.text

ride.saveInBackground { (success, error)  in
    if (success) {
       self.dismiss(animated: true, completion: nil)
    } else {
        // There was a problem, check error.description
    }
}
```

#### Ride details screen
- (Read/GET) Get profile of poster
``` Swift
let user = ride["poster"]
let query = PFQuery(className:"User")
query.whereKey("id", equalTo: user["id"])
query.getObjectInBackground { (user, error) in
    if user != nil {
        // Success!
    } 
    else {
        print ("Error: \(error.localizedDescription)")
    }
}
```
- (Create/POST) Book ride
``` Swift
// Create the post
let myRide = get ride info
// Create the comment
let myRides = get list of my rides
myRides["ride"] = myRide
myRides.saveInBackground()
```

#### Profile (of other users) screen
- (Read/GET) Query all rides of which this user is a poster
``` Swift
let query = PFQuery(className:"Rides")
query.whereKey("user", equalTo: PFUser.current()["id"])
query.findObjectsInBackground { (objects: rides, error: error) in
    if rides != nil {
        self.rides = rides!
        self.tableView.reloadData()
    }
    else
        print ("Error: \(error.localizedDescription)")
}
```
- (Create/POST) Book ride
``` Swift
// Create the post
let myRide = get ride info
// Create the comment
let myRides = get list of my rides
myRides["ride"] = myRide
myRides.saveInBackground()
```

### Models
- User
    - fname: String
    - lname: String
    - user_id: String
    - email: String
    - profilePic: URL
    - trip_history: [Trip]
- Trip
    - tripId: String
    - posterId: String
    - tripInfo: TripInfo
    - cost: String
    - description: String
- TripInfo
    - pickupLocation: String
    - arrivalLocation: String
    - departureTime: Date
    - returnTime: Date
    - departureCoordinate: CLLocationCoordinate2D
    - arrivalCoordinate: CLLocationCoordinate2D
