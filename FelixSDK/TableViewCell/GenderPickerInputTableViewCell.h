//
//  TravelerDetailViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-27.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@class GenderPickerInputTableViewCell;

@interface GenderPickerInputTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *value;
}

@property (nonatomic, strong) NSString *value;

@end
