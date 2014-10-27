//
//  Tweet.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

- (instancetype)initWithUserHandle:(NSString *)userHandle
                         tweetText:(NSString *)tweetText
                         timestamp:(NSString *)dateString
                          latitude:(double)latitude
                         longitude:(double)longitude
{
    self = [super init];
    if (self)
    {
        _userHandle = userHandle;
        _tweetText = tweetText;
        _dateString = dateString;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Tweet - text = %@,text = %@,dateString = %@",
            self.userHandle,
            self.tweetText,
            self.dateString];
}

@end
