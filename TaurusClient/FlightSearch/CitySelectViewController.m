//
//  CitySelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "CitySelectViewController.h"
#import "CharCodeHelper.h"
#import "CityGroup.h"
#import "City.h"

@interface CitySelectViewController ()

@end

@implementation CitySelectViewController

- (void)dealloc
{
	self.filterKeyBar = nil;
	self.cityListView = nil;
	self.citySelectedBlock = nil;
	
	[super dealloc];
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
    
	self.title = @"城市选择";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	return [allCityGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section];
	City* city = [cityGroup.cities objectAtIndex:indexPath.row];
	
	cell.textLabel.text = city.cityName;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
	
	return [cityGroup.cities count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
		
	return cityGroup.groupName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.citySelectedBlock != nil) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section];
		City* city = [cityGroup.cities objectAtIndex:indexPath.row];

		self.citySelectedBlock(city);
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
