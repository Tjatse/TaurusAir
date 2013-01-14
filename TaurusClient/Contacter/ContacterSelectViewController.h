//
//  ContacterSelectViewController.h
//  TaurusClient
//
//  Created by Tjatse on 13-1-13.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

typedef enum {
    SelectTypeContacter = 0,
    SelectTypePassenger = 1
}SelectType;

typedef void (^SelectBlock)(NSDictionary *selectedPersons);

@interface ContacterSelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CMPopTipViewDelegate>{
    NSArray                 *_datas;
    SelectBlock             _completionBlock;
    SelectType              _selectType;
    NSMutableDictionary     *_selectedPersons;
    int                     _selectedRow; // for contacter.
    CMPopTipView            *_roundRectButtonPopTipView;
}

@property   (nonatomic, retain) IBOutlet UITableView    *tableView;

- (id)initWithSelectType: (SelectType)theSelectType defaultSeletedData: (NSDictionary *)defaultSeletedData;
- (void)setCompletionBlock: (SelectBlock)theCompletionBlock;
@end
