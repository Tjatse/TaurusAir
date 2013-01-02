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
#import "CitySearchHelper.h"
#import "SearchCityResult.h"

@interface CitySelectViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray*		searchResults;

@end

@implementation CitySelectViewController

- (void)dealloc
{
	self.filterKeyBar = nil;
	self.cityListView = nil;
	self.citySelectedBlock = nil;
	self.searchResults = nil;
	self.defaultCityName = nil;
	
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
	
	if (self.defaultCityName.length > 0) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		
		int n = 0;
		for (CityGroup* cityGroup in allCityGroups) {
			int m = 0;
			for (City* city in cityGroup.cities) {
				if ([city.cityName isEqualToString:self.defaultCityName]) {
					[self.cityListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:m inSection:n]
											 atScrollPosition:UITableViewScrollPositionBottom
													 animated:YES];
					
					break;
				}
				
				++m;
			}
			
			++n;
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.cityListView) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		return [allCityGroups count];
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	if (tableView == self.cityListView) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section];
		City* city = [cityGroup.cities objectAtIndex:indexPath.row];
		
		cell.textLabel.text = city.cityName;
		
		if (self.defaultCityName.length > 0) {
			if ([city.cityName isEqualToString:self.defaultCityName]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	} else {
		SearchCityResult* city = [self.searchResults objectAtIndex:indexPath.row];
		
		if (city.reason.length == 0)
			cell.textLabel.text = city.city.cityName;
		else
			cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", city.city.cityName, city.reason];
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.cityListView) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
		
		return [cityGroup.cities count];
	} else {
		int result = self.searchResults.count;
		return result;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.cityListView) {
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		CityGroup* cityGroup = [allCityGroups objectAtIndex:section];
			
		return cityGroup.groupName;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.citySelectedBlock != nil) {
		if (tableView == self.cityListView) {
			NSArray* allCityGroups = [CharCodeHelper allCityGroups];
			CityGroup* cityGroup = [allCityGroups objectAtIndex:indexPath.section];
			City* city = [cityGroup.cities objectAtIndex:indexPath.row];

			self.citySelectedBlock(city);
		} else {
			SearchCityResult* city = [self.searchResults objectAtIndex:indexPath.row];
			self.citySelectedBlock(city.city);
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == self.cityListView) {
		NSMutableArray* result = [NSMutableArray array];
		NSArray* allCityGroups = [CharCodeHelper allCityGroups];
		
	//	[result addObject:UITableViewIndexSearch];
		
		for (CityGroup* cityGroup in allCityGroups) {
			[result addObject:cityGroup.groupName];
		}
		
		return result;
	} else {
		return nil;
	}
}

#pragma mark - scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.filterKeyBar resignFirstResponder];
	[self.filterKeyBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - searchbar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.filterKeyBar setShowsCancelButton:NO animated:YES];
	[self.filterKeyBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self.filterKeyBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	self.searchResults = [CitySearchHelper queryCityWithFilterKey:searchText];
}

@end
