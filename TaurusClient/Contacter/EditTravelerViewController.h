//
//  EditTravelerViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "GenderPickerInputTableViewCell.h"
#import "TravelerTypePickerTableViewCell.h"
#import "DateInputTableViewCell.h"

@interface EditTravelerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,StringInputTableViewCellDelegate, PickerInputTableViewCellDelegate, DateInputTableViewCellDelegate>{
    NSArray     *_datas;
}
@property   (nonatomic, retain) NSDictionary            *detail;
@property   (nonatomic, retain) IBOutlet UITableView    *tableView;

@end
