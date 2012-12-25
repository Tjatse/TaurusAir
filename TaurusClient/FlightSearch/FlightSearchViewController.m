//
//  FlightSearchViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSearchViewController.h"
#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import "CharCodeHelper.h"
#import "NSString+pinyin.h"

@interface FlightSearchViewController ()

@end

@implementation FlightSearchViewController

- (void)dealloc
{
	self.singleFlightParentView = nil;
	self.singleFlightTableView = nil;
	self.doubleFlightParentView = nil;
	self.doubleFlightTableView = nil;
	
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
	self.title = @"机票搜索";
	
	[self.view addSubview:self.singleFlightParentView];
	[self.view addSubview:self.doubleFlightParentView];
	
	self.doubleFlightParentView.left = self.singleFlightParentView.width;
	
	NSString* pinyinStr = [NSString pinyinFromChiniseString:@"哈哈你妈"];
	NSLog(@"pinyinStr");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)onSwitchToDoubleFlightButtonTap:(id)sender
{
	[UIView animateWithDuration:0.3f
					 animations:^{
						 self.doubleFlightParentView.left = 0;
						 self.singleFlightParentView.left = -self.singleFlightParentView.width;
					 }
					 completion:^(BOOL finished) {
					 }];
}

- (void)onSwitchToSingleFlightButtonTap:(id)sender
{
	[UIView animateWithDuration:0.3f
					 animations:^{
						 self.doubleFlightParentView.left = self.singleFlightParentView.width;
						 self.singleFlightParentView.left = 0;
					 }
					 completion:^(BOOL finished) {
					 }];
}

#pragma mark - tableview methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* result;
	
	if (tableView == self.singleFlightTableView) {
		if (indexPath.row == 0) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:0];
		} else if (indexPath.row == 1) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:1];
		} else {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:2];
		}
	} else {
		if (indexPath.row == 0) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:0];
		} else if (indexPath.row == 1) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:1];
		} else if (indexPath.row == 2) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:2];
		} else {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:3];
		}
	}
	
	return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.singleFlightTableView)
		return 3;
	else
		return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
