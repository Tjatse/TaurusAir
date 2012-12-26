//
//  OrderFlightDetailViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFlightDetailViewController : UIViewController{
    NSArray     *_datas;
}
@property   (nonatomic, retain) NSArray                 *detail;
@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@end
