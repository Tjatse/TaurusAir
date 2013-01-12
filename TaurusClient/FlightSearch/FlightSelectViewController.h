//
//  FlightSelectViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;
@class ThreeCharCode;
@class TwoCharCode;

typedef enum tagFlightSelectViewType
{
	kFlightSelectViewTypeSingle
	, kFlightSelectViewTypeDeparture
	, kFlightSelectViewTypeReturn
} FlightSelectViewType;

typedef enum tagFlightSelectTimeFilterType
{
	kFlightSelectTimeFilterTypeNone
	, kFlightSelectTimeFilterTypeMatin
	, kFlightSelectTimeFilterTypeApresMidi
	, kFlightSelectTimeFilterTypeLaNuit
} FlightSelectTimeFilterType;

typedef enum tagFlightSelectAirplaneFilterType
{
	kFlightSelectAirplaneFilterTypeNone
	, kFlightSelectAirplaneFilterTypeMedium
	, kFlightSelectAirplaneFilterTypeLarge
} FlightSelectPlaneFilterType;

// translate filter types
extern NSArray* timeFilters();
extern NSArray* planeFilter();
extern NSString* flightSelectTimeFilterTypeName(FlightSelectTimeFilterType filterType);
extern NSString* flightSelectPlaneFilterTypeName(FlightSelectPlaneFilterType filterType);
extern NSString* flightSelectCorpFilterTypeName(TwoCharCode* filterType);

@interface FlightSelectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) FlightSelectViewType			viewType;
@property (nonatomic, retain) ThreeCharCode*				departureCity;
@property (nonatomic, retain) ThreeCharCode*				arrivalCity;
@property (nonatomic, retain) NSDate*						departureDate;
@property (nonatomic, retain) NSDate*						returnDate;

// filters
@property (nonatomic, assign) FlightSelectTimeFilterType	timeFilter;
@property (nonatomic, assign) FlightSelectPlaneFilterType	planeFilter;
@property (nonatomic, assign) TwoCharCode*					corpFilter;

@property (nonatomic, assign) FlightSelectViewController*	parentVC;

+ (void)performQueryWithNavVC:(UINavigationController*)navVC
				  andViewType:(FlightSelectViewType)aViewType
				andDepartureCity:(ThreeCharCode*)aDepartureCity
				  andArrivalCity:(ThreeCharCode*)aArrivalCity
				andDepartureDate:(NSDate*)aDepartureDate
				   andReturnDate:(NSDate*)aReturnDate;

- (id)initWithViewType:(FlightSelectViewType)aViewType
	  andDepartureCity:(ThreeCharCode*)aDepartureCity
		andArrivalCity:(ThreeCharCode*)aArrivalCity
	  andDepartureDate:(NSDate*)aDepartureDate
		 andReturnDate:(NSDate*)aReturnDate
		andJsonContent:(NSMutableDictionary*)aJsonContent;

- (IBAction)onTimeSortButtonTap:(id)sender;
- (IBAction)onSortButtonTap:(id)sender;
- (IBAction)onPriceSortButtonTap:(id)sender;
- (IBAction)onPrevDateButtonTap:(id)sender;
- (IBAction)onSelectDateButtonTap:(id)sender;
- (IBAction)onNextDateButtonTap:(id)sender;

@end
