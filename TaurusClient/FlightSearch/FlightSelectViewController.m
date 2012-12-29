//
//  FlightSelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FlightSelectViewController.h"
#import "JSONKit.h"
#import "NSDateAdditions.h"
#import "UIViewAdditions.h"
#import "UIView+Hierarchy.h"
#import "City.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "NSDictionaryAdditions.h"
#import "AirportSearchHelper.h"
#import "TwoCharCode.h"
#import "ThreeCharCode.h"

@interface FlightSelectViewController ()

@property (nonatomic, retain) NSMutableDictionary*		jsonContent;
@property (nonatomic, assign) BOOL						isTimeDesc;
@property (nonatomic, assign) BOOL						isPriceDesc;
@property (nonatomic, assign) BOOL						isSortByPrice;

- (void)onFlightGroupTap:(UIGestureRecognizer*)sender;
- (void)onSectionPayButtonTap:(UIButton*)sender;
- (NSDictionary*)queryOptimalCabinInfo:(NSDictionary*)flightInfo;
- (UIView*)generateCabinView:(NSDictionary*)cabin;
- (void)performFlightInfosSort;

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
	
	[super dealloc];
}

+ (void)performQueryWithNavVC:(UINavigationController*)navVC
				  andViewType:(FlightSelectViewType)aViewType
			 andDepartureCity:(ThreeCharCode*)aDepartureCity
			   andArrivalCity:(ThreeCharCode*)aArrivalCity
			 andDepartureDate:(NSDate*)aDepartureDate
				andReturnDate:(NSDate*)aReturnDate
{
	// TODO: test data
	NSString* path = [[NSBundle mainBundle] pathForResource:@"RunAvCommand" ofType:@"js"];
	NSString* content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
													 error:nil];
	
	NSMutableDictionary* jsonContent = [[content mutableObjectFromJSONString] objectForKey:@"Response"];
	
	float delayInSeconds = 0.3f;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		FlightSelectViewController* vc = [[FlightSelectViewController alloc] initWithViewType:aViewType
																			 andDepartureCity:aDepartureCity
																			   andArrivalCity:aArrivalCity
																			 andDepartureDate:aDepartureDate
																				andReturnDate:aReturnDate
																			   andJsonContent:jsonContent];
		
//		[navVC pushViewController:vc animated:YES];
		
		UIBGNavigationController* newNavVC = [[[UIBGNavigationController alloc] initWithRootViewController:vc] autorelease];
		[navVC presentModalViewController:newNavVC animated:YES];
		
		SAFE_RELEASE(vc);
	});
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (void)onNextDateButtonTap:(id)sender
{
	
}

- (void)onPrevDateButtonTap:(id)sender
{
	
}

- (void)onPriceSortButtonTap:(id)sender
{
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
}

- (void)onSelectDateButtonTap:(id)sender
{
	
}

- (void)onSortButtonTap:(id)sender
{
	
}

- (void)onTimeSortButtonTap:(id)sender
{
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
}

- (void)onSectionPayButtonTap:(UIButton*)sender
{
	// TODO: pay
}

#pragma mark - gesture

- (void)onFlightGroupTap:(UIGestureRecognizer *)sender
{
	UIView* senderVw = sender.view;
	int section = senderVw.tag - 9900;

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
									withRowAnimation:UITableViewRowAnimationTop];
	else
		[self.ticketResultsVw deleteRowsAtIndexPaths:rows
									withRowAnimation:UITableViewScrollPositionBottom];
}

#pragma mark - core methods

- (void)performFlightInfosSort
{
	
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
	
	result.tag = section + 9900;
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
																				 action:@selector(onFlightGroupTap:)];
	
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	[result addGestureRecognizer:tapGesture];
	SAFE_RELEASE(tapGesture);
	
	// item info
	// 根据价格选取最优的机票
	NSDictionary* flightInfo = [[self.jsonContent objectForKey:@"FlightsInfo"] objectAtIndex:section];
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
	
	payButton.tag = section + 9900;
	[payButton addTarget:self
				  action:@selector(onSectionPayButtonTap:)
		forControlEvents:UIControlEventTouchUpInside];

	//
	takeOffTimeLabel.text = [flightInfo getStringValueForKey:@"LeaveTime" defaultValue:@""];
	landingTimeLabel.text = [flightInfo getStringValueForKey:@"ArriveTime" defaultValue:@""];
	
	//
	NSString* twoCharcodeStr = [flightInfo getStringValueForKey:@"Ezm" defaultValue:@""];
	NSString* flightNumStr = [flightInfo getStringValueForKey:@"FlightNum" defaultValue:@""];
	TwoCharCode* twoCharcode = [AirportSearchHelper queryWithTwoCharCodeString:twoCharcodeStr];
	
	corpLabel.text = [NSString stringWithFormat:@"%@%@", twoCharcode.corpAbbrName, flightNumStr];
	
	//
	airportLabel.text = [NSString stringWithFormat:@"%@-%@", self.departureCity.airportAbbrName, self.arrivalCity.airportAbbrName];
	
	//
	airplaneTypeLabel.text = [flightInfo getStringValueForKey:@"Plane" defaultValue:nil];
	
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
	
	[result addSubview:cabin1Vw];
	
	int cabin2Index = row * 2 + 1;
	if (cabin2Index < cabinInfos.count) {
		NSDictionary* cabin2 = [cabinInfos objectAtIndex:cabin2Index];
		UIView* cabin2Vw = [self generateCabinView:cabin2];
		cabin2Vw.tag = 9901;
		
		cabin2Vw.left = cabin1Vw.width;
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
