//
//  EditMyInfoViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-31.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefines.h"
#import "StringInputTableViewCell.h"
#import "GenderPickerInputTableViewCell.h"
#import "DateInputTableViewCell.h"
@class User;

@interface EditMyInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, StringInputTableViewCellDelegate, PickerInputTableViewCellDelegate, DateInputTableViewCellDelegate>{
    NSArray     *_datas;
@private
    UITextField *_focusedTextField;
    User        *_user;
}
@property   (nonatomic, retain) IBOutlet UITableView    *tableView;

@end
