//
//  OrderDetailViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnPayButtonTapBlock)();

typedef enum {
    OrderStatusPayAndCancel = 0,
    OrderStatusRollback = 1,
    OrderStatusOther = 2
}OrderStatus;
@interface OrderDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    NSArray         *_datas;
    NSDictionary    *_detail;
    NSDictionary    *_orderStates;
    NSDictionary    *_threeCodes;
    NSDictionary    *_twoCodes;
    NSArray         *_flight;
    NSString        *_contactorPhone;
    BOOL            _hasReturn;
    CGSize          _size;
    OrderStatus     _status;
}

@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@property   (nonatomic, retain) IBOutlet UIView         *viewBottom;
@property   (nonatomic, retain) NSDictionary            *orderListItem;
@property   (nonatomic, retain) NSMutableArray          *passengers;

@property (nonatomic, copy) OnPayButtonTapBlock			payButtonTapBlock;

@end
