//
//  FlightSelectSortCorpViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSelectViewController;

@interface FlightSelectSortCorpViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithParentVC:(FlightSelectViewController*)parentVC;

@end
