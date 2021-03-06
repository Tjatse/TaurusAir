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
#import "AppContext.h"
#import "ALToastView.h"
#import "AppEngine.h"
#import "AppConfig.h"
#import "NSDateAdditions.h"
#import "CitySearchHelper.h"
#import "DateInputTableViewCell.h"
#import "FlightSelectViewController.h"
#import "ThreeCharCode.h"
#import "FSConfig.h"
#import "AppDelegate.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+ButtonMaker.h"

@interface FlightSearchViewController () <DateInputTableViewCellDelegate>

@property (nonatomic, retain) IBOutlet UIButton*	departureBtn;
@property (nonatomic, retain) IBOutlet UIButton*	arrivalBtn;

@property (nonatomic, retain) ThreeCharCode*		departureCity;
@property (nonatomic, retain) ThreeCharCode*		arrivalCity;
@property (nonatomic, retain) NSDate*				departureDate;
@property (nonatomic, retain) NSDate*				returnDate;

@end

@implementation FlightSearchViewController

- (void)dealloc
{
	self.singleFlightParentView = nil;
	self.singleFlightTableView = nil;
	self.doubleFlightParentView = nil;
	self.doubleFlightTableView = nil;
	
	self.departureBtn = nil;
	self.arrivalBtn = nil;
	self.departureCity = nil;
	self.arrivalCity = nil;
	self.departureDate = nil;
	self.returnDate = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(defaultDepartureCityChanged:)
													 name:@"defaultDepartureCityChanged"
												   object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(defaultArrivalCityChanged:)
													 name:@"defaultCityArrivalChanged"
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"机票搜索";
	
	[self.view addSubview:self.singleFlightParentView];
	[self.view addSubview:self.doubleFlightParentView];
	
	self.singleFlightParentView.top = 50;
	self.doubleFlightParentView.top = 50;
	
	self.doubleFlightParentView.hidden = YES;
	
	// 获取所在城市
	NSString* city = [AppContext get].currentLocationCity;
	city = city == nil ? @"北京" : city;
	self.departureCity = [CitySearchHelper queryCityWithCityName:city].threeCharCodes[0];
	
	// 时间
	// 出发时间为当前时间第二天
	// 返回时间为当前时间第四天
	self.departureDate = [[NSDate date] dateAfterDay:1];
	self.returnDate = [[NSDate date] dateAfterDay:3];
	
	// 默认的地址
	NSString* defaultDepartureCityKey = [FSConfig readValueWithKey:@"defaultDepartureCity" defaultValue:@"PEK"];
	NSString* defaultArrivalCityKey = [FSConfig readValueWithKey:@"defaultArrivalCity" defaultValue:@"SHA"];
	
	self.departureCity = [[CharCodeHelper allThreeCharCodesDictionary] objectForKey:defaultDepartureCityKey];
	self.arrivalCity = [[CharCodeHelper allThreeCharCodesDictionary] objectForKey:defaultArrivalCityKey];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - notifications

- (void)defaultDepartureCityChanged:(NSNotification*)notification
{
	NSString* defaultDepartureCityKey = [FSConfig readValueWithKey:@"defaultDepartureCity" defaultValue:@"PEK"];
	self.departureCity = [[CharCodeHelper allThreeCharCodesDictionary] objectForKey:defaultDepartureCityKey];
	[self.singleFlightTableView reloadData];
	[self.doubleFlightTableView reloadData];
}

- (void)defaultArrivalCityChanged:(NSNotification*)notification
{
	NSString* defaultArrivalCityKey = [FSConfig readValueWithKey:@"defaultArrivalCity" defaultValue:@"SHA"];
	self.arrivalCity = [[CharCodeHelper allThreeCharCodesDictionary] objectForKey:defaultArrivalCityKey];

	[self.singleFlightTableView reloadData];
	[self.doubleFlightTableView reloadData];
}

#pragma mark - actions

- (void)onSwitchToDoubleFlightButtonTap:(id)sender
{
//	self.doubleFlightParentView.hidden = NO;
//	self.doubleFlightParentView.layer.opacity = 1.0f;
//	
//	CABasicAnimation* disappearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	disappearAni.removedOnCompletion = YES;
//	disappearAni.fromValue = [NSNumber numberWithFloat:0.0f];
//	disappearAni.toValue = [NSNumber numberWithFloat:1.0f];
//	
//	[self.doubleFlightParentView.layer addAnimation:disappearAni forKey:nil];
//
//	self.singleFlightParentView.layer.opacity = 0.0f;
//	CABasicAnimation* appearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	appearAni.removedOnCompletion = YES;
//	appearAni.fromValue = [NSNumber numberWithFloat:1.0f];
//	appearAni.toValue = [NSNumber numberWithFloat:0.0f];
//	[appearAni setAnimationDidStartBlock:nil
//				andAnimationDidStopBlock:^(CAAnimation *anim, BOOL finished) {
//					self.singleFlightParentView.hidden = YES;
//				}];
//	
//	[self.singleFlightParentView.layer addAnimation:appearAni forKey:nil];
	
	self.departureBtn.selected = NO;
	self.arrivalBtn.selected = YES;
	
	self.singleFlightParentView.left = 0;
	self.doubleFlightParentView.left = self.singleFlightParentView.width;
	self.singleFlightParentView.hidden = NO;
	self.doubleFlightParentView.hidden = NO;
	
	[UIView animateWithDuration:.3f
					 animations:^{
						 self.singleFlightParentView.left = -self.singleFlightParentView.width;
						 self.doubleFlightParentView.left = 0;
					 }
					 completion:^(BOOL finished) {
						 self.singleFlightParentView.hidden = YES;
					 }];
	
	[self.doubleFlightTableView reloadData];
}

- (void)onSwitchToSingleFlightButtonTap:(id)sender
{
//	self.singleFlightParentView.hidden = NO;
//	self.singleFlightParentView.layer.opacity = 1.0f;
//	
//	CABasicAnimation* disappearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	disappearAni.removedOnCompletion = YES;
//	disappearAni.fromValue = [NSNumber numberWithFloat:0.0f];
//	disappearAni.toValue = [NSNumber numberWithFloat:1.0f];
//	
//	[self.singleFlightParentView.layer addAnimation:disappearAni forKey:nil];
//	
//	self.doubleFlightParentView.layer.opacity = 0.0f;
//	CABasicAnimation* appearAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	appearAni.removedOnCompletion = YES;
//	appearAni.fromValue = [NSNumber numberWithFloat:1.0f];
//	appearAni.toValue = [NSNumber numberWithFloat:0.0f];
//	[appearAni setAnimationDidStartBlock:nil
//				andAnimationDidStopBlock:^(CAAnimation *anim, BOOL finished) {
//					self.doubleFlightParentView.hidden = YES;
//				}];
//	
//	[self.doubleFlightParentView.layer addAnimation:appearAni forKey:nil];
	
	self.departureBtn.selected = YES;
	self.arrivalBtn.selected = NO;

	self.singleFlightParentView.left = -self.singleFlightParentView.width;
	self.doubleFlightParentView.left = 0;
	self.singleFlightParentView.hidden = NO;
	self.doubleFlightParentView.hidden = NO;
	
	[UIView animateWithDuration:.3f
					 animations:^{
						 self.singleFlightParentView.left = 0;
						 self.doubleFlightParentView.left = self.singleFlightParentView.width;
					 }
					 completion:^(BOOL finished) {
						 self.doubleFlightParentView.hidden = YES;
					 }];
	
	[self.singleFlightTableView reloadData];
}

- (IBAction)onPerformSingleFlightSearchButtonTap:(id)sender
{
	if ([self.departureCity.charCode isEqualToString:self.arrivalCity.charCode]) {
		[ALToastView toastInView:self.view
						withText:@"出发城市不能与到达城市一样。"
				 andBottomOffset:44.0f
						 andType:ERROR];
		
		return;
	}
	
	// 检查正确性
	[FlightSelectViewController performQueryWithNavVC:self.navigationController
										  andViewType:kFlightSelectViewTypeSingle
									 andDepartureCity:self.departureCity
									   andArrivalCity:self.arrivalCity
									 andDepartureDate:self.departureDate
										andReturnDate:self.returnDate
										  andParentVC:nil];
}

- (IBAction)onPerformDoubleFlightSearchButtonTap:(id)sender
{
	if ([self.departureCity.charCode isEqualToString:self.arrivalCity.charCode]) {
		[ALToastView toastInView:self.view
						withText:@"出发城市不能与到达城市一样。"
				 andBottomOffset:44.0f
						 andType:ERROR];
		
		return;
	}
	
	// 检查正确性
	[FlightSelectViewController performQueryWithNavVC:self.navigationController
										  andViewType:kFlightSelectViewTypeDeparture
									 andDepartureCity:self.departureCity
									   andArrivalCity:self.arrivalCity
									 andDepartureDate:self.departureDate
										andReturnDate:self.returnDate
										  andParentVC:nil];
}

#pragma mark - tableview methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* result;
	
	if (tableView == self.singleFlightTableView) {
		if (indexPath.row == 0) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:0];
			
			UILabel* departureLabel = (UILabel*)[result viewWithTag:100];
			departureLabel.text = self.departureCity.cityName;
		} else if (indexPath.row == 1) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:1];

			UILabel* departureLabel = (UILabel*)[result viewWithTag:100];
			departureLabel.text = self.arrivalCity.cityName;
		} else {
			DateInputTableViewCell* cell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
																		 reuseIdentifier:nil] autorelease];
			
			cell.dateValue = self.departureDate;
			cell.delegate = self;
			cell.tag = 9900;
			[cell addSubview:[[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:2]];

			return cell;
		}
	} else {
		if (indexPath.row == 0) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:0];
			
			UILabel* departureLabel = (UILabel*)[result viewWithTag:100];
			departureLabel.text = self.departureCity.cityName;
		} else if (indexPath.row == 1) {
			result = [[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:1];
			
			UILabel* departureLabel = (UILabel*)[result viewWithTag:100];
			departureLabel.text = self.arrivalCity.cityName;
		} else if (indexPath.row == 2) {
			DateInputTableViewCell* cell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
																		  reuseIdentifier:nil] autorelease];
			
			cell.dateValue = self.departureDate;
			cell.delegate = self;
			cell.tag = 9900;
			[cell addSubview:[[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:2]];

			return cell;
		} else {
			DateInputTableViewCell* cell = [[[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
																		  reuseIdentifier:nil] autorelease];
			
			cell.dateValue = self.returnDate;
			cell.delegate = self;
			cell.tag = 9901;
			[cell addSubview:[[[NSBundle mainBundle] loadNibNamed:@"FlightSearchCells" owner:nil options:nil] objectAtIndex:3]];

			return cell;
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
	__block FlightSearchViewController* blockSelf = self;
	
	if (indexPath.row == 0) {
		CitySelectViewController* vc = [[CitySelectViewController alloc] init];
		vc.citySelectedBlock = ^(City* city) {
			blockSelf.departureCity = city.threeCharCodes[0];
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
		};
		
		vc.defaultCityName = self.departureCity.cityName;
		vc.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																				 andTapCallback:^(id control, UIEvent *event) {
																					 [self.navigationController dismissModalViewControllerAnimated:YES];
																				 }];
		
		UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
		[self.navigationController presentModalViewController:navVC animated:YES];
		
		SAFE_RELEASE(vc);
		SAFE_RELEASE(navVC);
	} else if (indexPath.row == 1) {
		CitySelectViewController* vc = [[CitySelectViewController alloc] init];
		vc.citySelectedBlock = ^(City* city) {
			blockSelf.arrivalCity = city.threeCharCodes[0];
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
		};
		
		vc.defaultCityName = self.arrivalCity.cityName;
		vc.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																				 andTapCallback:^(id control, UIEvent *event) {
																					 [self.navigationController dismissModalViewControllerAnimated:YES];
																				 }];
		
		UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
		[self.navigationController presentModalViewController:navVC animated:YES];
		
		SAFE_RELEASE(vc);
		SAFE_RELEASE(navVC);
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DateInputTableViewCellDelegate

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value
{
    [cell setDateValue:value];
	
	if (cell.tag == 9900) {
		self.departureDate = value;
		self.returnDate = [self.departureDate dateAfterDay:2];
	} else
		self.returnDate = value;
}

@end
