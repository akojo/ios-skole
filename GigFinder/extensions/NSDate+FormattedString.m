//
//  NSDate+FormattedString.m
//  GigFinder
//
//  Created by Atte Kojo on 12/23/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "NSDate+FormattedString.h"

@implementation NSDate (FormattedString)

- (NSString *) formattedString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, dd MMMM"];
    return [formatter stringFromDate:self];
}

@end
