//
//  OrderFilterViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray     *_datas;
    NSInteger   _selectedRow;
}

@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@end
