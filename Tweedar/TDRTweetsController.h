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

@protocol TweetControllerDelegate <NSObject>

@required
- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetsController;

@optional
- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController;
- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController;

@end


@interface TDRTweetsController : NSObject

@property (weak, nonatomic) id<TweetControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger currentNumberOfTweets;
@property (strong, nonatomic) NSMutableArray *favorites;

- (TDRTweet *)tweetAtIndex:(NSInteger)index;
- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)toggleFavoriteForTweet:(TDRTweet *)tweet inBackgroundWithBlock:(void(^)(BOOL success, NSError *error))completion;
- (BOOL)isFavoritedTweet:(TDRTweet *)tweet;

@end
