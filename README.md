# Ridesio

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Ridesio is a rideshare bulletin board iOS app for college campuses that lets users request or post upcoming rides. Ridesio provides a communal, sustainable way of ridesharing for college students.


### App Evaluation
- **Category:**
- **Mobile:**
- **Story:**
- **Market:**
- **Habit:**
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional) and Screen Archetypes

#### Launch screen/AppIcon
- User sees app icon in home screen and styled launch screen.

#### Get started Screen
- User sees a login screen when opening the app for the first time (like Lyft/Uber)
- User stays logged in across restarts and goes straight to the Feed Screen.
- User can sign up to create a new account.
    - first name
    - last name
    - phone number
    - school email address (*Optional* verify this somehow with institution)
    - password
    - profile picture (can upload from camera or camera roll)
- User can log in.

#### Feed screen (both ride request and ride offering)
- User can click button to open settings menu (like on Uber/Lyft).
- User can view their profile in a profile tab.
- *Optional*: User can see all ride offerings and requests in a single view.
- *Optional*: User can sort rides by different criteria (distance, cost)
- *Optional*: User can search for rides

#### Feed: Ride offering screen
- User can see a list of all nearby ride offerings.
- User can create a new ride offering.
- User can accept a nearby ride offering.
- User can click a ride offering to see the details page.
- User sees button that links to their own profile.

#### Create ride offering screen
- User can specify
    - pickup *Optionally can use current location to specify pickup*
    - destination
    - *Optional* seats available (for v2 have confirmation/messaging through app and auto update seats available)
    - cost (or alternative form of payment)
    - special requests/conditions (i.e. no pets? luggage? etc)
    - *Optional* negotiable? if so, users can message poster to discuss alternate pickup/destination/cost

#### Ride offering details Screen
- User sees
    - pickup
    - destination
    - *Optional* seats available (for v2 have confirmation/messaging through app and auto update seats available)
    - *Optional*: map data (like on Uber or Lyft)
    - cost (or alternative form of payment)
    - special requests/conditions (i.e. no pets? luggage? etc)
    - *Optional* negotiable? if so, users can message poster to discuss alternate pickup/destination/cost
- User can press button to contact poster of offering.
    - "To confirm your trip, email poster and let them know how many seats you need."
- Creator of ride offering can edit details.
- *Optional* User can message poster of offering.

#### Profile screen (for others)
- User can see
    - Profile picture
    - First name
    - Last initial
    - *Optional* Number of trips taken (add when the userbase is more established)
    - Trips currently being offered (slightly different UI so that it's clear this isn't the main feed)
    - *Optional*: Star rating

#### Settings screen
- Account details
- *Optional* Messsages
- User can log out

#### Account details screen (user's own profile)
- User can see their own
    - First name
    - Last name
    - Phone number
    - Email
    - Profile picture
        - By touching the profile picture, users can open the camera or pick a camera from the camera roll.
- *Optional* User can edit their email
- *Optional* Trip History (past rides)
- Upcoming trips (same as on profile screen for others)
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

### [Hand Drawn Sketch](https://github.com/tanjyy/ridesio/blob/main/notes/Ride%20share%20wireframes.pdf")

### Digital Wireframes & Mockups
![Post Ride](https://raw.githubusercontent.com/tanjyy/ridesio/main/notes/MVP-wireframes.png?token=AEJ776WKYADX5ZOMPOZDJVK7U5IIG)

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
