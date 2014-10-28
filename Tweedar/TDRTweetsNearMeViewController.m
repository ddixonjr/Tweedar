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

#define kDebugOn NO
#define kDefaultCoordinateSpanLat 0.07
#define kDefaultCoordinateSpanLon 0.07
#define kDefaultCoordinateLat 40.1323882
#define kDefaultCoordinateLon -75.1379737
#define kLocationAccuracyTolerance 2000

#define kTweetPinAnnotationReuseID @"TweetPin"
#define kDefaultTweetRefreshInterval 15.0


@interface TDRTweetsNearMeViewController () <MKMapViewDelegate,CLLocationManagerDelegate,TweetControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetsMapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshActivityView;

@property (strong, nonatomic) TDRTweetsController *tweetsController;

@property (assign, nonatomic) MKCoordinateRegion curRegion;
@property (assign, nonatomic) MKCoordinateSpan curSpan;
@property (strong, nonatomic) CLLocation *curLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation TDRTweetsNearMeViewController


#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTweetsVC];
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
        MKPinAnnotationView *newTweetPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kTweetPinAnnotationReuseID];
        TDRTweetPointAnnotation *tweetAnnotation = (TDRTweetPointAnnotation *) annotation;
        if (kDebugOn) NSLog(@"annotation title: %@", [annotation title]);
        newTweetPin.tag = tweetAnnotation.tweetIndex;
        newTweetPin.canShowCallout = YES;
        newTweetPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        tweetPin = newTweetPin;
    }

    return tweetPin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (kDebugOn) NSLog(@"the tag of the view callout pressed is %ld",view.tag);
    [self performSegueWithIdentifier:@"TweetDetailSegue" sender:view];
}


#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *curLocation in locations)
    {
        if (curLocation.verticalAccuracy < kLocationAccuracyTolerance &&
            curLocation.horizontalAccuracy < kLocationAccuracyTolerance)
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
                                                    message:@"Please enable location services for Tweedar in the Settings App"
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
    [self.refreshActivityView startAnimating];
    if (kDebugOn) NSLog(@"in delegate method didObtainTwitterAccountInTwitterController");

}


- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)tweetsController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Find a Twitter Account"
                                                    message:@"Please authorize Tweedar to access Twitter in Settings"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    if (kDebugOn) NSLog(@"in delegate method didFailToObtainTwitterAccountInTwitterController");
}


- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)tweetController
{
    [self.refreshActivityView stopAnimating];
    for (int index = 0; index < tweetController.currentNumberOfTweets; index++)
    {
        if (kDebugOn) NSLog(@"%@",[self.tweetsController tweetAtIndex:index]);
        [self annotateMapWithTweet:[self.tweetsController tweetAtIndex:index] withIndex:index];
    }

    [NSTimer scheduledTimerWithTimeInterval:kDefaultTweetRefreshInterval target:self selector:@selector(refreshTweetMap) userInfo:nil repeats:NO];
}


#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetDetailSegue"])
    {
        TDRTweetDetailViewController *tweetDetailVC = segue.destinationViewController;
        MKPinAnnotationView *tweetPointAnnotationView = (MKPinAnnotationView *) sender;
        tweetDetailVC.tweet = [self.tweetsController tweetAtIndex:tweetPointAnnotationView.tag];
        if (kDebugOn) NSLog(@"in prepareForSegue: -- the tweet at tag %ld is %@",tweetPointAnnotationView.tag,tweetDetailVC.tweet);
        tweetDetailVC.tweetsController = self.tweetsController;
    }
}


#pragma mark - Helper Methods

- (void)setupTweetsVC
{
    [self.refreshActivityView stopAnimating];
    self.refreshActivityView.tintColor = [UIColor blueColor];

    self.tweetsMapView.delegate = self;
    self.tweetsMapView.showsUserLocation = YES;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    self.tweetsController = [[TDRTweetsController alloc] init];
    self.tweetsController.delegate = self;
}


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


- (void)refreshTweetMap
{
    NSArray *allCurAnnotations = self.tweetsMapView.annotations;
    [self.tweetsMapView removeAnnotations:allCurAnnotations];
    [self.refreshActivityView startAnimating];
    [self.tweetsController startUpdatingTweetsForNewCoordinate:self.curLocation.coordinate];
}


@end
