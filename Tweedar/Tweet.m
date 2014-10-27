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

@end
