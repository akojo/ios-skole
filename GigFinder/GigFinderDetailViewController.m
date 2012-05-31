//
//  GigFinderDetailViewController.m
//  GigFinder
//
//  Created by Atte Kojo on 5/28/12.
//  Copyright (c) 2012 Reaktor. All rights reserved.
//

#import "GigFinderDetailViewController.h"
#import "DescriptionViewCell.h"
#import "LastFmEvent.h"
#import "LastFmVenue.h"

@interface GigFinderDetailViewController()
@property (assign) BOOL didLoadDescription;
@property (assign) CGSize webViewSize;
@property (strong) DescriptionViewCell *descriptionCell;
@end

@implementation GigFinderDetailViewController

@synthesize imageView;
@synthesize titleLabel;
@synthesize addressStreetLabel;
@synthesize addressCityLabel;
@synthesize venueNameLabel;
@synthesize event;

@synthesize didLoadDescription;
@synthesize webViewSize;
@synthesize descriptionCell;

#pragma mark - Managing the detail item

- (void) setupImage
{
    NSURL *url = [NSURL URLWithString:self.event.imageURL];
    if (url) {
        [NSURLConnection
         sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
         queue:[NSOperationQueue mainQueue]
         completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
             self.imageView.image = [UIImage imageWithData:data];
         }];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"appIcon114" ofType:@"png"];
        self.imageView.image = [UIImage imageWithContentsOfFile:path];
    }
}

- (BOOL) shouldHideDescription
{
    return [self.event.descriptionString length] == 0;
}

- (void)reload
{
    self.title = [self.event.date formattedString];
    self.titleLabel.text = self.event.title;
    self.venueNameLabel.text = self.event.venue.name;
    self.addressStreetLabel.text = self.event.venue.street;
    self.addressCityLabel.text = self.event.venue.city;

    [self setupImage];

    self.didLoadDescription = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTitleLabel:nil];
    [self setAddressStreetLabel:nil];
    [self setAddressCityLabel:nil];
    [self setVenueNameLabel:nil];
    [self setImageView:nil];
    self.descriptionCell = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Keep unnecessary sections hidden
    if ([self.event.artists count] == 0)
        return 0;
    else if ([self shouldHideDescription])
        return 1;
    else
        return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.event.artists count];
    else
        return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"Lineup", @"");
    else
        return NSLocalizedString(@"Description", @"");
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        id cell;
        if (indexPath.row == 0)
            cell = [tableView dequeueReusableCellWithIdentifier:@"HeadlinerCell"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
        [[cell textLabel] setText:[self.event.artists objectAtIndex:indexPath.row]];
        return cell;
    }
    else {
        if (!self.descriptionCell){
            self.descriptionCell = [self.tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            self.descriptionCell.webView.delegate = self;
        }
        if (!self.didLoadDescription) {
            self.didLoadDescription = YES;
            NSString *html = [NSString stringWithFormat:@"%@%@%@",
                              @"<html><head></head><body style=\"font-family:helvetica;font-size:14px;font-color:0x353535\">",
                              self.event.descriptionString,
                              @"</body></html>"];
            [self.descriptionCell.webView loadHTMLString:html baseURL:[NSURL new]];
        }
        return self.descriptionCell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return self.webViewSize.height;
    return 35;
}

#pragma mark - UIWebViewDelegate methods

- (BOOL) webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
  navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] isEqualToString:@"about:blank"])
        return YES;
    [[UIApplication sharedApplication] openURL:[request URL]];
    return NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // When calculating new size, UIWebView never shrinks, so we need to make it
    // think that its original height was 1. Go figure.
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;

    self.webViewSize = [webView sizeThatFits:webView.frame.size];
    frame = webView.frame;
    frame.size = self.webViewSize;
    webView.frame = frame;

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationNone];
}

@end
