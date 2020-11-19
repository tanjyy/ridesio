# Schema (network requests per screen)
## Log in screen
- (Create/POST) User signup **should fail if user is already signed up/if password is too weak/email is already in use**
- (Read/GET) User login **should fail if username is not taken/password is wrong**

## Feed screen
- (Read/GET) Query all rides *optionally satisfying filters* (use default filter settings if none applied, i.e. within radius of 20 miles)
- (Create/POST) Book ride **should fail if user already booked this ride/user is not email-verified** *discuss not booking from the feed screen, have it only on the details screen*

## Filters screen
- No request, but apply new filters and reload feed screen (which makes a GET request for all rides matching filters)

## Post ride screen
- (Create/POST) Create new ride offering **should fail if user is not email-verified**

## Ride details screen
- (Read/GET) Get profile of poster
- (Create/POST) Book ride **should fail if user already booked this ride (which includes if they are the poster)/user is not email-verified**

## Account details/personal profile screen
- **Optional** (Update/PUT) Update ride details of your posting 

## Profile (of other users) screen (touching one's own profile photo should lead to account details screen, not here)
- (Read/GET) Query all rides of which this user is a poster
- (Create/POST) Book ride **should fail if user already booked this ride/user is not email-verified**
