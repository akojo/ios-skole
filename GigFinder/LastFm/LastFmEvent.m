//
//  LastFmEvent.m
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "LastFmEvent.h"
#import "LastFmVenue.h"

@interface LastFmEvent()
@property (retain) NSDictionary *eventData;

- (id) initWithEventData:(NSDictionary *)eventData;
@end

@implementation LastFmEvent

@synthesize eventData;

+ (id) eventWithData:(NSDictionary *)eventData
{
    return [[self alloc] initWithEventData:eventData];
}

- (id) initWithEventData:(NSDictionary *)data
{
    if (self = [super init]) {
        self.eventData = data;
    }
    return self;
}

- (NSDate *) parseDate:(NSString *)dateString
{   
    NSString *dateFormat = @"EEE, dd MMM yyyy";
    id dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    return [dateFormatter
            dateFromString:[dateString substringToIndex:[dateFormat length]]];
}

- (NSDate *) date
{
    return [self parseDate:[self.eventData valueForKey:@"startDate"]];    
}

- (NSString *) title
{
    return [self.eventData valueForKey:@"title"];
}

- (LastFmVenue *) venue
{
    return [[LastFmVenue alloc]
            initWithVenueData:[self.eventData valueForKey:@"venue"]];
}

- (NSArray *) artists
{
    id artists = [self.eventData valueForKeyPath:@"artists.artist"];
    if ([artists respondsToSelector:@selector(objectAtIndex:)])
        return artists;
    else
        return [NSArray arrayWithObject:artists];
}

- (NSString *) imageURL
{
    NSArray *images = [self.eventData valueForKey:@"image"];
    NSInteger idx = [images indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj valueForKey:@"size"] isEqualToString:@"extralarge"];
    }];
    return [[images objectAtIndex:idx] valueForKey:@"#text"];
}

- (NSString *) descriptionString
{
    return [self.eventData valueForKey:@"description"];
}

@end
