//
//  Tweet.h
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 *  A data model class designed to store the details of a single tweet.
 *
 */
@interface TDRTweet : NSObject

/**
 *  The user handle of the tweet.
 *
 */
@property (strong, nonatomic) NSString *userHandle;

/**
 *  The unique Twitter ID of the tweet represented by the new instance of TDRTweet.
 *
 */
@property (strong, nonatomic) NSString *tweetID;

/**
 *  The actual content of the tweet represented by the new instance of TDRTweet.
 *
 */
@property (strong, nonatomic) NSString *tweetText;

/**
 *  A string specifying the date of the tweet represented by the new instance of TDRTweet.
 *
 */
@property (strong, nonatomic) NSString *dateString;

/**
 *  The URL of the avatar image for the Twitter user who posted the tweet represented by the new instance of TDRTweet.
 *
 */
@property (strong, nonatomic) NSString *avatarURLString;

/**
 *  The CLLocationCoordinate2D struct storing the posting location the tweet represented by the new instance of TDRTweet.
 *
 */
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

/**
 *  An overidden init method that initializes the essential properties of a new instance of TDRTweet.
 *
 *  @param  userHandle  the user handle of the tweet represented by the new instance of TDRTweet.
 *  @param  tweetID  the unique Twitter ID of the tweet represented by the new instance of TDRTweet.
 *  @param  tweetText  the actual content of the tweet represented by the new instance of TDRTweet.
 *  @param  dateString  a string specifying the date of the tweet represented by the new instance of TDRTweet.
 *  @param  latitude  the numerical latitude of the tweet represented by the new instance of TDRTweet.
 *  @param  longitude  the numerical longitude of the tweet represented by the new instance of TDRTweet.
 *
 *  @return The newly initialized instance of TDRTweet.
 */- (instancetype)initWithUserHandle:(NSString *)userHandle
                           tweetID:(NSString *)tweetID
                         tweetText:(NSString *)tweetText
                         timestamp:(NSString *)dateString
                          latitude:(NSNumber *)latitude
                         longitude:(NSNumber *)longitude;

@end
