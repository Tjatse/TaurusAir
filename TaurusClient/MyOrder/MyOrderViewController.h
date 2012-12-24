//
//  MyOrderViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderViewController: UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UITableView     *_tableView;
    NSMutableArray  *_data;
}

@end
