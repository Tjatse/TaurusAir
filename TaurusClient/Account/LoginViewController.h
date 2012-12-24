//
//  LoginViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-14.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UITableView     *_tableView;
}

@end
