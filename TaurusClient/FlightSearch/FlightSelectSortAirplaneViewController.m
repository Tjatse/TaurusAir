//
//  FlightSelectSortAirplaneViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectSortAirplaneViewController.h"
#import "FlightSelectViewController.h"
#import "CRTableViewCell.h"

@interface FlightSelectSortAirplaneViewController ()

@property (nonatomic, assign) FlightSelectViewController*	parentVC;
@property (nonatomic, retain) IBOutlet UITableView*			tableView;

@end

@implementation FlightSelectSortAirplaneViewController

- (void)dealloc
{
	self.parentVC = nil;
	self.tableView = nil;
	
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"机型选择";
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int result = planeFilter().count;
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	CRTableViewCell* result = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (result == nil) {
		result = [[[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	result.textLabel.text = flightSelectPlaneFilterTypeName((FlightSelectPlaneFilterType)indexPath.row);
	result.isSelected = indexPath.row == (int)self.parentVC.planeFilter;
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.parentVC.planeFilter = (FlightSelectPlaneFilterType)indexPath.row;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
