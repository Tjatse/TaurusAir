//
//  FlightSelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"
#import "NSDateAdditions.h"
#import "UIViewAdditions.h"
#import "UIView+Hierarchy.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "NSDictionaryAdditions.h"
#import "FSConfig.h"
#import "MBProgressHUD.h"
#import "ALToastView.h"
#import "NSObject+RefTag.h"
#import "ALToastView.h"

#import "AppContext.h"
#import "AppDelegate.h"
#import "AppConfig.h"
#import "City.h"
#import "AirportSearchHelper.h"
#import "TwoCharCode.h"
#import "ThreeCharCode.h"
#import "FlightSelectSortMainViewController.h"
#import "FlightSelectViewController.h"
#import "FlightSearchHelper.h"
#import "LoginViewController.h"
#import "PrepareOrderViewController.h"
#import "AirplaneTypeHelper.h"
#import "OrderHelper.h"

NSArray* timeFilters()
{
	static NSArray* arr = nil;
	
	if (arr == nil) {
		arr = [@[@"不限", @"上午(00:00~12:00)", @"下午(12:00~18:00)", @"晚上(18:00~24:00)"] retain];
	}
		
	return arr;
}

NSArray* planeFilter()
{
	static NSArray* arr = nil;
	
	if (arr == nil) {
		arr = [@[@"不限", @"中型机", @"大型机"] retain];
	}
	
	return arr;
}

NSString* flightSelectTimeFilterTypeName(FlightSelectTimeFilterType filterType)
{
	return timeFilters()[(int)filterType];
}

NSString* flightSelectPlaneFilterTypeName(FlightSelectPlaneFilterType filterType)
{
	return planeFilter()[(int)filterType];
}

NSString* flightSelectCorpFilterTypeName(TwoCharCode* filterType)
{
	if (filterType == nil)
		return @"不限";
	else
		return filterType.corpFullName;
}

@interface FlightSelectViewController ()

@property (nonatomic, retain) NSMutableDictionary*			jsonContent;
@property (nonatomic, assign) BOOL							isTimeDesc;
@property (nonatomic, assign) BOOL							isPriceDesc;
@property (nonatomic, assign) BOOL							isSortByPrice;
@property (nonatomic, retain) IBOutlet UIButton*			sortByPriceBtn;
@property (nonatomic, retain) IBOutlet UIButton*			sortByTimeBtn;
@property (nonatomic, retain) IBOutlet UIButton*			prevDate;
@property (nonatomic, retain) IBOutlet UIButton*			selectDate;
@property (nonatomic, retain) IBOutlet UIButton*			nextDate;

@property (nonatomic, retain) IBOutlet UILabel*				dateLabel;
@property (nonatomic, retain) IBOutlet UILabel*				cityFromToLabel;
@property (nonatomic, retain) IBOutlet UILabel*				ticketCountLabel;
@property (nonatomic, retain) IBOutlet UITableView*			ticketResultsVw;
@property (nonatomic, retain) IBOutlet UIImageView*			timeSortImgVw;
@property (nonatomic, retain) IBOutlet UIImageView*			priceSortImgVw;

@property (nonatomic, retain) IBOutlet UIView*				selectDateParentVw;
@property (nonatomic, retain) IBOutlet UIView*				selectDateContainerVw;
@property (nonatomic, retain) IBOutlet UIDatePicker*		selectDatePicker;

- (IBAction)onSelectDateCompleteButtonTap:(id)sender;
- (IBAction)onSelectDateCancelButtonTap:(id)sender;

@end

@implementation FlightSelectViewController

#pragma mark - life cycle

- (void)dealloc
{
	self.dateLabel = nil;
	self.cityFromToLabel = nil;
	self.ticketCountLabel = nil;
	self.ticketResultsVw = nil;
	self.timeSortImgVw = nil;
	self.priceSortImgVw = nil;
	
	self.departureCity = nil;
	self.arrivalCity = nil;
	self.departureDate = nil;
	self.returnDate = nil;
	
	self.jsonContent = nil;
	
	self.corpFilter = nil;
	
	self.sortByPriceBtn = nil;
	self.sortByTimeBtn = nil;
	
	self.prevDate = nil;
	self.selectDate = nil;
	self.nextDate = nil;
	
	self.selectDateParentVw = nil;
	self.selectDateContainerVw = nil;
	self.selectDatePicker = nil;
	
	self.parentVC = nil;
	self.selectedPayInfos = nil;
	
	[super dealloc];
}

+ (void)performQueryWithNavVC:(UINavigationController*)navVC
				  andViewType:(FlightSelectViewType)aViewType
			 andDepartureCity:(ThreeCharCode*)aDepartureCity
			   andArrivalCity:(ThreeCharCode*)aArrivalCity
			 andDepartureDate:(NSDate*)aDepartureDate
				andReturnDate:(NSDate*)aReturnDate
				  andParentVC:(FlightSelectViewController*)parentVC
{
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:navVC.topViewController.view animated:YES];
	hud.labelText = @"正在查询...";
	
	[FlightSearchHelper
	 performFlightSearchWithDepartureCity:aDepartureCity
	 andArrivalCity:aArrivalCity
	 andDepartureDate:aDepartureDate
	 andSuccess:^(NSMutableDictionary *respObj) {
		 [MBProgressHUD hideHUDForView:navVC.topViewController.view
							  animated:YES];
		 
		 FlightSelectViewController* vc = [[FlightSelectViewController alloc] initWithViewType:aViewType
																			  andDepartureCity:aDepartureCity
																				andArrivalCity:aArrivalCity
																			  andDepartureDate:aDepartureDate
																				 andReturnDate:aReturnDate
																				andJsonContent:respObj];
		 
		 vc.parentVC = parentVC;
		 
		 UIBGNavigationController* newNavVC = [[[UIBGNavigationController alloc] initWithRootViewController:vc] autorelease];
		 [navVC presentModalViewController:newNavVC animated:YES];
		 
		 SAFE_RELEASE(vc);
	 }
	 andFailure:^(NSString *errorMsg) {
		 [MBProgressHUD hideHUDForView:navVC.topViewController.view
							  animated:YES];
		 
		 [ALToastView toastInView:navVC.topViewController.view
						 withText:errorMsg
				  andBottomOffset:44.0f
						  andType:ERROR];
	 }];
}

- (id)initWithViewType:(FlightSelectViewType)aViewType
	  andDepartureCity:(ThreeCharCode*)aDepartureCity
		andArrivalCity:(ThreeCharCode*)aArrivalCity
	  andDepartureDate:(NSDate*)aDepartureDate
		 andReturnDate:(NSDate*)aReturnDate
		andJsonContent:(NSMutableDictionary*)aJsonContent
{
	if (self = [super init]) {
		self.viewType = aViewType;
		self.departureCity = aDepartureCity;
		self.arrivalCity = aArrivalCity;
		self.departureDate = aDepartureDate;
		self.returnDate = aReturnDate;
		self.jsonContent = aJsonContent;
		self.isSortByPrice = YES;
		
		// backbutton
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																				   andTapCallback:^(id control, UIEvent *event) {
																					   [self.navigationController dismissModalViewControllerAnimated:YES];
																				   }];
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
	[self displaySearchResultToView];
	
	[self.view addSubview:self.selectDateParentVw];
	self.selectDateParentVw.hidden = YES;
	
	// 默认排序顺序
	if (self.isSortByPrice) {
		self.sortByTimeBtn.selected = NO;
		self.sortByPriceBtn.selected = YES;
		self.timeSortImgVw.hidden = YES;
		self.priceSortImgVw.hidden = NO;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.viewType != kFlightSelectViewTypeSingle) {
		self.prevDate.hidden = YES;
		self.nextDate.hidden = YES;
		self.selectDate.hidden = YES;
		self.ticketResultsVw.height = self.view.height - self.ticketResultsVw.top;
	} else {
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)onSelectDateCompleteButtonTap:(id)sender
{
	self.departureDate = self.selectDatePicker.date;
	
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"正在查询...";
	
	[FlightSearchHelper
	 performFlightSearchWithDepartureCity:self.departureCity
	 andArrivalCity:self.arrivalCity
	 andDepartureDate:self.departureDate
	 andSuccess:^(NSMutableDictionary *respObj) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];
		 
		 [self displaySearchResultToView];
	 }
	 andFailure:^(NSString *errorMsg) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];

		 [ALToastView toastInView:self.view
						 withText:errorMsg
				  andBottomOffset:44.0f
						  andType:ERROR];
	 }];

	self.selectDateParentVw.hidden = YES;
}

- (void)onSelectDateCancelButtonTap:(id)sender
{
	self.selectDateParentVw.hidden = YES;
}

- (void)onNextDateButtonTap:(id)sender
{
	self.departureDate = [self.departureDate dateAfterDay:1];
	
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"正在查询...";
	
	[FlightSearchHelper
	 performFlightSearchWithDepartureCity:self.departureCity
	 andArrivalCity:self.arrivalCity
	 andDepartureDate:self.departureDate
	 andSuccess:^(NSMutableDictionary *respObj) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];
		 
		 [self displaySearchResultToView];
	 }
	 andFailure:^(NSString *errorMsg) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];

		 [ALToastView toastInView:self.view
						 withText:errorMsg
				  andBottomOffset:44.0f
						  andType:ERROR];
	 }];
}

- (void)onPrevDateButtonTap:(id)sender
{
	self.departureDate = [self.departureDate dateAfterDay:-1];
	
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"正在查询...";
	
	[FlightSearchHelper
	 performFlightSearchWithDepartureCity:self.departureCity
	 andArrivalCity:self.arrivalCity
	 andDepartureDate:self.departureDate
	 andSuccess:^(NSMutableDictionary *respObj) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];
		 
		 [self displaySearchResultToView];
	 }
	 andFailure:^(NSString *errorMsg) {
		 [MBProgressHUD hideHUDForView:self.view
							  animated:YES];

		 [ALToastView toastInView:self.view
						 withText:errorMsg
				  andBottomOffset:44.0f
						  andType:ERROR];
	 }];
}

- (void)onPriceSortButtonTap:(id)sender
{
	self.sortByPriceBtn.selected = YES;
	self.sortByTimeBtn.selected = NO;
	
	if (self.isSortByPrice) {
		self.isPriceDesc = !self.isPriceDesc;
		
		CATransform3D trans1 = CATransform3DMakeRotation(0, 0, 0, 1);
		CATransform3D trans2 = CATransform3DMakeRotation(180 * M_PI / 180.0f, 0, 0, 1);
		
		CABasicAnimation* rotateAni = [CABasicAnimation animationWithKeyPath:@"transform"];
		rotateAni.removedOnCompletion = YES;
		rotateAni.fromValue = [NSValue valueWithCATransform3D:self.isPriceDesc ? trans1 : trans2];
		rotateAni.toValue = [NSValue valueWithCATransform3D:self.isPriceDesc ? trans2 : trans1];
		
		self.priceSortImgVw.layer.transform = self.isPriceDesc ? trans2 : trans1;
		[self.priceSortImgVw.layer addAnimation:rotateAni forKey:nil];
	} else {
		self.isSortByPrice = YES;
		self.isPriceDesc = NO;
		self.isTimeDesc = NO;
		
		self.timeSortImgVw.hidden = YES;
		self.priceSortImgVw.hidden = NO;
	}
	
	[self performFlightInfosSort];
	[FSConfig setBoolValue:YES withKey:@"sortByPrice"];
}

- (void)onSelectDateButtonTap:(id)sender
{
	self.selectDateParentVw.frame = self.view.bounds;
	self.selectDateParentVw.hidden = NO;
}

- (void)onSortButtonTap:(id)sender
{
	FlightSelectSortMainViewController* vc = [[FlightSelectSortMainViewController alloc] initWithParentVC:self];
	[self.navigationController pushViewController:vc animated:YES];
	SAFE_RELEASE(vc);
}

- (void)onTimeSortButtonTap:(id)sender
{
	self.sortByPriceBtn.selected = NO;
	self.sortByTimeBtn.selected = YES;
	
	if (!self.isSortByPrice) {
		self.isTimeDesc = !self.isTimeDesc;
		
		CATransform3D trans1 = CATransform3DMakeRotation(0, 0, 0, 1);
		CATransform3D trans2 = CATransform3DMakeRotation(180 * M_PI / 180.0f, 0, 0, 1);
		
		CABasicAnimation* rotateAni = [CABasicAnimation animationWithKeyPath:@"transform"];
		rotateAni.removedOnCompletion = YES;
		rotateAni.fromValue = [NSValue valueWithCATransform3D:self.isTimeDesc ? trans1 : trans2];
		rotateAni.toValue = [NSValue valueWithCATransform3D:self.isTimeDesc ? trans2 : trans1];
		
		self.timeSortImgVw.layer.transform = self.isTimeDesc ? trans2 : trans1;
		[self.timeSortImgVw.layer addAnimation:rotateAni forKey:nil];
	} else {
		self.isSortByPrice = NO;
		self.isPriceDesc = NO;
		self.isTimeDesc = NO;
		
		self.timeSortImgVw.hidden = NO;
		self.priceSortImgVw.hidden = YES;
	}
	
	[self performFlightInfosSort];
	[FSConfig setBoolValue:NO withKey:@"sortByPrice"];
}

- (void)onSectionPayButtonTap:(UIButton*)sender
{
	self.selectedPayInfos = sender.strongRefTag;
	
	// pay
	if (![[AppConfig get] isLogon]){
        [self showLoginViewController];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"登录"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self showLoginViewController];
                                             }];

        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(loginCancel)
													 name:@"LOGIN_CANCEL"
												   object:nil];
		
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(loginSuccess)
													 name:@"LOGIN_SUC"
												   object:nil];
	} else {
		[self performPay];
	}
}

#pragma mark - gesture

- (void)onFlightGroupTap:(UIButton*)sender
{
	UIView* senderVw = sender;
//	int section = senderVw.tag - 9900;
	
	int section = [senderVw.strongRefTag intValue];

	NSMutableDictionary* flightInfo = [[self.jsonContent objectForKey:@"FlightsInfo"] objectAtIndex:section];
	
	BOOL isSelected = [flightInfo getBoolValueForKey:@"isExpand" defaultValue:NO];
	isSelected = !isSelected;
	[flightInfo setValue:@(isSelected) forKey:@"isExpand"];

	NSArray* cabinInfos = [flightInfo objectForKey:@"CabinInfo"];
	int rowsCount = (int)(ceil(cabinInfos.count / 2.0f));
	
	// 要添加/删除的行
	NSMutableArray* rows = [NSMutableArray array];
	for (int n = 0; n < rowsCount; ++n)
		[rows addObject:[NSIndexPath indexPathForRow:n inSection:section]];
	
	if (isSelected)
		[self.ticketResultsVw insertRowsAtIndexPaths:rows
									withRowAnimation:UITableViewRowAnimationFade];
	else
		[self.ticketResultsVw deleteRowsAtIndexPaths:rows
									withRowAnimation:UITableViewRowAnimationFade];
	
//	[self.ticketResultsVw reloadSections:[NSIndexSet indexSetWithIndex:section]
//						withRowAnimation:UITableViewRowAnimationFade];
	
//	[self.ticketResultsVw reloadData];
}

#pragma mark - core methods

- (void)performPay
{
	// 如果当前是往返模式，且父容器为空
	if (self.viewType == kFlightSelectViewTypeDeparture) {
		// 请求返回的机票
		[[self class] performQueryWithNavVC:self.navigationController
								andViewType:kFlightSelectViewTypeReturn
						   andDepartureCity:self.arrivalCity
							 andArrivalCity:self.departureCity
						   andDepartureDate:self.returnDate
							  andReturnDate:nil
								andParentVC:self];
	} else if (self.viewType == kFlightSelectViewTypeReturn) {
		// 回程，预订
		PrepareOrderViewController* prepareVC = [[PrepareOrderViewController alloc] initWithFlightSelectVC:self];
		UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:prepareVC];
		[self presentModalViewController:navVC animated:YES];
		SAFE_RELEASE(prepareVC);
		SAFE_RELEASE(navVC);
		
		return;
	} else if (self.viewType == kFlightSelectViewTypeSingle) {
		PrepareOrderViewController* prepareVC = [[PrepareOrderViewController alloc] initWithFlightSelectVC:self];
		UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:prepareVC];
		[self presentModalViewController:navVC animated:YES];
		SAFE_RELEASE(prepareVC);
		SAFE_RELEASE(navVC);
		
		return;
	}
}

- (void)loginCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_CANCEL" object:nil];
	[ALToastView toastPinInView:self.view withText:@"登录后才能“预订机票”。"
				andBottomOffset:44.0f
						andType:ERROR];
}

- (void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_SUC" object:nil];
    [self performPay];
}

- (void)showLoginViewController
{
	LoginViewController *vc = [[LoginViewController alloc] init];
	UIBGNavigationController *nav = [[UIBGNavigationController alloc] initWithRootViewController: vc];
	[self.navigationController presentModalViewController:nav animated:YES];
	[vc release];
	[nav release];
}
	
- (void)displaySearchResultToView
{
	// init controls
	self.dateLabel.text = [self.departureDate stringWithFormat:[NSDate dateFormatString]];
	self.cityFromToLabel.text = [NSString stringWithFormat:@"%@-%@"
								 , self.departureCity.cityName
								 , self.arrivalCity.cityName];
	
	int resultCount = [[self.jsonContent objectForKey:@"FlightsInfo"] count];
	self.ticketCountLabel.text = [NSString stringWithFormat:@"共%d条", resultCount];
	
	// title
	switch (self.viewType) {
		case kFlightSelectViewTypeSingle:
			self.title = @"单程航班";
			break;
			
		case kFlightSelectViewTypeDeparture:
			self.title = @"往返去程";
			break;
			
		default:
			self.title = @"往返回程";
			break;
	}
	
	// sortByPrice
	self.isSortByPrice = [FSConfig readBoolWithKey:@"sortByPrice" defaultValue:NO];
	
	[self.ticketResultsVw reloadData];
}

- (void)performFlightInfosSort
{
	NSMutableArray* flightInfos = [self.jsonContent objectForKey:@"FlightsInfo"];
	[flightInfos sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSMutableDictionary* info1 = (NSMutableDictionary*)obj1;
		NSMutableDictionary* info2 = (NSMutableDictionary*)obj2;
		
		if (self.isSortByPrice) {
			NSDictionary* cabin1 = [self queryOptimalCabinInfo:info1];
			NSDictionary* cabin2 = [self queryOptimalCabinInfo:info2];
			
			int payPrice1 = [cabin1 getIntValueForKey:@"PayPrice" defaultValue:0];
			int payPrice2 = [cabin2 getIntValueForKey:@"PayPrice" defaultValue:0];
			
			if (self.isPriceDesc)
				return payPrice2 - payPrice1;
			else
				return payPrice1 - payPrice2;
		} else {
			// 时间
			NSDate* leaveTime1 = [NSDate dateFromString:[info1 getStringValueForKey:@"LeaveTime" defaultValue:nil]];
			NSDate* leaveTime2 = [NSDate dateFromString:[info2 getStringValueForKey:@"LeaveTime" defaultValue:nil]];
			
			if (self.isTimeDesc)
				return [leaveTime2 compare:leaveTime1];
			else
				return [leaveTime1 compare:leaveTime2];
		}
	}];

	[self.ticketResultsVw beginUpdates];
	
	NSMutableIndexSet* sections = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, flightInfos.count)];
	[self.ticketResultsVw reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
	[self.ticketResultsVw endUpdates];
	
//	[self.ticketResultsVw reloadData];
}

- (NSDictionary*)queryOptimalCabinInfo:(NSDictionary*)flightInfo
{
	NSDictionary* optimalCabin = nil;
	NSArray* cabinInfos = [flightInfo objectForKey:@"CabinInfo"];
	for (NSDictionary* cabinInfo in cabinInfos) {
		if (optimalCabin == nil)
			optimalCabin = cabinInfo;
		else {
			if ([cabinInfo getIntValueForKey:@"PayPrice" defaultValue:0]
				< [optimalCabin getIntValueForKey:@"PayPrice" defaultValue:0]) {
				
				optimalCabin = cabinInfo;
			}
		}
	}

	return optimalCabin;
}

- (UIView*)generateCabinView:(NSDictionary*)cabin
{
	UIView* result = [[NSBundle mainBundle] loadNibNamed:@"FlightSelectCells" owner:nil options:nil][2];
	
	UILabel* priceLabel = (UILabel*)[result viewWithTag:100];
	UILabel* discountLabel = (UILabel*)[result viewWithTag:101];
	UILabel* ticketCountLabel = (UILabel*)[result viewWithTag:102];
	
	priceLabel.text = [NSString stringWithFormat:@"￥%d", [cabin getIntValueForKey:@"PayPrice" defaultValue:0]];
	discountLabel.text = [NSString stringWithFormat:@"%.1f折"
						  , [cabin getFloatValueForKey:@"Discount" defaultValue:0] / 10.0f];
	ticketCountLabel.text = [NSString stringWithFormat:@"%@张"
						  , [cabin getStringValueForKey:@"LeftCount" defaultValue:@""]];
	
	return result;
}

#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	int result = [[self.jsonContent objectForKey:@"FlightsInfo"] count];
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* result = [[NSBundle mainBundle] loadNibNamed:@"FlightSelectCells" owner:nil options:nil][0];
	
//	result.tag = section + 9900;
	result.strongRefTag = @(section);
	
//	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//																				 action:@selector(onFlightGroupTap:)];
//	
//	tapGesture.numberOfTapsRequired = 1;
//	tapGesture.numberOfTouchesRequired = 1;
//	[result addGestureRecognizer:tapGesture];
//	SAFE_RELEASE(tapGesture);
	
	// item info
	// 根据价格选取最优的机票
	NSArray* flightInfos = [self.jsonContent objectForKey:@"FlightsInfo"];
	NSDictionary* flightInfo = [flightInfos objectAtIndex:section];
//	NSArray* cabinInfos = [flightInfo objectForKey:@"CabinInfo"];
	NSDictionary* optimalCabin = [self queryOptimalCabinInfo:flightInfo];
	
	// 填充数据
	UILabel* takeOffTimeLabel = (UILabel*)[result viewWithTag:100];
	UILabel* landingTimeLabel = (UILabel*)[result viewWithTag:101];
	UILabel* corpLabel = (UILabel*)[result viewWithTag:102];
	UILabel* airportLabel = (UILabel*)[result viewWithTag:103];
	UILabel* airplaneTypeLabel = (UILabel*)[result viewWithTag:104];
	UILabel* priceLabel = (UILabel*)[result viewWithTag:105];
	UILabel* discountLabel = (UILabel*)[result viewWithTag:106];
	UIButton* payButton = (UIButton*)[result viewWithTag:107];
	
	UIView* bottomSepLineVw = (UIView*)[result viewWithTag:300];
	bottomSepLineVw.hidden = section != flightInfos.count - 1;
	
	UIButton* sectionTapButton = (UIButton*)[result viewWithTag:120];
	sectionTapButton.strongRefTag = @(section);
	[sectionTapButton addTarget:self
					  action:@selector(onFlightGroupTap:)
			forControlEvents:UIControlEventTouchUpInside];
	
//	payButton.tag = section + 9900;
	payButton.strongRefTag = @[flightInfo, optimalCabin];
	[payButton addTarget:self
				  action:@selector(onSectionPayButtonTap:)
		forControlEvents:UIControlEventTouchUpInside];

	//
	NSDate* leaveTime = [NSDate dateFromString:[flightInfo getStringValueForKey:@"LeaveTime" defaultValue:@""]];
	NSDate* arriveTime = [NSDate dateFromString:[flightInfo getStringValueForKey:@"ArriveTime" defaultValue:@""]];
	
	takeOffTimeLabel.text = [leaveTime stringWithFormat:@"hh:mm"];
	landingTimeLabel.text = [arriveTime stringWithFormat:@"hh:mm"];
	
	//
	NSString* twoCharcodeStr = [flightInfo getStringValueForKey:@"Ezm" defaultValue:@""];
	NSString* flightNumStr = [flightInfo getStringValueForKey:@"FlightNum" defaultValue:@""];
	TwoCharCode* twoCharcode = [AirportSearchHelper queryWithTwoCharCodeString:twoCharcodeStr];
	
	corpLabel.text = [NSString stringWithFormat:@"%@%@", twoCharcode.corpAbbrName, flightNumStr];
	
	//
	airportLabel.text = [NSString stringWithFormat:@"%@-%@", self.departureCity.airportAbbrName, self.arrivalCity.airportAbbrName];
	
	//
	NSString* airplaneTypeStr = [flightInfo getStringValueForKey:@"Plane" defaultValue:nil];
	NSDictionary* airplaneTypes = [[AirplaneTypeHelper sharedHelper] allAirplaneType];
	AirplaneType* airplaneType = [airplaneTypes objectForKey:airplaneTypeStr];
	
	airplaneTypeLabel.text = [NSString stringWithFormat:@"%@%@"
							  , airplaneType == nil ? @"中型机" : airplaneType.friendlyPlaneType
							  , [flightInfo getStringValueForKey:@"Plane" defaultValue:nil]];
	
	//
	priceLabel.text = [NSString stringWithFormat:@"￥%d", [optimalCabin getIntValueForKey:@"PayPrice" defaultValue:0]];
	
	//
	discountLabel.text = [NSString stringWithFormat:@"%.1f折 %@张"
						  , [optimalCabin getFloatValueForKey:@"Discount" defaultValue:0] / 10.0f
						  , [optimalCabin getStringValueForKey:@"LeftCount" defaultValue:@""]];
	
	return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSDictionary* flightInfo = [[self.jsonContent objectForKey:@"FlightsInfo"] objectAtIndex:section];
	BOOL isSelected = [flightInfo getBoolValueForKey:@"isExpand" defaultValue:NO];
	
	if (!isSelected)
		return 0;
	else {
		NSArray* cabinInfos = [flightInfo objectForKey:@"CabinInfo"];
		int rowsCount = (int)(ceil(cabinInfos.count / 2.0f));
		
		return rowsCount;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellId = @"cellId";
	UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (result != nil) {
		UIView* infoVw1 = (UIView*)[result viewWithTag:9900];
		[infoVw1 removeFromSuperview];

		UIView* infoVw2 = (UIView*)[result viewWithTag:9901];
		[infoVw2 removeFromSuperview];
	} else {
		result = [[NSBundle mainBundle] loadNibNamed:@"FlightSelectCells" owner:nil options:nil][1];
	}
	
	int section = indexPath.section;
	int row = indexPath.row;
	
	NSDictionary* flightInfo = [[self.jsonContent objectForKey:@"FlightsInfo"] objectAtIndex:section];
	NSArray* cabinInfos = [flightInfo objectForKey:@"CabinInfo"];

	// 判断是否第一行/最后一行，显示阴影
	UIImageView* topShadowVw = (UIImageView*)[result viewWithTag:100];
	UIImageView* bottomShadowVw = (UIImageView*)[result viewWithTag:101];
	int rowsCount = (int)(ceil(cabinInfos.count / 2.0f));

	topShadowVw.hidden = row != 0;
	bottomShadowVw.hidden = row != (rowsCount - 1);
	
	// 绑定cabin
	int cabin1Index = row * 2;
	NSDictionary* cabin1 = [cabinInfos objectAtIndex:cabin1Index];
	UIView* cabin1Vw = [self generateCabinView:cabin1];
	cabin1Vw.tag = 9900;
	cabin1Vw.strongRefTag = @9900;
	
	UIButton* cabin1PayBtn = (UIButton*)[cabin1Vw viewWithTag:200];
	cabin1PayBtn.strongRefTag = @[flightInfo, cabin1];
	[cabin1PayBtn addTarget:self
					 action:@selector(onSectionPayButtonTap:)
		   forControlEvents:UIControlEventTouchUpInside];
	
	[result addSubview:cabin1Vw];
	
	int cabin2Index = row * 2 + 1;
	if (cabin2Index < cabinInfos.count) {
		NSDictionary* cabin2 = [cabinInfos objectAtIndex:cabin2Index];
		UIView* cabin2Vw = [self generateCabinView:cabin2];
		cabin2Vw.tag = 9901;
		cabin2Vw.strongRefTag = @9901;
		
		cabin2Vw.left = cabin1Vw.width;

		UIButton* cabin2PayBtn = (UIButton*)[cabin2Vw viewWithTag:200];
		cabin2PayBtn.strongRefTag = @[flightInfo, cabin2];
		[cabin2PayBtn addTarget:self
						 action:@selector(onSectionPayButtonTap:)
			   forControlEvents:UIControlEventTouchUpInside];

		[result addSubview:cabin2Vw];
	}
	
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	BOOL isSelected = [self.cellExpandedArray[indexPath.row] boolValue];
//	[self.cellExpandedArray replaceObjectAtIndex:indexPath.row
//									  withObject:@(!isSelected)];
//	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//	[tableView reloadRowsAtIndexPaths:@[indexPath]
//					 withRowAnimation:UITableViewRowAnimationBottom];
}

@end
