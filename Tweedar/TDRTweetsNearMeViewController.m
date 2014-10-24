//
//  TDRTweetsNearMeViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/24/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetsNearMeViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#define kTwitterAPIURL @"https://api.twitter.com/1.1/search/tweets.json"

@interface TDRTweetsNearMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSDictionary *tweetsDictionary;
@property (strong, nonatomic) TWRequest *twRequest;
@property (strong, nonatomic) ACAccount *currentUserAccount;

@end


@implementation TDRTweetsNearMeViewController


#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTweetsVC];
    [self getTweetsNearMe];
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    NSDictionary *curTweet = self.tweets[indexPath.row];
    tweetCell.textLabel.text = curTweet[@"created_at"];
    return tweetCell;
}


#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Helper Methods

- (void)setupTweetsVC
{
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;

//    self.tweets = @[@"Tweet One", @"Tweet Two", @"Tweet Three"];
}

- (void)getTweetsNearMe
{
    NSURL *tweetsURL = [NSURL URLWithString:kTwitterAPIURL];
    NSDictionary *paramDictionary = @{@"geocode":@"40.1323882,-75.1379737,1mi",@"result_type":@"recent"};
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
            NSLog(@"twitterAccounts: %@",twitterAccounts);

            self.twRequest = [[TWRequest alloc] initWithURL:tweetsURL parameters:paramDictionary requestMethod:TWRequestMethodGET];
            self.twRequest.account = [twitterAccounts firstObject];
            [self.twRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (responseData)
                {
                    NSError *jsonSerializationError = nil;
                    self.tweetsDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonSerializationError];
                    if (!jsonSerializationError)
                    {
//                        NSLog(@"Tweets Near Me Dictionary: %@",self.tweetsDictionary);
                        self.tweets = self.tweetsDictionary[@"statuses"];
                        NSLog(@"Tweets Near Me Array: %@",self.tweets);
                        [self.tweetsTableView reloadData];
                    }
                }
            }];

        }
        else
        {
            NSLog(@"Access to Twitter accounts not granted");
        }

    }];

}

@end
