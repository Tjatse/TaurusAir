//
//  FlightSelectSortMainViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectSortMainViewController.h"
#import "FlightSelectViewController.h"
#import "TwoCharCode.h"
#import "FlightSelectSortTimeViewController.h"
#import "FlightSelectSortAirplaneViewController.h"
#import "FlightSelectSortCorpViewController.h"

@interface FlightSelectSortMainViewController ()

@property (nonatomic, assign) FlightSelectViewController*	parentVC;

@end

@implementation FlightSelectSortMainViewController

#pragma mark - life cycle

- (void)dealloc
{
	self.parentVC = nil;
	self.dataVw = nil;
	
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
    
	self.title = @"航班筛选";
	self.dataVw.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.dataVw reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		UITableViewCell* result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														  reuseIdentifier:nil] autorelease];
		
		result.textLabel.text = @"时间选择";
		result.detailTextLabel.text = flightSelectTimeFilterTypeName(self.parentVC.timeFilter);
		
		return result;
	} else if (indexPath.section == 1) {
		UITableViewCell* result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														  reuseIdentifier:nil] autorelease];
		
		result.textLabel.text = @"机型";
		result.detailTextLabel.text = flightSelectPlaneFilterTypeName(self.parentVC.planeFilter);
		
		return result;
	} else {
		UITableViewCell* result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														  reuseIdentifier:nil] autorelease];
		
		result.textLabel.text = @"航空公司";
		result.detailTextLabel.text = flightSelectCorpFilterTypeName(self.parentVC.corpFilter);
		
		return result;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		FlightSelectSortTimeViewController* vc = [[FlightSelectSortTimeViewController alloc] initWithParentVC:self.parentVC];
		[self.navigationController pushViewController:vc animated:YES];
		SAFE_RELEASE(vc);
	} else if (indexPath.section == 1) {
		FlightSelectSortAirplaneViewController* vc = [[FlightSelectSortAirplaneViewController alloc] initWithParentVC:self.parentVC];
		[self.navigationController pushViewController:vc animated:YES];
		SAFE_RELEASE(vc);
	} else if (indexPath.section == 2) {
		FlightSelectSortCorpViewController* vc = [[FlightSelectSortCorpViewController alloc] initWithParentVC:self.parentVC];
		[self.navigationController pushViewController:vc animated:YES];
		SAFE_RELEASE(vc);
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
