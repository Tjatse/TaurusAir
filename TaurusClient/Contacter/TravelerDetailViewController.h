//
//  TravelerDetailViewController.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefines.h"

@interface TravelerDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray     *_datas;
}
@property   (nonatomic, retain) NSDictionary            *detail;
@property   (nonatomic, retain) IBOutlet UITableView    *tableView;
@property   (nonatomic, readwrite) CONTACTER_TYPE       contacterType;

@end
