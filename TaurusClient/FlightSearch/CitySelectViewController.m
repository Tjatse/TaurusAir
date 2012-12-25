//
//  CitySelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "UIViewAdditions.h"
#import "CitySelectViewController.h"
#import "CharCodeHelper.h"
#import "CityGroup.h"
#import "City.h"
#import "UIBarButtonItem+ButtonMaker.h"

@interface CitySelectViewController () <UIScrollViewDelegate>

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
	((UIScrollView*)self.cityListView).delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	return [allCityGroups count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	if (indexPath.section == 0) {
		[cell addSubview:self.filterKeyBar];
		return cell;
	}
	
	if ([cell.subviews containsObject:self.filterKeyBar])
		[self.filterKeyBar removeFromSuperview];
	
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section - 1];
	City* city = [cityGroup.cities objectAtIndex:indexPath.row];
	
	cell.textLabel.text = city.cityName;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 1;
	
	--section;
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
	
	return [cityGroup.cities count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return nil;
	
	--section;
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
		
	return cityGroup.groupName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		return;
	
	if (self.citySelectedBlock != nil) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section - 1];
		City* city = [cityGroup.cities objectAtIndex:indexPath.row];

		if (self.citySelectedBlock != nil)
			self.citySelectedBlock(city);
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSMutableArray* result = [NSMutableArray array];
	NSArray* allCityGroups = [CharCodeHelper allCityGroups];
	
	[result addObject:UITableViewIndexSearch];
	
	for (CityGroup* cityGroup in allCityGroups) {
		[result addObject:cityGroup.groupName];
	}
	
	return result;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.filterKeyBar resignFirstResponder];
}

@end
