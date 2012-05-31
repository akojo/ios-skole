//
//  LastFmVenue.m
//  GigFinder
//
//  Created by Atte Kojo on 12/23/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "LastFmVenue.h"

@interface LastFmVenue()
@property (strong) NSDictionary* venueData;
@end

@implementation LastFmVenue

@synthesize venueData = _venueData;

- (id) initWithVenueData:(NSDictionary *)data
{
    if (self = [super init])
        self.venueData = data;
    return self;
}

- (NSString *) name
{
    return [self.venueData valueForKeyPath:@"name"];
}

- (NSString *) street
{
    return [self.venueData valueForKeyPath:@"location.street"];
}

- (NSString *) city
{
    NSString *address = [NSString stringWithFormat:@"%@ %@",
                         [self.venueData valueForKeyPath:@"location.postalcode"],
                         [self.venueData valueForKeyPath:@"location.city"]];
    return address;
}

@end
