//
//  NSArray+FunctionalExtensions.h
//  GigFinder
//
//  Created by Atte Kojo on 12/23/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FunctionalExtensions)

- (NSArray *) map:(id (^)(id obj))transform;

@end
