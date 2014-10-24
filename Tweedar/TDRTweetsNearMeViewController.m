//
//  TDRTweetsNearMeViewController.m
//  Tweedar
//
//  Created by Dennis Dixon on 10/24/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "TDRTweetsNearMeViewController.h"
#import <MapKit/MapKit.h>

@interface TDRTweetsNearMeViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetsMapView;
@property (assign, nonatomic) MKCoordinateRegion curRegion;
@property (assign, nonatomic) MKCoordinateSpan curSpan;
@property (strong, nonatomic) CLLocation *curLocation;

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

#pragma mark - Helper Methods

- (void)setupTweetsVC
{
    self.tweetsMapView.delegate = self;
    self.tweetsMapView.showsUserLocation = YES;
}


@end
