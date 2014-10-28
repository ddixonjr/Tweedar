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

/**
 *  A concrete subclass of UIViewController that displays details of a specifict Tweet passed in as a TDRTweet instance via the tweet property.  It also facilitates the tweet being toggled on/off as a favorite by the user.
 */
@interface TDRTweetDetailViewController : UIViewController

/**
 *  The TDRTweet instance passed in for it's details to be displayed.
*/
@property (strong, nonatomic) TDRTweet *tweet;

/**
 *  The instance of TDRTweetsController to interact with during operations to change the favorite status of the tweet being displayed.
 */
@property (strong, nonatomic) TDRTweetsController *tweetsController;

@end
