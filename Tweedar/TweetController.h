//
//  TweetController.h
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"
#import <CoreLocation/CoreLocation.h>

@class TweetController;

@protocol TweetControllerDelegate

- (void)tweetsDidChangeInTweetController:(TweetController *)tweetController;

@end


@interface TweetController : NSObject

@property (weak, nonatomic) id<TweetControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger currentNumberOfTweets;

- (Tweet *)tweetAtIndex:(NSInteger)index;
- (void)updateTweetsForNewLocation:(CLLocationCoordinate2D)coordinate;

@end
