//
//  FlightNotificationViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "FlightNotificationViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIViewAdditions.h"

@interface FlightNotificationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*		tableView;

- (UITableViewCell*)makeCell;

@end

@implementation FlightNotificationViewController

- (void)dealloc
{
	self.tableView = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"航班提醒";
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																			   andTapCallback:^(id control, UIEvent *event) {
																				   [self dismissModalViewControllerAnimated:YES];
																			   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - core methods

- (UITableViewCell *)makeCell
{
	UITableViewCell* result = [[NSBundle mainBundle] loadNibNamed:@"FlightNotificationCells" owner:nil options:nil][0];
	return result;
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* resultCell = [self makeCell];
	float result = resultCell.height;
	
	return result;
}


@end
