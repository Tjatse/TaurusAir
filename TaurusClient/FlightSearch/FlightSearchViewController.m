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
#import "City.h"
#import "CitySelectViewController.h"
#import "CAAnimation+AnimationBlock.h"

@interface FlightSearchViewController ()

@property (nonatomic, retain) City*		singleFlightDepartureCity;
@property (nonatomic, retain) City*		doubleFlightDepartureCity;
@property (nonatomic, retain) City*		doubleFlightArrivalCity;

@end

@implementation FlightSearchViewController

- (void)dealloc
{
	self.singleFlightParentView = nil;
	self.singleFlightTableView = nil;
	self.doubleFlightParentView = nil;
	self.doubleFlightTableView = nil;
	self.singleFlightDepartureCity = nil;
	self.doubleFlightDepartureCity = nil;
	self.doubleFlightArrivalCity = nil;
	
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
	
	self.doubleFlightParentView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)onSwitchToDoubleFlightButtonTap:(id)sender
{
	self.doubleFlightParentView.hidden = NO;
	self.doubleFlightParentView.layer.opacity = 1.0f;
	
	CABasicAnimation* disappearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
	disappearAni.removedOnCompletion = YES;
	disappearAni.fromValue = [NSNumber numberWithFloat:0.0f];
	disappearAni.toValue = [NSNumber numberWithFloat:1.0f];
	
	[self.doubleFlightParentView.layer addAnimation:disappearAni forKey:nil];

	self.singleFlightParentView.layer.opacity = 0.0f;
	CABasicAnimation* appearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
	appearAni.removedOnCompletion = YES;
	appearAni.fromValue = [NSNumber numberWithFloat:1.0f];
	appearAni.toValue = [NSNumber numberWithFloat:0.0f];
	[appearAni setAnimationDidStartBlock:nil
				andAnimationDidStopBlock:^(CAAnimation *anim, BOOL finished) {
					self.singleFlightParentView.hidden = YES;
				}];
	
	[self.singleFlightParentView.layer addAnimation:appearAni forKey:nil];
}

- (void)onSwitchToSingleFlightButtonTap:(id)sender
{
	self.singleFlightParentView.hidden = NO;
	self.singleFlightParentView.layer.opacity = 1.0f;
	
	CABasicAnimation* disappearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
	disappearAni.removedOnCompletion = YES;
	disappearAni.fromValue = [NSNumber numberWithFloat:0.0f];
	disappearAni.toValue = [NSNumber numberWithFloat:1.0f];
	
	[self.singleFlightParentView.layer addAnimation:disappearAni forKey:nil];
	
	self.doubleFlightParentView.layer.opacity = 0.0f;
	CABasicAnimation* appearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
	appearAni.removedOnCompletion = YES;
	appearAni.fromValue = [NSNumber numberWithFloat:1.0f];
	appearAni.toValue = [NSNumber numberWithFloat:0.0f];
	[appearAni setAnimationDidStartBlock:nil
				andAnimationDidStopBlock:^(CAAnimation *anim, BOOL finished) {
					self.doubleFlightParentView.hidden = YES;
				}];
	
	[self.doubleFlightParentView.layer addAnimation:appearAni forKey:nil];
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
	if (tableView == self.singleFlightTableView) {
		if (indexPath.row == 0) {
			CitySelectViewController* vc = [[CitySelectViewController alloc] init];
			vc.citySelectedBlock = ^(City* city) {
				
			};
			
			[self.navigationController pushViewController:vc animated:YES];
			
			SAFE_RELEASE(vc);
		}
	} else {
		if (indexPath.row == 0) {
			
		}
		
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
