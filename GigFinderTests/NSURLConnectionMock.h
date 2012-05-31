//
//  NSURLConnectionMock.h
//  GigFinder
//
//  Created by Sami Rosendahl on 4.5.2012.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

@interface NSURLConnectionMock : NSObject
@property (readonly) NSURLRequest* previousRequest;
@property (strong) NSURLResponse* nextResponse;
@property (strong) NSData* nextData;
- (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;
@end
