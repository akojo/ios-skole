//
//  GigFinderAppDelegate.m
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//


#import <CoreLocation/CLLocationManager.h>

#import "GigFinderAppDelegate.h"
#import "GigFinderMasterViewController.h"
#import "LastFmService.h"
#import "LastFmDataSource.h"

@interface GigFinderAppDelegate()
@property (readonly) CLLocationManager *locationManager;
@end

@implementation GigFinderAppDelegate

@synthesize window;
@synthesize locationManager;

- (LastFmDataSource *) lastFmDataSource
{
    if (!lastFmDataSource) {
        lastFmDataSource = [[LastFmDataSource alloc] init];
    }
    return lastFmDataSource;
}

- (CLLocationManager *) locationManager
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.purpose = NSLocalizedString(@"In order to show gigs near you, approximate location is needed", @"");
    }
    return locationManager;
}

- (void) fetchEvents
{
    [self.locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Nearest 5 kilometers is enough
    if (newLocation.horizontalAccuracy < 5000.0) {
        [manager stopUpdatingLocation];
        Class connection = [NSURLConnection class];
        LastFmService *service = [[LastFmService alloc] initWithConnection: connection];
        [service getEventsWithLocation:newLocation callback:^(NSArray *events) {
            [self.lastFmDataSource setEvents:events];
        }];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    id rootViewController = self.window.rootViewController;
    GigFinderMasterViewController *masterController;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        masterController = (GigFinderMasterViewController *)[splitViewController.viewControllers objectAtIndex:0];
        splitViewController.delegate = masterController;
    } else {
        masterController = (GigFinderMasterViewController *)[rootViewController topViewController];
    }
    masterController.dataSource = self.lastFmDataSource;
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self fetchEvents];
}

@end
