//
//  GigFinderMasterViewController.h
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GigFinderDetailViewController;
@class LastFmDataSource;

@interface GigFinderMasterViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) GigFinderDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet LastFmDataSource *dataSource;

@end
