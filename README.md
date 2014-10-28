Tweedar
=======

A basic Twitter "radar" app showing up to 100 tweets within a one-mile radius of the device's current location--fun project!


Class Reference Documentation
=============================

TDRTweetsController Class Reference
-----------------------------------
Inherits from
NSObject

Declared in
TDRTweetsController.h
TDRTweetsController.m

Overview
A controller class that abstracts the interaction with the Twitter API. It facilitates querying of Tweets within a certain proximity, retrieving individual TDRTweet instances, marking tweets as favorites, and revoking tweets as no longer being favorites. It was built to separate the functionality from and act as a service to view controllers in providing Twitter integration capabilities.

Tasks
		  delegate property
		  currentNumberOfTweets property
		– tweetAtIndex:
		– startUpdatingTweetsForNewCoordinate:
		– toggleFavoriteForTweet:inBackgroundWithBlock:
		– isFavoritedTweet:

Properties

currentNumberOfTweets
The number of tweets currently loaded and managed by an instance of TDRTweetsController.

@property (assign, nonatomic) NSInteger currentNumberOfTweets

Discussion
The number of tweets currently loaded and managed by an instance of TDRTweetsController.

Declared In
TDRTweetsController.h

delegate
Reference to the object assigned to be the delegate of an instance of TDRTweetsController.

@property (weak, nonatomic) id<TweetControllerDelegate> delegate

Discussion
Reference to the object assigned to be the delegate of an instance of TDRTweetsController.

Declared In
TDRTweetsController.h

Instance Methods

isFavoritedTweet:
Queries the local store of favorited tweet IDs to determine whether or not the tweet passed in is has been favorited.

- (BOOL)isFavoritedTweet:(TDRTweet *)tweet

Parameters
tweet
The TDRTweet instance containing the ID needed to determine whether or not the tweet has been favorited.

Discussion
Queries the local store of favorited tweet IDs to determine whether or not the tweet passed in is has been favorited.

Declared In
TDRTweetsController.h

startUpdatingTweetsForNewCoordinate:
Instructs the TDRTweetsController to query Twitter for tweets within a certain proximity of a specified geolocation.
- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate

Parameters
coordinate
The CLLocationCoordinate2D struct containing the target center geolocation around which the tweets should be located.

Discussion
Instructs the TDRTweetsController to query Twitter for tweets within a certain proximity of a specified geolocation.
Declared In
TDRTweetsController.h

toggleFavoriteForTweet:inBackgroundWithBlock:
Uses the Twitter Framework to toggle the favorite status of a tweet for the user currently logged.
- (void)toggleFavoriteForTweet:(TDRTweet *)tweet inBackgroundWithBlock:(void ( ^ ) ( BOOL success , NSError *error ))completion
Parameters
tweet
The TDRTweet instance containing the ID needed to invoke the Twitter API call on the correct tweet.
completion
The block called after a response has been received from the Twitter Framework.
Discussion
Uses the Twitter Framework to toggle the favorite status of a tweet for the user currently logged.
Declared In
TDRTweetsController.h

tweetAtIndex:
Retrieves the data model object that represents a single tweet in the current pool of tweets managed by TDRTweetsController.
- (TDRTweet *)tweetAtIndex:(NSInteger)index
Parameters
index
The index of the tweet object in the current pool of tweets.
Return Value
The instance of a TDRTweet at the index specified in the index parameter.
Discussion
Retrieves the data model object that represents a single tweet in the current pool of tweets managed by TDRTweetsController.
Declared In
TDRTweetsController.h



TweetControllerDelegate Protocol Reference
Conforms to
NSObject
Declared in
TDRTweetsController.h

Overview
A protocol to allow instances of TDRTweetsController to loosely communicate certain changes in state with its delegate object.
Tasks
		– tweetsDidChangeInTweetsController: required method
		– didObtainTwitterAccountInTweetsController:
		– didFailToObtainTwitterAccountInTweetsController:

Instance Methods
didFailToObtainTwitterAccountInTweetsController:
A delegate method called to indicate when user permission to access Twitter accounts has failed.
- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
Parameters
tweetsController
The instance of TDRTweetController that attempted the authorization.
Discussion
A delegate method called to indicate when user permission to access Twitter accounts has failed.
Declared In
TDRTweetsController.h

didObtainTwitterAccountInTweetsController:
A delegate method called to indicate when user permission to access Twitter accounts has completed.
- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
Parameters
tweetsController
The instance of TDRTweetController that completed the authorization.
Discussion
A delegate method called to indicate when user permission to access Twitter accounts has completed.
Declared In
TDRTweetsController.h

tweetsDidChangeInTweetsController:
A delegate method called to indicate when a request for tweets (as started by a call to the startUpdatingTweetsForNewCoordinate: method) has completed.
- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetsController
Parameters
tweetsController
The instance of TDRTweetController that completed the query.
Discussion
A delegate method called to indicate when a request for tweets (as started by a call to the startUpdatingTweetsForNewCoordinate: method) has completed.
Declared In
TDRTweetsController.h





TDRTweet Class Reference
Inherits from
NSObject
Declared in
TDRTweet.h
TDRTweet.m

Overview
A data model class designed to store the details of a single tweet.
Tasks
		  userHandle property
		  tweetID property
		  tweetText property
		  dateString property
		  avatarURLString property
		  coordinate property
		– initWithUserHandle:tweetID:tweetText:timestamp:latitude:longitude:

Properties
avatarURLString
The URL of the avatar image for the Twitter user who posted the tweet represented by the new instance of TDRTweet.
@property (strong, nonatomic) NSString *avatarURLString
Discussion
The URL of the avatar image for the Twitter user who posted the tweet represented by the new instance of TDRTweet.
Declared In
TDRTweet.h

coordinate
The CLLocationCoordinate2D struct storing the posting location the tweet represented by the new instance of TDRTweet.
@property (assign, nonatomic) CLLocationCoordinate2D coordinate
Discussion
The CLLocationCoordinate2D struct storing the posting location the tweet represented by the new instance of TDRTweet.
Declared In
TDRTweet.h

dateString
A string specifying the date of the tweet represented by the new instance of TDRTweet.
@property (strong, nonatomic) NSString *dateString
Discussion
A string specifying the date of the tweet represented by the new instance of TDRTweet.
Declared In
TDRTweet.h

tweetID
The unique Twitter ID of the tweet represented by the new instance of TDRTweet.
@property (strong, nonatomic) NSString *tweetID
Discussion
The unique Twitter ID of the tweet represented by the new instance of TDRTweet.
Declared In
TDRTweet.h

tweetText
The actual content of the tweet represented by the new instance of TDRTweet.
@property (strong, nonatomic) NSString *tweetText
Discussion
The actual content of the tweet represented by the new instance of TDRTweet.
Declared In
TDRTweet.h

userHandle
The user handle of the tweet.
@property (strong, nonatomic) NSString *userHandle
Discussion
The user handle of the tweet.
Declared In
TDRTweet.h


Instance Methods
initWithUserHandle:tweetID:tweetText:timestamp:latitude:longitude:
<#Description#>
- (instancetype)initWithUserHandle:(NSString *)userHandle tweetID:(NSString *)tweetID tweetText:(NSString *)tweetText timestamp:(NSString *)dateString latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
Parameters
userHandle
the user handle of the tweet represented by the new instance of TDRTweet.
tweetID
the unique Twitter ID of the tweet represented by the new instance of TDRTweet.
tweetText
the actual content of the tweet represented by the new instance of TDRTweet.
dateString
dateString a string specifying the date of the tweet represented by the new instance of TDRTweet.
latitude
the numerical latitude of the tweet represented by the new instance of TDRTweet.
longitude
the numerical longitude of the tweet represented by the new instance of TDRTweet.
Return Value
A newly initialized instance of TDRTweet.
Discussion
<#Description#>
Declared In
TDRTweet.h



TDRTweetsNearMeViewController Class Reference
Inherits from
UIViewController
Declared in
TDRTweetsNearMeViewController.h
TDRTweetsNearMeViewController.m

Overview
A concrete subclass of UIViewController that displays the geolocation of Tweets within a proximity of the running device.


TDRTweetDetailViewController Class Reference
Inherits from
UIViewController
Declared in
TDRTweetDetailViewController.h
TDRTweetDetailViewController.m

Overview
A concrete subclass of UIViewController that displays details of a specifict Tweet passed in as a TDRTweet instance via the tweet property. It also facilitates the tweet being toggled on/off as a favorite by the user.
Tasks
		  tweet property
		  tweetsController property

Properties

tweet

The TDRTweet instance passed in for it’s details to be displayed.

@property (strong, nonatomic) TDRTweet *tweet

Discussion

The TDRTweet instance passed in for it’s details to be displayed.

Declared In

TDRTweetDetailViewController.h

tweetsController

The instance of TDRTweetsController to interact with during operations to change the favorite status of the tweet being displayed.

@property (strong, nonatomic) TDRTweetsController *tweetsController

Discussion

The instance of TDRTweetsController to interact with during operations to change the favorite status of the tweet being displayed.

Declared In

TDRTweetDetailViewController.h


