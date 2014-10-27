//
//  TDRTweetsNearMeViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/24/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetsNearMeViewController.h"
#import <MapKit/MapKit.h>
#import "TDRTweetsController.h"
#import "TDRTweet.h"
#import "TDRTweetDetailViewController.h"

#define kDefaultCoordinateSpanLat 0.07
#define kDefaultCoordinateSpanLon 0.07
#define kDefaultCoordinateLat 40.1323882
#define kDefaultCoordinateLon -75.1379737
#define kTweetPinAnnotationReuseID @"TweetPin"


@interface TDRTweetsNearMeViewController () <MKMapViewDelegate,TweetControllerDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetsMapView;
@property (assign, nonatomic) MKCoordinateRegion curRegion;
@property (assign, nonatomic) MKCoordinateSpan curSpan;
@property (strong, nonatomic) CLLocation *curLocation;
@property (strong, nonatomic) TDRTweetsController *tweetsController;
@property (strong, nonatomic) CLLocationManager *locationManager;

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
    self.curLocation = userLocation.location;
    [self setTweetMapViewToCoordinate:self.curLocation.coordinate];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    self.curLocation = [[CLLocation alloc] initWithLatitude:kDefaultCoordinateLat longitude:kDefaultCoordinateLon];
    [self setTweetMapViewToCoordinate:self.curLocation.coordinate];
    NSLog(@"Failed to locate user - using default location: %@",error);
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *tweetPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kTweetPinAnnotationReuseID];
    tweetPin.canShowCallout = YES;
    tweetPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    tweetPin.tag = ;
    return tweetPin;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"TweetDetailSegue" sender:view];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *curLocation in locations)
    {
        if (curLocation.verticalAccuracy < 1000 && curLocation.horizontalAccuracy < 1000)
        {
            [self.locationManager stopUpdatingLocation];
            self.curLocation = curLocation;
            [self setTweetMapViewToCoordinate:self.curLocation.coordinate];

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Detect Current Location"
                                                    message:@"..."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

#pragma mark - TweetControllerDelegate Methods

- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
{
    CLLocationCoordinate2D testCoordinate =  CLLocationCoordinate2DMake(kDefaultCoordinateLat,kDefaultCoordinateLon);
    [self.tweetsController startUpdatingTweetsForNewCoordinate:testCoordinate];
    NSLog(@"in delegate method didObtainTwitterAccountInTwitterController");
}


- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Find a Twitter Account"
                                                    message:@"Please authorize Tweedar to access Twitter in Settings"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"in delegate method didFailToObtainTwitterAccountInTwitterController");
}


- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetController
{
    for (int index = 0; index < tweetController.currentNumberOfTweets; index++)
    {
        NSLog(@"%@",[self.tweetsController tweetAtIndex:index]);
        [self annotateMapWithTweet:[self.tweetsController tweetAtIndex:index]];
    }

}


#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetDetailSegue"])
    {
        TDRTweetDetailViewController *tweetDetailVC = segue.destinationViewController;
        MKPinAnnotationView *tweetPointAnnotationView = (MKPinAnnotationView *) sender;
        tweetDetailVC.tweet = [self.tweetsController tweetAtIndex:tweetPointAnnotationView.tag];
    }
}


#pragma mark - Helper Methods

- (void)setupTweetsVC
{
    self.tweetsMapView.delegate = self;
    self.tweetsMapView.showsUserLocation = YES;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    self.tweetsController = [[TDRTweetsController alloc] init];
    self.tweetsController.delegate = self;
}


- (void)annotateMapWithTweet:(TDRTweet *)tweet
{
    MKPointAnnotation *tweetAnnotation = [[MKPointAnnotation alloc] init];
    tweetAnnotation.title = tweet.userHandle;
    tweetAnnotation.coordinate = tweet.coordinate;
    tweetAnnotation.subtitle = tweet.tweetText;
    [self.tweetsMapView addAnnotation:tweetAnnotation];
}


- (void)setTweetMapViewToCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.curSpan = MKCoordinateSpanMake(kDefaultCoordinateSpanLat, kDefaultCoordinateSpanLon);
    self.curRegion = MKCoordinateRegionMake(coordinate, self.curSpan);
    [self.tweetsMapView setRegion:self.curRegion animated:YES];

}

@end
