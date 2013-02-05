//
//  OrderRefundViewController.h
//  TaurusClient
//
//  Created by Tjatse on 13-2-5.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"

@interface OrderRefundViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,StringInputTableViewCellDelegate>{
    NSMutableArray  *_passengers;
    NSMutableArray  *_flights;
}
@property (nonatomic, retain) NSMutableArray        *selectedPassengers;
@property (nonatomic, retain) NSMutableArray        *selectedFlights;
@property (nonatomic, retain) NSDictionary          *detail;
@property (nonatomic, retain) NSString              *reason;
@property (retain, nonatomic) IBOutlet UITableView  *tableView;

@end
