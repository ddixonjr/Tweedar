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

@class TweetsController;

@protocol TweetControllerDelegate <NSObject>

@required
- (void)tweetsDidChangeInTweetsController:(TweetsController *)tweetsController;

@optional
- (void)didObtainTwitterAccountInTweetsController:(TweetsController *)tweetsController;
- (void)didFailToObtainTwitterAccountInTweetsController:(TweetsController *)tweetsController;

@end


@interface TweetsController : NSObject

@property (weak, nonatomic) id<TweetControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger currentNumberOfTweets;

- (Tweet *)tweetAtIndex:(NSInteger)index;
- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate;

@end
