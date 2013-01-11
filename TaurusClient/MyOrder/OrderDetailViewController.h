//
//  OrderDetailViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    NSArray         *_datas;
    NSDictionary    *_detail;
    NSDictionary    *_orderStates;
    NSDictionary    *_threeCodes;
    NSDictionary    *_twoCodes;
    NSArray         *_flight;
    NSString        *_contactorPhone;
}

@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@property   (nonatomic, retain) IBOutlet UIView         *viewBottom;
@property   (nonatomic, retain) NSDictionary            *orderListItem;

@end
