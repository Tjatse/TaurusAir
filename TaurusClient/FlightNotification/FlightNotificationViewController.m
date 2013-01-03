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
@property (nonatomic, assign) dispatch_source_t			timer;

- (UITableViewCell*)makeCell;
- (void)startWatchDog;
- (void)stopWatchDog;

@end

@implementation FlightNotificationViewController

- (void)dealloc
{
	self.tableView = nil;
	[self stopWatchDog];
	
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

	[self startWatchDog];
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

- (void)startWatchDog
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	_timer = dispatch_source_create(
									DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
									queue);
	
	dispatch_source_set_timer(_timer,
							  dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
							  1.0 * NSEC_PER_SEC, 0);
	
	dispatch_source_set_event_handler(_timer, ^{
		dispatch_async(dispatch_get_main_queue(), ^{
//			[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows
//								  withRowAnimation:UITableViewRowAnimationFade];
			
			[self.tableView reloadData];
		});
	});
	
	dispatch_resume(_timer);
}

- (void)stopWatchDog
{
	dispatch_release(_timer);
	_timer = nil;
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
	
	NSTimeInterval timeInterval = [ticketOrder.departureTime timeIntervalSinceDate:[NSDate date]];
//	NSLog(@"dt %@:", ticketOrder.departureTime);
//	NSLog(@"now %@:", [NSDate date]);
//	NSLog(@"timeinterval: %f", timeInterval);
	
	int seconds = timeInterval;
	
	// 秒
	int second = seconds % 60;
	int minutes = 0;
	int hours = 0;
	int days = 0;
	
	seconds = seconds - second;
	if (seconds > 0) {
		minutes = seconds / 60;
		
		if (minutes >= 60) {
			hours = minutes / 60;
			minutes -= hours * 60;
			
			if (hours >= 24) {
				days = hours / 24;
				hours -= days * 24;
			}
		}
	}
	
	NSMutableString* leftTimeStr = [NSMutableString string];
	if (days > 0)
		[leftTimeStr appendFormat:@"%d天 ", days];
	
	if (hours > 0)
		[leftTimeStr appendFormat:@"%d小时 ", hours];
	
	if (minutes > 0)
		[leftTimeStr appendFormat:@"%d分 ", minutes];
	
	if (second > 0)
		[leftTimeStr appendFormat:@"%d秒", second];
	
	leftTimeLabel.text = leftTimeStr;
	
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
