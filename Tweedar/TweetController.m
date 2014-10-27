//
//  TweetController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TweetController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

#define kTwitterAPISearchTweetURLString @"https://api.twitter.com/1.1/search/tweets.json"
#define kDefaultCoordinateParameter @"40.1323882,-75.1379737,1mi"


@interface TweetController ()

@property (strong, nonatomic) NSMutableArray *currentTweets;
@property (strong, nonatomic) ACAccount *currentTwitterUserAccount;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) TWRequest *twitterRequest;

@end


@implementation TweetController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        ACAccountStore *accountStore = self.accountStore;
        ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                _currentTwitterUserAccount = [twitterAccounts firstObject];
                if ([self.delegate respondsToSelector:@selector(didObtainTwitterAccountInTwitterController:)])
                {
                    [self.delegate didObtainTwitterAccountInTwitterController:self];
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(didFailToObtainTwitterAccountInTwitterController:)])
                {
                    [self.delegate didFailToObtainTwitterAccountInTwitterController:self];
                }
            }
        }];
    }

    return self;
}


#pragma mark - TweetController API Methods

- (Tweet *)tweetAtIndex:(NSInteger)index;
{
    return self.currentTweets[index];
}


- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate;
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        NSDictionary *tweetSearchParameters  = [self buildTweetSearchParametersWithCoordinate:coordinate];
        NSURL *tweetSearchURL = [NSURL URLWithString:kTwitterAPISearchTweetURLString];
        self.twitterRequest = [[TWRequest alloc] initWithURL:tweetSearchURL parameters:tweetSearchParameters requestMethod:TWRequestMethodGET];
        [self.twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
        {
            if (!error && responseData)
            {
                NSError *tweetSearchError = nil;
                NSDictionary *tweetsDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tweetSearchError];
                NSArray *unsortedTweets = tweetsDictionary[@"statuses"];

                [self.delegate tweetsDidChangeInTweetController:self];
            }
            ;
        }];
    });
}


#pragma mark - Helper Methods

- (NSDictionary *)buildTweetSearchParametersWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *geocodeString = [NSString stringWithFormat:@"%lf,%lf,1mi",coordinate.latitude,coordinate.longitude];
    NSDictionary *tweetSearchDictionary = @{@"geocode":geocodeString};
    return tweetSearchDictionary;
}

- (NSMutableArray *)boxAndSortTweetsByDate:(NSArray *)unsortedTweets
{
    NSMutableArray *boxedAndSortedTweets = (unsortedTweets) ? [NSMutableArray array] : nil;

    for (NSDictionary *curTweet in unsortedTweets)
    {
        Tweet *newTweetBox = [[Tweet alloc] initWithUserHandle:curTweet[@""]
                                                     tweetText:curTweet[@""]
                                                     timestamp:curTweet[@""]];

    }

    return boxedAndSortedTweets;
}

#pragma mark - Overidden Accessors

- (ACAccountStore *)accountStore
{
    if (!_accountStore)
    {
        _accountStore = [[ACAccountStore alloc] init];
    }

    return _accountStore;
}



@end
