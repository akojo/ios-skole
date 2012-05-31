//
//  LastFmService.m
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

#import "LastFmService.h"
#import "LastFmEvent.h"

@interface LastFmService()
    @property id connection;
@end

@implementation LastFmService

@synthesize connection = _connection;

- (NSURL *) call:(NSString *)method withParameters:(NSDictionary *)parameters
{
    NSMutableString *urlString = [NSMutableString
                                  stringWithString:@"http://ws.audioscrobbler.com/2.0/?"];
    [urlString appendFormat:@"method=%@", method];
    [urlString appendString:@"&api_key=1ca05357b19ecb9a311fe998e20bce41"];
    [urlString appendString:@"&format=json"];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [urlString appendFormat:@"&%@=%@", key, obj];
    }];
    return [NSURL URLWithString:urlString];
}

- (id) initWithConnection:(id)connection
{
    self = [super init];
    if (self) {
        self.connection = connection;
    }
    return self;
}

- (void) getEventsWithLocation:(CLLocation *)location
                      callback:(void (^)(NSArray *events))callback
{
}

@end
