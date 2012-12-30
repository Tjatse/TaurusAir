//
//  MyInfoViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
}

@property   (retain, nonatomic) IBOutlet UITableView    *tableView;

@end
