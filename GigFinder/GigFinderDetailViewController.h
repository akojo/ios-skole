//
//  GigFinderDetailViewController.h
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LastFmEvent;

@interface GigFinderDetailViewController : UITableViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressCityLabel;
@property (strong, nonatomic) LastFmEvent *event;

- (void)reload;

@end
