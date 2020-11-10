# Data models

## Users
- user_id
- profile_picture
- first_name
- last_name
- phone_number
- school_Email
- password
- trip_history (array of trip_id) (list of all ride requests and offerings, both created and accepted)
- **optional** reviews on previous rides

## Ride offerings (trips)
- id
- driver_user_id
- pickup_location
- dropoff_location
- seats_available **optional**
- cost (or alternative form of payment)
- description
- *Optional* negotiable?

## *Optional* Messages
- NOT SURE HOW THIS WOULD WORK

**do we want ride requests and ride offerings to coalesce to a single trip type?**

## *Optional* Ride requests
- Pickup
- Destination
- Amount willing to pay
- How many seats required?
- Will they be bringing pets/luggage etc?
- Special requests? 
- *Optional* negotiable?

