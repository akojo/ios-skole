//
//  GigFinderMasterViewController.m
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "GigFinderMasterViewController.h"
#import "GigFinderDetailViewController.h"
#import "LastFmDataSource.h"
#import "LastFmEvent.h"

@implementation GigFinderMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize dataSource;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (GigFinderDetailViewController *)[self.splitViewController.viewControllers lastObject];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    self.title = NSLocalizedString(@"Gigs", @"");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.detailViewController setEvent:[self.dataSource eventAtIndexPath:indexPath]];
    [self.detailViewController reload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *senderPath = [self.tableView indexPathForCell:sender];
    LastFmEvent *event = [self.dataSource eventAtIndexPath:senderPath];
    [segue.destinationViewController setEvent:event];
}

@end
