//
//  TweetDetailViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetDetailViewController.h"

#define kDebugOn YES


@interface TDRTweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivityView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateString;
@property (weak, nonatomic) IBOutlet UILabel *tweetCoordinateLabel;

@end

@implementation TDRTweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"Tweet by %@",self.tweet.userHandle];
    self.tweetDateString.text = self.tweet.dateString;
    self.tweetCoordinateLabel.text = [NSString stringWithFormat:@"Lat: %0.4lf, Lon: %0.4lf",self.tweet.coordinate.latitude,self.tweet.coordinate.longitude];
    self.tweetTextView.text = self.tweet.tweetText;
    [self retrieveAvatar];
}


- (void)retrieveAvatar
{
    [self.avatarActivityView startAnimating];
    if (self.tweet.avatarURLString.length)
    {
        if (kDebugOn) NSLog(@"avatarURLString = %@", self.tweet.avatarURLString);
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);
        dispatch_async(backgroundQueue,^{
            NSURL *avatarURL = [NSURL URLWithString:self.tweet.avatarURLString];
            NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
            if (avatarData)
            {
                UIImage *avatarImage = [UIImage imageWithData:avatarData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.avatarActivityView stopAnimating];
                    self.avatarImageView.image = avatarImage;
                });
            }
        });
    }
}

@end
