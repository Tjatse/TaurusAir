//
//  CreateTravelerViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefines.h"
#import "StringInputTableViewCell.h"
#import "GenderPickerInputTableViewCell.h"
#import "TravelerTypePickerTableViewCell.h"
#import "DateInputTableViewCell.h"

@interface CreateTravelerViewController: UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,StringInputTableViewCellDelegate, PickerInputTableViewCellDelegate, DateInputTableViewCellDelegate>{
    NSArray     *_datas;
@private
    UITextField *_focusedTextField;
}
@property   (nonatomic, retain) NSMutableDictionary     *detail;
@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@property   (nonatomic, readwrite) CONTACTER_TYPE       contacterType;
@property   (nonatomic, readwrite) BOOL                 fromTicketOrder;

@end
