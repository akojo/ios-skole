//
//  GigFinderAppDelegate.h
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@class LastFmDataSource;

@interface GigFinderAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    LastFmDataSource *lastFmDataSource;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) LastFmDataSource *lastFmDataSource;

@end
