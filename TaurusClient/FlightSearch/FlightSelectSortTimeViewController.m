//
//  FlightSelectSortTimeViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectSortTimeViewController.h"
#import "FlightSelectViewController.h"

@interface FlightSelectSortTimeViewController ()

@property (nonatomic, assign) FlightSelectViewController*	parentVC;

@end

@implementation FlightSelectSortTimeViewController

- (void)dealloc
{
	self.parentVC = nil;
	
	[super dealloc];
}

- (id)initWithParentVC:(FlightSelectViewController *)aParentVC
{
	if (self = [super init]) {
		self.parentVC = aParentVC;
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"时间选择";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int result = timeFilters().count;
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (result == nil) {
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	result.textLabel.text = flightSelectTimeFilterTypeName((FlightSelectTimeFilterType)indexPath.row);
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.parentVC.timeFilter = (FlightSelectTimeFilterType)indexPath.row;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
