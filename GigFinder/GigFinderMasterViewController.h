//
//  GigFinderMasterViewController.h
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GigFinderDetailViewController;

@interface GigFinderMasterViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) GigFinderDetailViewController *detailViewController;

@end
