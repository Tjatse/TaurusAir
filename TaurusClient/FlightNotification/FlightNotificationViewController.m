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
#import "TicketOrder.h"
#import "ThreeCharCode.h"
#import "CharCodeHelper.h"
#import "NSDateAdditions.h"
#import "TicketOrderHelper.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	
	UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (result == nil) {
		result = [[NSBundle mainBundle] loadNibNamed:@"FlightNotificationCells" owner:0 options:0][0];
	}
	
	UILabel* flightNumberLabel = (UILabel*)[result viewWithTag:100];
	UILabel* cityFromToLabel = (UILabel*)[result viewWithTag:101];
	UILabel* departureTimeLabel = (UILabel*)[result viewWithTag:102];
	UILabel* customerLabel = (UILabel*)[result viewWithTag:103];
	UILabel* leftTimeLabel = (UILabel*)[result viewWithTag:104];
	
	TicketOrder* ticketOrder = [TicketOrderHelper sharedHelper].allTicketOrders[indexPath.row];
	flightNumberLabel.text = ticketOrder.flightNumber;
	cityFromToLabel.text = [NSString stringWithFormat:@"%@ - %@"
							, ticketOrder.fromCity.cityName
							, ticketOrder.toCity.cityName];
	departureTimeLabel.text = [NSDate stringFromDate:ticketOrder.departureTime withFormat:[NSDate timestampFormatString]];
	customerLabel.text = ticketOrder.customerName;
	
	NSTimeInterval timeInterval = ticketOrder.departureTime.timeIntervalSinceNow;
	NSDate* timeIntervalDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
	leftTimeLabel.text = [NSDate stringFromDate:timeIntervalDate withFormat:[NSDate timestampFormatString]];
	
	return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int result = [TicketOrderHelper sharedHelper].allTicketOrders.count;
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
