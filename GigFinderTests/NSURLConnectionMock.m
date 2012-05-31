//
//  NSURLConnectionMock.m
//  GigFinder
//
//  Created by Sami Rosendahl on 4.5.2012.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "NSURLConnectionMock.h"

@implementation NSURLConnectionMock

@synthesize previousRequest, nextResponse, nextData;

- (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    previousRequest = request;
    handler(nextResponse, nextData, nil);
}
@end
