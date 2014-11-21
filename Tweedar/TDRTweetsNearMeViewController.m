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
#import "TDRTweetPointAnnotation.h"

#define kDebugOn YES
#define kDefaultCoordinateSpanLat 0.07
#define kDefaultCoordinateSpanLon 0.07
#define kDefaultCoordinateLat 37.3321082
#define kDefaultCoordinateLon -122.0307465
#define kLocationAccuracyTolerance 2000
#define kLocationAccuracyPinpoint 1.0
#define kLocationAltitudeDefault 0.0
#define kLocationDistanceFilterDefault 100.0
#define kTweetPinAnnotationReuseID @"TweetPin"
#define kDefaultTweetRefreshInterval 60.0
#define kFastRefreshInterval 2.0
#define klocationEnableAlertViewIndexSettings 0
#define klocationEnableAlertViewIndexOK 0

#define kAlertViewID_LocationServicesDisabled 1001


@interface TDRTweetsNearMeViewController () <MKMapViewDelegate,CLLocationManagerDelegate,TweetControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetsMapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tweetRefreshActivityIndicatorView;

@property (strong, nonatomic) TDRTweetsController *tweetsController;

@property (assign, nonatomic) MKCoordinateRegion curRegion;
@property (assign, nonatomic) MKCoordinateSpan curSpan;
@property (strong, nonatomic) CLLocation *curLocation;
@property (strong, nonatomic) CLLocation *defaultCurrentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLAuthorizationStatus locationAuthStatus;

@property (assign, nonatomic) BOOL tweetCurrentlySelected;
@property (assign, nonatomic) BOOL locationDetermined;
@property (assign, nonatomic) BOOL twitterAccessAuthorized;

@end


@implementation TDRTweetsNearMeViewController


#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTweetsVC];
    [self attemptToStartLocationServices];
    [self attemptToStartTweetsController];
    [self startTweetsUpdateCycle];
}


#pragma mark - Setup, VC Loop, & TweetsControllerDelegate Methods

- (void)setupTweetsVC
{
    [self.tweetRefreshActivityIndicatorView stopAnimating];
    self.tweetsMapView.delegate = self;
//    self.tweetsMapView.showsUserLocation = YES;
    self.tweetCurrentlySelected = NO;
}


- (void)attemptToStartLocationServices
{
    self.locationDetermined = NO;
    self.locationAuthStatus = [CLLocationManager authorizationStatus];
    NSLog(@"locationAuthStatus = %ld",(long)self.locationAuthStatus);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    switch (self.locationAuthStatus)
    {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Access Current Location"
                                                            message:@"Location Services must be enabled for Tweedar in Settings"
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"OK", nil];
            // Tagging this UIAlertView to be distiguishable in alertView:clickedButtonAtIndex:
            alert.tag = kAlertViewID_LocationServicesDisabled;
            [alert show];
            break;
        }
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            [self.locationManager startUpdatingLocation];
    }
}


- (void)attemptToStartTweetsController
{
    self.twitterAccessAuthorized = NO;
    self.tweetsController = [[TDRTweetsController alloc] init];
    self.tweetsController.delegate = self;
    [self.tweetsController attemptTwitterAccessAuthorization];  // Look for result in either of the delegate callback methods didObtainTwitterAccountInTweetsController: or didFailToObtainTwitterAccountInTweetsController:
}


- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
{
    if (kDebugOn) NSLog(@"In didObtainTwitterAccountInTweetsController - Found a Twitter Account");

    self.twitterAccessAuthorized = YES;
}


- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
{
    if (kDebugOn) NSLog(@"In didFailToObtainTwitterAccountInTwitterController - Failed to find Twitter Account");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Start Tweedar"
                                                    message:@"Please authorize Tweedar to access Twitter in Settings"
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
//    Decide to abort() or display an "idle" view here
}


// This TweetsControllerDelegate method drives the continuous refresh of the tweets map view using NSTimer
- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetController
{
    NSInteger nextRefreshInterval = kFastRefreshInterval;

    if (tweetController.currentNumberOfTweets > 0)
    {
        [self.tweetRefreshActivityIndicatorView stopAnimating];
        nextRefreshInterval = kDefaultTweetRefreshInterval;
    }

    for (int index = 0; index < tweetController.currentNumberOfTweets; index++)
    {
        if (kDebugOn) NSLog(@"%@",[self.tweetsController tweetAtIndex:index]);
        [self annotateMapWithTweet:[self.tweetsController tweetAtIndex:index] withIndex:index];
    }

    [NSTimer scheduledTimerWithTimeInterval:nextRefreshInterval
                                     target:self
                                   selector:@selector(startTweetsUpdateCycle)
                                   userInfo:nil
                                    repeats:NO];
}

// This scheduled helper method sends the message to the TDRTweetsController object to get a fresh set of tweets
- (void)startTweetsUpdateCycle
{
    // Avoid starting a new cycle if the user has a tweet selected
    if ([self isReadyToQueryTwitter])
    {
        NSArray *allCurAnnotations = self.tweetsMapView.annotations;
        [self.tweetsMapView removeAnnotations:allCurAnnotations];
        [self.tweetRefreshActivityIndicatorView startAnimating];
        [self.tweetsController startUpdatingTweetsForCoordinate:self.curLocation.coordinate];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:kFastRefreshInterval
                                         target:self
                                       selector:@selector(startTweetsUpdateCycle)
                                       userInfo:nil
                                        repeats:NO];
    }
}


#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *tweetPin;

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        tweetPin = nil;
    }
    else if ([annotation isKindOfClass:[TDRTweetPointAnnotation class]])
    {
        MKPinAnnotationView *newTweetPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                           reuseIdentifier:kTweetPinAnnotationReuseID];
        TDRTweetPointAnnotation *tweetAnnotation = (TDRTweetPointAnnotation *) annotation;
        if (kDebugOn) NSLog(@"annotation title: %@", [annotation title]);
        newTweetPin.tag = tweetAnnotation.tweetIndex;
        newTweetPin.canShowCallout = YES;
        newTweetPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        tweetPin = newTweetPin;
    }

    return tweetPin;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.tweetCurrentlySelected = YES;
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    self.tweetCurrentlySelected = NO;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (kDebugOn) NSLog(@"the tag of the view callout pressed is %ld",(long)view.tag);
    [self performSegueWithIdentifier:@"TweetDetailSegue" sender:view];
}


#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus - status = %ld", (long)status);

    self.locationAuthStatus = status;

    if (status >= kCLAuthorizationStatusAuthorized)
    {
        self.locationManager.desiredAccuracy = kLocationAccuracyTolerance;
        self.locationManager.distanceFilter = kLocationDistanceFilterDefault;
        [self.locationManager startUpdatingLocation];
    }
    else if (status != kCLAuthorizationStatusNotDetermined)
    {
        CLLocationCoordinate2D defaultLocationCoordinate = CLLocationCoordinate2DMake(kDefaultCoordinateLat,kDefaultCoordinateLon);
        self.defaultCurrentLocation = [[CLLocation alloc] initWithCoordinate:defaultLocationCoordinate
                                                                    altitude:kLocationAltitudeDefault
                                                          horizontalAccuracy:kLocationAccuracyPinpoint
                                                            verticalAccuracy:kLocationAccuracyPinpoint
                                                                   timestamp:[NSDate date]];
        self.curLocation = self.defaultCurrentLocation;
        self.locationDetermined = YES;
        [self setTweetMapViewToCoordinate:self.curLocation.coordinate];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *curLocation in locations)
    {
        if (curLocation.verticalAccuracy < kLocationAccuracyTolerance &&
            curLocation.horizontalAccuracy < kLocationAccuracyTolerance)
        {
            self.locationDetermined = YES;
            [self.locationManager stopUpdatingLocation];
            self.curLocation = curLocation;
            [self setTweetMapViewToCoordinate:self.curLocation.coordinate];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Detect Current Location"
                                                    message:@"Will continue to retry and default location until successful."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    [self setMapToDefaultLocation];
    [self refreshCurrentLocation];
}


#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (alertView.tag)
    {
        case kAlertViewID_LocationServicesDisabled:
        {
            if (buttonIndex == klocationEnableAlertViewIndexSettings)
            {
                if (&UIApplicationOpenSettingsURLString != NULL)
                {
                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Start Settings App"
                                                                    message:@"Using default location"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];

                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                message:@"Using default location"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];

                [alert show];
            }
        }
        default:  ;
    }

//    if (self.shouldUseDefaultLocation)
//    {
//        [self setMapToDefaultLocation];
//        [self startTweetsUpdateCycle];
//    }
}





#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetDetailSegue"])
    {
        TDRTweetDetailViewController *tweetDetailVC = segue.destinationViewController;
        MKPinAnnotationView *tweetPointAnnotationView = (MKPinAnnotationView *) sender;
        tweetDetailVC.tweet = [self.tweetsController tweetAtIndex:tweetPointAnnotationView.tag];
        if (kDebugOn) NSLog(@"in prepareForSegue: -- the tweet at tag %ld is %@",(long)tweetPointAnnotationView.tag,tweetDetailVC.tweet);
        tweetDetailVC.tweetsController = self.tweetsController;
    }
}


#pragma mark - Helper Methods


- (void)annotateMapWithTweet:(TDRTweet *)tweet withIndex:(NSInteger)index
{
    TDRTweetPointAnnotation *tweetAnnotation = [[TDRTweetPointAnnotation alloc] init];
    tweetAnnotation.title = tweet.userHandle;
    tweetAnnotation.coordinate = tweet.coordinate;
    tweetAnnotation.subtitle = tweet.tweetText;
    tweetAnnotation.tweetIndex = index;
    [self.tweetsMapView addAnnotation:tweetAnnotation];
}


- (void)setTweetMapViewToCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.curSpan = MKCoordinateSpanMake(kDefaultCoordinateSpanLat, kDefaultCoordinateSpanLon);
    self.curRegion = MKCoordinateRegionMake(coordinate, self.curSpan);
    [self.tweetsMapView setRegion:self.curRegion animated:YES];

}

- (BOOL)isReadyToQueryTwitter
{
    return (!self.tweetCurrentlySelected && self.locationDetermined && self.twitterAccessAuthorized);
}


- (void)setMapToDefaultLocation
{
    self.curLocation = self.defaultCurrentLocation;
    [self setTweetMapViewToCoordinate:self.curLocation.coordinate];
}

- (void)refreshCurrentLocation
{
    if (kCLAuthorizationStatusAuthorized)
    {
        [self.locationManager startUpdatingLocation];
    }
}


@end
