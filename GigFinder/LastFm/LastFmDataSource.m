//
//  LastFmDataSource.m
//  GigFinder
//
//  Created by Atte Kojo on 12/21/11.
//  Copyright (c) 2011 Reaktor. All rights reserved.
//

#import "LastFmDataSource.h"
#import "LastFmEvent.h"
#import "LastFmVenue.h"
#import "EventCell.h"

@interface LastFmDataSource()
@property (strong) NSMutableDictionary *eventData;
@end

@implementation LastFmDataSource

@synthesize eventData = _eventData;
@synthesize tableView = _tableView;

- (void) addEvent:(id)event forDate:(NSDate *)date
{    
    NSMutableArray *events = [self.eventData objectForKey:date];
    if (!events) {
        events = [NSMutableArray array];
        [self.eventData setObject:events forKey:date];
    }
    [events addObject:event];
}

- (void) setEvents:(NSArray *)events
{
    self.eventData = [NSMutableDictionary dictionary];
    [events enumerateObjectsUsingBlock:^(LastFmEvent *event,
                                         NSUInteger idx,
                                         BOOL *stop)
    {
        [self addEvent:event forDate:event.date];
    }];
    [self.tableView reloadData];
}

- (id) dateForSectionIndex:(NSInteger)index
{
    return [[[self.eventData allKeys] sortedArrayUsingSelector:@selector(compare:)]
            objectAtIndex:index];
}

- (NSArray *) sectionForIndex:(NSInteger)index
{
    if ([self.eventData count] > 0)
        return [self.eventData objectForKey:[self dateForSectionIndex:index]];
    else
        return [NSArray array];
}

- (LastFmEvent *) eventAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self sectionForIndex:indexPath.section]
            objectAtIndex:indexPath.row];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX([self.eventData count], 1);
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionForIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = (EventCell *)[tableView
                                    dequeueReusableCellWithIdentifier:@"EventCell"];
    LastFmEvent *event = [self eventAtIndexPath:indexPath];

    cell.title.text = event.title;
    cell.venue.text = event.venue.name;
    
    return cell;
}

- (BOOL) isToday:(NSDate *)date
{
    return ([date earlierDate:[NSDate date]] == date);
}

- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    if ([self.eventData count] > 0) {
        NSDate *date = [self dateForSectionIndex:section];
        
        if ([self isToday:date])
            return NSLocalizedString(@"Today", @"");
        else
            return [date formattedString];

    }
    else {
        return NSLocalizedString(@"Loading gigs...", @"");
    }
    return nil;
}

@end
