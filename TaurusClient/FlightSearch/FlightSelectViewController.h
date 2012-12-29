//
//  FlightSelectViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum tagFlightSelectViewType
{
	kFlightSelectViewTypeSingle
	, kFlightSelectViewTypeDeparture
	, kFlightSelectViewTypeReturn
} FlightSelectViewType;

@class City;

@interface FlightSelectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UILabel*			dateLabel;
@property (nonatomic, retain) IBOutlet UILabel*			cityFromToLabel;
@property (nonatomic, retain) IBOutlet UILabel*			ticketCountLabel;
@property (nonatomic, retain) IBOutlet UITableView*		ticketResultsVw;
@property (nonatomic, retain) IBOutlet UIImageView*		timeSortImgVw;
@property (nonatomic, retain) IBOutlet UIImageView*		priceSortImgVw;

@property (nonatomic, assign) FlightSelectViewType		viewType;
@property (nonatomic, retain) City*						departureCity;
@property (nonatomic, retain) City*						arrivalCity;
@property (nonatomic, retain) NSDate*					departureDate;
@property (nonatomic, retain) NSDate*					returnDate;

+ (void)performQueryWithNavVC:(UINavigationController*)navVC
				  andViewType:(FlightSelectViewType)aViewType
				andDepartureCity:(City*)aDepartureCity
				  andArrivalCity:(City*)aArrivalCity
				andDepartureDate:(NSDate*)aDepartureDate
				   andReturnDate:(NSDate*)aReturnDate;

- (id)initWithViewType:(FlightSelectViewType)aViewType
	  andDepartureCity:(City*)aDepartureCity
		andArrivalCity:(City*)aArrivalCity
	  andDepartureDate:(NSDate*)aDepartureDate
		 andReturnDate:(NSDate*)aReturnDate
		andJsonContent:(NSDictionary*)aJsonContent;

- (IBAction)onTimeSortButtonTap:(id)sender;
- (IBAction)onSortButtonTap:(id)sender;
- (IBAction)onPriceSortButtonTap:(id)sender;
- (IBAction)onPrevDateButtonTap:(id)sender;
- (IBAction)onSelectDateButtonTap:(id)sender;
- (IBAction)onNextDateButtonTap:(id)sender;

@end
