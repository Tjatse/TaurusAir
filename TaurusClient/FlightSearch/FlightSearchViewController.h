//
//  FlightSearchViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UIView*			singleFlightParentView;
@property (nonatomic, retain) IBOutlet UIView*			doubleFlightParentView;
@property (nonatomic, retain) IBOutlet UITableView*		singleFlightTableView;
@property (nonatomic, retain) IBOutlet UITableView*		doubleFlightTableView;

- (IBAction)onSwitchToSingleFlightButtonTap:(id)sender;
- (IBAction)onSwitchToDoubleFlightButtonTap:(id)sender;

@end
