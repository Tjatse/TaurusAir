//
//  FlightSelectViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightSelectViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel*			dateLabel;
@property (nonatomic, retain) IBOutlet UILabel*			cityFromToLabel;
@property (nonatomic, retain) IBOutlet UILabel*			ticketCountLabel;
@property (nonatomic, retain) IBOutlet UITableView*		ticketResultsVw;
@property (nonatomic, retain) IBOutlet UIImageView*		timeSortImgVw;
@property (nonatomic, retain) IBOutlet UIImageView*		priceSortImgVw;

- (IBAction)onTimeSortButtonTap:(id)sender;
- (IBAction)onSortButtonTap:(id)sender;
- (IBAction)onPriceSortButtonTap:(id)sender;
- (IBAction)onPrevDateButtonTap:(id)sender;
- (IBAction)onSelectDateButtonTap:(id)sender;
- (IBAction)onNextDateButtonTap:(id)sender;

@end
