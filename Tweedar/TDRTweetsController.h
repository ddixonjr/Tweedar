//
//  TweetController.h
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDRTweet.h"
#import <CoreLocation/CoreLocation.h>

@class TDRTweetsController;

/**
 *  A protocol to allow instances of TDRTweetsController to loosely communicate certain changes in state with its delegate object.
 */
@protocol TweetControllerDelegate <NSObject>

@required
/**
 *  A delegate method called to indicate when a request for tweets (as started by a call to the startUpdatingTweetsForNewCoordinate: method) has completed.
 *
 *  @param tweetsController The instance of TDRTweetController that completed the query.
 */
- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetsController;

@optional
/**
 *  A delegate method called to indicate when user permission to access Twitter accounts has completed.
 *
 *  @param tweetsController The instance of TDRTweetController that completed the authorization.
 */
- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController;

/**
 *  A delegate method called to indicate when user permission to access Twitter accounts has failed.
 *
 *  @param tweetsController The instance of TDRTweetController that attempted the authorization.
 */
- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController;

@end

/**
 A controller class that abstracts the interaction with the Twitter API.  It facilitates querying of Tweets within a certain proximity, retrieving individual TDRTweet instances, marking tweets as favorites, and revoking tweets as no longer being favorites.  It was built to separate the functionality from and act as a service to view controllers in providing Twitter integration capabilities.
 */
@interface TDRTweetsController : NSObject

/**
 *  Reference to the object assigned to be the delegate of an instance of TDRTweetsController.
 */
@property (weak, nonatomic) id<TweetControllerDelegate> delegate;


/**
 *  The number of tweets currently loaded and managed by an instance of TDRTweetsController.
 */
@property (assign, nonatomic) NSInteger currentNumberOfTweets;

/**
 *  Retrieves the data model object that represents a single tweet in the current pool of tweets managed by TDRTweetsController.
 *
 *  @param index The index of the tweet object in the current pool of tweets.
 *
 *  @return The instance of a TDRTweet at the index specified in the index parameter.
 */
- (TDRTweet *)tweetAtIndex:(NSInteger)index;


/**
 *  Instructs the TDRTweetsController to query Twitter for tweets within a certain proximity of a specified geolocation.
 *
 *  @param coordinate The CLLocationCoordinate2D struct containing the target center geolocation around which the tweets should be located.
 */
- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate;


/**
 *  Uses the Twitter Framework to toggle the favorite status of a tweet for the user currently logged.
 *
 *  @param tweet      The TDRTweet instance containing the ID needed to invoke the Twitter API call on the correct tweet.
 *  @param completion The block called after a response has been received from the Twitter Framework.
 */
- (void)toggleFavoriteForTweet:(TDRTweet *)tweet inBackgroundWithBlock:(void(^)(BOOL success, NSError *error))completion;

/**
 *  Queries the local store of favorited tweet IDs to determine whether or not the tweet passed in is has been favorited.
 *
 *  @param tweet      The TDRTweet instance containing the ID needed to determine whether or not the tweet has been favorited.
 */
- (BOOL)isFavoritedTweet:(TDRTweet *)tweet;

@end
