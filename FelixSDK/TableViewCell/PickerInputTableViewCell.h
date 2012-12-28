//
//  ShootStatusInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerInputTableViewCell;

@protocol PickerInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(PickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
@end

@interface PickerInputTableViewCell : UITableViewCell <UIKeyInput, UIPopoverControllerDelegate> {
	// For iPad
	UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) IBOutlet id <PickerInputTableViewCellDelegate> delegate;

@end
