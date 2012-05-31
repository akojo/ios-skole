//
//  LastFmVenue.h
//  GigFinder
//
//  Created by Atte Kojo on 12/23/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastFmVenue : NSObject

@property (readonly) NSString* name;
@property (readonly) NSString* street;
@property (readonly) NSString* city;

- (id) initWithVenueData:(NSDictionary *)data;

@end
