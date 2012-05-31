//
//  LastFmDataSource.h
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LastFmEvent;

@interface LastFmDataSource : NSObject <UITableViewDataSource>

@property (weak) UITableView *tableView;

- (void) setEvents:(NSArray *)events;
- (LastFmEvent *) eventAtIndexPath:(NSIndexPath *)indexPath;
@end
