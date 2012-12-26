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
}

@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@property   (nonatomic, readwrite) NSInteger            selectedRow;
@end
