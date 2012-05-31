//
//  LastFmEvent.h
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LastFmVenue;

@interface LastFmEvent : NSObject {
    NSDictionary *eventData;
}

@property (readonly) NSDate *date;
@property (readonly) NSString* title;
@property (readonly) LastFmVenue* venue;
@property (readonly) NSArray* artists;
@property (readonly) NSString* imageURL;
@property (readonly) NSString* descriptionString;

+ (id) eventWithData:(NSDictionary *)eventData;

@end
