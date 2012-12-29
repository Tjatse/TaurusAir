//
//  FlightSelectSortMainViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSelectViewController;

@interface FlightSelectSortMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*		dataVw;

- (id)initWithParentVC:(FlightSelectViewController*)parentVC;

@end
