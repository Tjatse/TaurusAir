//
//  ContacterViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TRAVELERS = 100,
    CONTACTORS = 101
} TABLEVIEW_VISIBLE;

@interface ContacterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    TABLEVIEW_VISIBLE   currentTableView;
    NSMutableArray      *_travelers;
    NSMutableArray      *_contactors;
}

@property (nonatomic, retain)   IBOutlet    UIButton        *buttonTravelers;
@property (nonatomic, retain)   IBOutlet    UIButton        *buttonContactors;
@property (nonatomic, retain)   IBOutlet    UITableView     *tableViewTravelers;
@property (nonatomic, retain)   IBOutlet    UITableView     *tableViewContactors;

- (IBAction)swithTableView:(id)sender;
@end
