//
//  TDRTweetsNearMeViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/24/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetsNearMeViewController.h"
#import <MapKit/MapKit.h>
#import "TweetsController.h"
#import "Tweet.h"


@interface TDRTweetsNearMeViewController () <MKMapViewDelegate,TweetControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetsMapView;
@property (assign, nonatomic) MKCoordinateRegion curRegion;
@property (assign, nonatomic) MKCoordinateSpan curSpan;
@property (strong, nonatomic) CLLocation *curLocation;
@property (strong, nonatomic) TweetsController *tweetsController;

@end


@implementation TDRTweetsNearMeViewController


#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTweetsVC];
}


#pragma mark - MKMapViewDelegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.curSpan = MKCoordinateSpanMake(0.04, 0.04);
    self.curLocation = userLocation.location;
    self.curRegion = MKCoordinateRegionMake(self.curLocation.coordinate, self.curSpan);
    [self.tweetsMapView setRegion:self.curRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"Failed to locate user: %@",error);
}


#pragma mark - TweetControllerDelegate Methods

- (void)didObtainTwitterAccountInTweetsController:(TweetsController *)tweetsController
{
    CLLocationCoordinate2D testCoordinate =  CLLocationCoordinate2DMake(40.1323882,-75.1379737);
    [self.tweetsController startUpdatingTweetsForNewCoordinate:testCoordinate];
    NSLog(@"in delegate method didObtainTwitterAccountInTwitterController");
}


- (void)didFailToObtainTwitterAccountInTweetsController:(TweetsController *)tweetsController
{
    NSLog(@"in delegate method didFailToObtainTwitterAccountInTwitterController");
}


- (void)tweetsDidChangeInTweetsController:(TweetsController *)tweetController
{
    for (int index = 0; index < tweetController.currentNumberOfTweets; index++)
    {
        NSLog(@"%@",[self.tweetsController tweetAtIndex:index]);
    }
}


#pragma mark - Helper Methods

- (void)setupTweetsVC
{
    self.tweetsMapView.delegate = self;
    self.tweetsMapView.showsUserLocation = YES;
    self.tweetsController = [[TweetsController alloc] init];
}


@end
