//
//  Tweet.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweet.h"


@implementation TDRTweet

- (instancetype)initWithUserHandle:(NSString *)userHandle
                           tweetID:(NSString *)tweetID
                         tweetText:(NSString *)tweetText
                         timestamp:(NSString *)dateString
                          latitude:(NSNumber *)latitude
                         longitude:(NSNumber *)longitude
{
    self = [super init];
    if (self)
    {
        _userHandle = userHandle;
        _tweetID = tweetID;
        _tweetText = tweetText;
        _dateString = dateString;
        _coordinate = CLLocationCoordinate2DMake([longitude doubleValue], [latitude doubleValue]);
    }
    return self;
}


#pragma mark - Overidden Superclass Methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"Tweet - text = %@,text = %@,dateString = %@ lat = %lf  lon = %lf",
            self.userHandle,
            self.tweetText,
            self.dateString,
            self.coordinate.latitude,
            self.coordinate.longitude];
}

@end
