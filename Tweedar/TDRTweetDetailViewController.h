//
//  TweetDetailViewController.h
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDRTweet.h"
#import "TDRTweetsController.h"

@interface TDRTweetDetailViewController : UIViewController

@property (strong, nonatomic) TDRTweet *tweet;
@property (strong, nonatomic) TDRTweetsController *tweetsController;

@end
