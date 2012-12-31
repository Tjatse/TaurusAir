//
//  ChangePwdViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-31.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>{
    
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
