//
//  FlightSelectSortCorpViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectSortCorpViewController.h"
#import "FlightSelectViewController.h"
#import "TwoCharCode.h"
#import "AirportSearchHelper.h"
#import "CharCodeHelper.h"

@interface FlightSelectSortCorpViewController ()

@property (nonatomic, assign) FlightSelectViewController*	parentVC;

@end

@implementation FlightSelectSortCorpViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int result = [CharCodeHelper allTwoCharCodes].count + 1;
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (result == nil) {
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	result.textLabel.text = indexPath.row == 0
		? flightSelectCorpFilterTypeName(nil)
		: flightSelectCorpFilterTypeName([[CharCodeHelper allTwoCharCodes] objectAtIndex:indexPath.row - 1]);
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.parentVC.corpFilter = indexPath.row == 0
		? nil
		: [[CharCodeHelper allTwoCharCodes] objectAtIndex:indexPath.row - 1];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
