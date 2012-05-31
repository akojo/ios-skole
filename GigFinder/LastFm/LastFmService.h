//
//  LastFmService.h
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface LastFmService : NSObject
- (id) initWithConnection:(id)connection;
- (void) getEventsWithLocation:(CLLocation *)location
                      callback:(void (^)(NSArray *events))callback;
@end
