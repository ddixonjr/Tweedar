//
//  TweetController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/27/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetsController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

#define kDebugOn NO
#define kTwitterAPISearchTweetURLString @"https://api.twitter.com/1.1/search/tweets.json"
#define kTwitterAPIRetweetURLString @"https://api.twitter.com/1.1/statuses/retweet/:id.json"
#define kTwitterAPIFavoriteURLString @"https://api.twitter.com/1.1/favorites/create.json"
#define kTwitterAPIUnfavoriteURLString @"https://api.twitter.com/1.1/favorites/destroy.json"

#define kHTTPStatusCodeOK 200

#define kDefaultCoordinateParameter @"40.1323882,-75.1379737,1mi"
#define kIndexLat 0
#define kIndexLon 1
#define kZeroCoordinateArray @[@(0),@(0)]
#define kMaxTweets @"100"

@interface TDRTweetsController ()

@property (strong, nonatomic) NSMutableArray *currentTweets;
@property (strong, nonatomic) ACAccount *currentTwitterUserAccount;
@property (strong, nonatomic) ACAccountStore *accountStore;

@end


@implementation TDRTweetsController


#pragma mark - Initializer Methods

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
                if ([self.delegate respondsToSelector:@selector(didObtainTwitterAccountInTweetsController:)])
                {
                    [self.delegate didObtainTwitterAccountInTweetsController:self];
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(didFailToObtainTwitterAccountInTweetsController:)])
                {
                    [self.delegate didFailToObtainTwitterAccountInTweetsController:self];
                }
            }
        }];
    }

    return self;
}


#pragma mark - TweetController API Methods

- (TDRTweet *)tweetAtIndex:(NSInteger)index;
{
    return self.currentTweets[index];
}


- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)coordinate;
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        NSDictionary *tweetSearchParameters  = [self buildTweetSearchParametersWithCoordinate:coordinate];
        NSURL *tweetSearchURL = [NSURL URLWithString:kTwitterAPISearchTweetURLString];
        TWRequest *twitterTweetSearchRequest = [[TWRequest alloc] initWithURL:tweetSearchURL parameters:tweetSearchParameters requestMethod:TWRequestMethodGET];
        twitterTweetSearchRequest.account = self.currentTwitterUserAccount;
        [twitterTweetSearchRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
        {
            if (!error && responseData)
            {
                NSError *tweetSearchError = nil;
                NSDictionary *tweetsDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tweetSearchError];
                if (kDebugOn) NSLog(@"Tweets Pulled: %@",tweetsDictionary);

                NSArray *unsortedTweets = tweetsDictionary[@"statuses"];
                self.currentTweets = [self boxAndSortTweetsByDate:unsortedTweets];
                self.currentNumberOfTweets = self.currentTweets.count;
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.delegate tweetsDidChangeInTweetsController:self];
                });
            }
            ;
        }];
    });
}


- (void)toggleFavoriteForTweet:(TDRTweet *)tweet inBackgroundWithBlock:(void(^)(BOOL success, NSError *error))completion

{
    __block TDRTweet *tweetRefForBlock = tweet;

    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        NSString *tweetFavoriteURLString = (tweetRefForBlock.favorited) ?
            kTwitterAPIUnfavoriteURLString : kTwitterAPIFavoriteURLString;
        NSURL *tweetFavoriteURL = [NSURL URLWithString:tweetFavoriteURLString];
        NSDictionary *tweetFavoriteParameters = @{@"id":tweetRefForBlock.tweetID};

        TWRequest *twitterFavoriteRequest = [[TWRequest alloc]initWithURL:tweetFavoriteURL
                                                          parameters:tweetFavoriteParameters
                                                       requestMethod:TWRequestMethodPOST];
        twitterFavoriteRequest.account = self.currentTwitterUserAccount;

        [twitterFavoriteRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^{
                if (urlResponse.statusCode == kHTTPStatusCodeOK)
                {
                        tweetRefForBlock.favorited = !tweetRefForBlock.favorited;
                        completion(YES,nil);
                }
                else
                {
                    completion(NO,error);
                }
            });
        }];
    });
}


#pragma mark - Helper Methods

- (NSDictionary *)buildTweetSearchParametersWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *geocodeString = [NSString stringWithFormat:@"%lf,%lf,1mi",coordinate.latitude,coordinate.longitude];
    NSDictionary *tweetSearchDictionary = @{@"geocode":geocodeString,@"count":kMaxTweets};
    return tweetSearchDictionary;
}


- (NSMutableArray *)boxAndSortTweetsByDate:(NSArray *)unsortedTweets
{
    NSMutableArray *boxedAndSortedTweets = (unsortedTweets) ? [NSMutableArray array] : nil;

    for (NSDictionary *curTweet in unsortedTweets)
    {
        NSDictionary *curTweetUser = curTweet[@"user"];
        NSDictionary *curTweetCoordinateDictionary = curTweet[@"coordinates"];
        NSArray *curTweetCoordinate = (![curTweetCoordinateDictionary isEqual:[NSNull null]]) ?
                                        curTweetCoordinateDictionary[@"coordinates"] : kZeroCoordinateArray;

        NSNumber *curTweetIDNumber = curTweet[@"id"];
        NSString *curTweetID = [curTweetIDNumber stringValue];
        TDRTweet *newTweet = [[TDRTweet alloc] initWithUserHandle:curTweetUser[@"name"]
                                                          tweetID:curTweetID
                                                        tweetText:curTweet[@"text"]
                                                  timestamp:curTweet[@"created_at"]
                                                   latitude:curTweetCoordinate[kIndexLat]
                                                  longitude:curTweetCoordinate[kIndexLon]];

        newTweet.avatarURLString = (![curTweetUser[@"profile_image_url"] isEqual:[NSNull null]]) ? curTweetUser[@"profile_image_url"] : nil;
        NSNumber *curFavoriteStatusNumber = curTweet[@"favorited"];
        newTweet.favorited = [curFavoriteStatusNumber boolValue];

        [boxedAndSortedTweets addObject:newTweet];
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
