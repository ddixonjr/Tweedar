//
//  TweetDetailViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetDetailViewController.h"

@interface TDRTweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateString;
@property (weak, nonatomic) IBOutlet UILabel *tweetCoordinateLabel;

@end

@implementation TDRTweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"Tweet by %@",self.tweet.userHandle];
    self.tweetDateString.text = self.tweet.dateString;
    self.tweetCoordinateLabel.text = [NSString stringWithFormat:@"Latitude: %lf  - Longitude: %lf",self.tweet.coordinate.latitude,self.tweet.coordinate.longitude];
    self.tweetTextView.text = self.tweet.tweetText;
}


@end
