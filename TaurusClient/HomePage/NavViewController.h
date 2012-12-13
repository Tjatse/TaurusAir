//
//  NavViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSearchViewController;
@class MyOrderViewController;
@class ContacterViewController;
@class MyInfoViewController;

@interface NavViewController : UITabBarController

@property (nonatomic, retain) FlightSearchViewController*	flightSearchVC;
@property (nonatomic, retain) MyOrderViewController*		myOrderVC;
@property (nonatomic, retain) ContacterViewController*		contacterVC;
@property (nonatomic, retain) MyInfoViewController*			myInfoVC;

- (void)switchToFlightSearchTab;
- (void)switchToMyOrderTab;
- (void)switchToContacterTab;
- (void)switchToMyInfoTab;

@end
