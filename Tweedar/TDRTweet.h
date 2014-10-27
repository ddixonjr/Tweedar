//
//  Tweet.h
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface TDRTweet : NSObject

@property (strong, nonatomic) NSString *userHandle;
@property (strong, nonatomic) NSString *tweetText;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *avatarURLString;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithUserHandle:(NSString *)userHandle
                         tweetText:(NSString *)tweetText
                         timestamp:(NSString *)dateString
                          latitude:(NSNumber *)latitude
                         longitude:(NSNumber *)longitude;


@end
