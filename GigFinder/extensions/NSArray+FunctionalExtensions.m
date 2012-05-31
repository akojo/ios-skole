//
//  NSArray+FunctionalExtensions.m
//  GigFinder
//
//  Created by Atte Kojo on 12/23/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "NSArray+FunctionalExtensions.h"

@implementation NSArray (FunctionalExtensions)

- (NSArray *) map:(id (^)(id obj))transform
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [results addObject:transform(obj)];
    }];
    return [NSArray arrayWithArray:results];
}

@end
