//
//  MyOrderViewController.h
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    PRICE = 0,
    TIME = 1
} ORDER_SORT;

@interface MyOrderViewController: UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    UITableView     *_tableView;
    BOOL            _asc;
    ORDER_SORT      _sort;
    NSDictionary    *_threeCodes;
    NSDictionary    *_orderStates;
    NSInteger       _selectedRow;
}

@property   (nonatomic, retain) IBOutlet    UIButton    *buttonSortTime;
@property   (nonatomic, retain) IBOutlet    UIButton    *buttonSortPrice;
@property   (nonatomic, retain) IBOutlet    UIButton    *buttonFilter;
@property   (nonatomic, retain) IBOutlet    UIImageView *sortImageView;

@property   (nonatomic, retain) NSMutableArray      *datas;
@property   (nonatomic, retain) NSMutableArray      *clonedDatas;

@end
