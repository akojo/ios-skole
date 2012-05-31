//
//  LastFmServiceTest.m
//  GigFinder
//
//  Created by Sami Rosendahl on 4.5.2012.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "LastFmServiceTest.h"
#import <CoreLocation/CLLocationManager.h>
#import "LastFmService.h"
#import "LastFmEvent.h"
#import "LastFmVenue.h"
#import "NSURLConnectionMock.h"

@interface LastFmServiceTest()
@property (nonatomic,strong) NSURLConnectionMock *connectionMock;
@property (nonatomic,strong) LastFmService *service;
@property (nonatomic,readonly) CLLocation *testLocation;
@property BOOL callbackCalled;
@end

@implementation LastFmServiceTest

@synthesize connectionMock = _connectionMock;
@synthesize service = _service;
@synthesize callbackCalled = _callbackCalled;

- (void)setUp
{
    [super setUp];

    self.connectionMock = [NSURLConnectionMock new];
    self.connectionMock.nextResponse = [NSURLResponse new];
    self.connectionMock.nextData = [NSData data];
    self.service = [[LastFmService alloc] initWithConnection: self.connectionMock];
    self.callbackCalled = NO;
}

- (void)tearDown
{
    self.connectionMock = nil;
    self.service = nil;

    [super tearDown];
}

- (CLLocation*)testLocation
{
    return [[CLLocation alloc] initWithLatitude: 0 longitude: 0];
}

- (NSData*)loadTestDataWithName:(NSString*)name ofType:(NSString*)type
{
    NSBundle* testBundle = [NSBundle bundleForClass:[self class]];  // See http://stackoverflow.com/questions/3067015/ocunit-nsbundle
    NSString* path = [testBundle pathForResource:name ofType:type];
    STAssertNotNil(path, [NSString stringWithFormat: @"Could not find test data \"%@.%@\"", name, type]);
    return [NSData dataWithContentsOfFile:path];
}

- (void)testEmptyResponse
{
    [self.service getEventsWithLocation:self.testLocation callback:^(NSArray *events) {
        self.callbackCalled = YES;
        STAssertEquals([events count], (NSUInteger)0, @"Expected no events for empty response");
    }];
    STAssertTrue(self.callbackCalled, @"Expected that event callback is called");
}

- (void)testRequestURL
{
    CLLocation* location = [[CLLocation alloc] initWithLatitude:37.78584 longitude:-122.4064];
    NSString* expectedLat = [NSString stringWithFormat:@"lat=%@",
                             [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue]];
    NSString* expectedLon = [NSString stringWithFormat:@"lon=%@",
                             [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue]];
    NSArray* expectedComponents = [NSArray arrayWithObjects: 
                                   @"method=geo.getEvents", @"format=json", expectedLat, expectedLon, nil];
    
    [self.service getEventsWithLocation:location callback:^(NSArray *events) {
        self.callbackCalled = YES;
        NSURL* requestURL = [self.connectionMock.previousRequest URL];
        NSArray* queryComponents = [[requestURL query] componentsSeparatedByString:@"&"];
        for (NSString* expected in expectedComponents) {
            STAssertTrue([queryComponents containsObject:expected], 
                         [NSString stringWithFormat:@"Expected to find %@ in request URL query", expected]);
        }
    }];
    STAssertTrue(self.callbackCalled, @"Expected that event callback is called");
}

- (void)testSingleEventResponse
{
    self.connectionMock.nextData = [self loadTestDataWithName:@"SingleEventResponse" ofType:@"json"];

    [self.service getEventsWithLocation:self.testLocation callback:^(NSArray *events) {
        self.callbackCalled = YES;
        STAssertEquals([events count], (NSUInteger)1,
                       @"Expected one event");
        LastFmEvent* event = [events objectAtIndex:0];
        
        // event.date
        NSDateComponents* dateComps = [[NSDateComponents alloc] init];
        [dateComps setYear:2012];
        [dateComps setMonth:5];
        [dateComps setDay:9];
        [dateComps setWeekday:4];
        NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate* expectedDate = [cal dateFromComponents: dateComps];
        STAssertTrue([event.date timeIntervalSinceDate: expectedDate] < 12*60*60,
                     @"Expected event date to match 09 Wed May 2012");
        
        NSDictionary* expectedValues = [NSDictionary dictionaryWithObjectsAndKeys:
         @"The Soundtrack of our Lives", @"title",
         @"Tavastia", @"venue.name",
         @"Urho Kekkosen katu 4-6", @"venue.street",
         @"00100 Helsinki", @"venue.city",
         [NSArray arrayWithObjects: @"The Soundtrack of our Lives", nil], @"artists",
         @"http://userserve-ak.last.fm/serve/252/38269027.png", @"imageURL",
         @"#Test description#", @"descriptionString",
         nil];
        [expectedValues enumerateKeysAndObjectsUsingBlock:^(id keyPath, id expected, BOOL *stop) {
            STAssertEqualObjects([event valueForKeyPath:keyPath], expected,
                                 [NSString stringWithFormat:@"Expected event.%@ equal \"%@\"", keyPath, [expected description]]);
        }];
    }];
    STAssertTrue(self.callbackCalled, @"Expected that event callback is called");
}

- (void)testMultipleEventsResponse
{
    self.connectionMock.nextData = [self loadTestDataWithName:@"MultipleEventsResponse" ofType:@"json"];

    [self.service getEventsWithLocation:self.testLocation callback:^(NSArray *events) {
        self.callbackCalled = YES;
        // Don't check all event attributes, just that we have expected event titles
        // Decoding other attributes is tested in testSingleEventResponse
        NSMutableSet* expectedTitles = [NSMutableSet setWithObjects:
                                   @"The Soundtrack of our Lives",
                                   @"JYTÄFEST 2012",
                                   @"Dumari ja Spuget-Stikkaa lamppuun eldis",
                                   nil];
        NSArray* eventTitles = [events valueForKeyPath:@"title"];
        [expectedTitles minusSet:[NSSet setWithArray:eventTitles]];
        STAssertEquals([expectedTitles count], (NSUInteger)0,
                       [NSString stringWithFormat:@"Expected to see events with titles %@", [expectedTitles description]]);
    }];
    STAssertTrue(self.callbackCalled, @"Expected that event callback is called");
}

@end
