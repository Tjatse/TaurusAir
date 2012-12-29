//
//  FlightSelectViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "FlightSelectViewController.h"
#import "JSONKit.h"
#import "NSDateAdditions.h"
#import "UIViewAdditions.h"
#import "UIView+Hierarchy.h"
#import "City.h"

@interface FlightSelectViewController ()

@property (nonatomic, retain) NSDictionary*		jsonContent;

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
			 andDepartureCity:(City*)aDepartureCity
			   andArrivalCity:(City*)aArrivalCity
			 andDepartureDate:(NSDate*)aDepartureDate
				andReturnDate:(NSDate*)aReturnDate
{
	// TODO: test data
	NSString* path = [[NSBundle mainBundle] pathForResource:@"RunAvCommand" ofType:@"js"];
	NSString* content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
													 error:nil];
	
	NSDictionary* jsonContent = [content objectFromJSONString];
	
	float delayInSeconds = 0.3f;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		FlightSelectViewController* vc = [[FlightSelectViewController alloc] initWithViewType:aViewType
																			 andDepartureCity:aDepartureCity
																			   andArrivalCity:aArrivalCity
																			 andDepartureDate:aDepartureDate
																				andReturnDate:aReturnDate
																			   andJsonContent:jsonContent];
		
		[navVC pushViewController:vc animated:YES];
		SAFE_RELEASE(vc);
	});
}

- (id)initWithViewType:(FlightSelectViewType)aViewType
	  andDepartureCity:(City*)aDepartureCity
		andArrivalCity:(City*)aArrivalCity
	  andDepartureDate:(NSDate*)aDepartureDate
		 andReturnDate:(NSDate*)aReturnDate
		andJsonContent:(NSDictionary*)aJsonContent
{
	if (self = [super init]) {
		self.viewType = aViewType;
		self.departureCity = aDepartureCity;
		self.arrivalCity = aArrivalCity;
		self.departureDate = aDepartureDate;
		self.returnDate = aReturnDate;
		self.jsonContent = aJsonContent;
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
	
}

- (void)onSelectDateButtonTap:(id)sender
{
	
}

- (void)onSortButtonTap:(id)sender
{
	
}

- (void)onTimeSortButtonTap:(id)sender
{
	
}

@end
