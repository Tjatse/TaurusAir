//
//  TravelerDetailViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "PickerInputTableViewCell.h"


@interface TravelerTypePickerTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) NSString  *value;
@property (nonatomic, retain) NSArray   *values;

@end
