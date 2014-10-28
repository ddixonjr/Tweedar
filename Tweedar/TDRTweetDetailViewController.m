//
//  TweetDetailViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetDetailViewController.h"

#define kDebugOn NO
#define kUnfavoriteTitleText @"Unfavorite"
#define kFavoriteTitleText @"Favorite"


@interface TDRTweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivityView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateString;
@property (weak, nonatomic) IBOutlet UILabel *tweetCoordinateLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation TDRTweetDetailViewController


#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVC];
}


#pragma mark - IBAction Methods

- (IBAction)onRetweetButtonPressed
{
    if (kDebugOn) NSLog(@"Retweet Button Pressed");
}


- (IBAction)onFavoriteButtonPressed
{
    if (kDebugOn) NSLog(@"Favorite Button Pressed");
    [self.tweetsController toggleFavoriteForTweet:self.tweet inBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (success)
        {
            NSLog(@"Tweet After Favorite: %@", self.tweet);
            [self setFavoriteButtonStatus];
        }
        else
        {
            if (kDebugOn) NSLog(@"Attempt to change favorite status failed: %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Change Favorite Status"
                                                            message:@"Please try again later"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}


#pragma mark - Helper Methods

- (void)setupVC
{
    self.title = [NSString stringWithFormat:@"Tweet by %@",self.tweet.userHandle];
    self.tweetDateString.text = self.tweet.dateString;
    self.tweetCoordinateLabel.text = [NSString stringWithFormat:@"Lat: %0.4lf, Lon: %0.4lf",self.tweet.coordinate.latitude,self.tweet.coordinate.longitude];
    self.tweetTextView.text = self.tweet.tweetText;
    [self setFavoriteButtonStatus];
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


- (void)setFavoriteButtonStatus
{
    if ([self.tweetsController isFavoritedTweet:self.tweet])
    {
        [self.favoriteButton setTitle:kUnfavoriteTitleText forState:UIControlStateNormal];
    }
    else
    {
        [self.favoriteButton setTitle:kFavoriteTitleText forState:UIControlStateNormal];
    }
}
@end
