//
//  SurroundRangeViewController.h
//  FelixSDK
//
//  Created by felix on 12-1-29.
//  Copyright 2012 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int (^ListCountBlock) ();
typedef NSString* (^ListTitleBlock) (int row);
typedef void (^ListSelectedChangedBlock) (BOOL isOk, int newRange);

@interface PickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	IBOutlet UIPickerView*		pickerView;
	IBOutlet UIBarButtonItem*	okBtn;
	IBOutlet UIBarButtonItem*	cancelBtn;
	IBOutlet UIToolbar*			toolbar;
	
@private
	int							_selectedIndex;
	id							_cmdTarget;
	SEL							_cmdActionSelector;
	BOOL						_isOkBtnTapped;
	SEL							_rowsCountSelector;
	SEL							_rowTitleSelector;
}

@property (nonatomic, assign) int 						selectedIndex;
@property (nonatomic, assign) SEL 						cmdActionSelector;
@property (nonatomic, assign) SEL 						rowsCountSelector;
@property (nonatomic, assign) SEL 						rowTitleSelector;
@property (nonatomic, copy) ListCountBlock				listCountBlock;
@property (nonatomic, copy) ListTitleBlock				listTitleBlock;
@property (nonatomic, copy) ListSelectedChangedBlock	listSelectedChangedBlock;

- (id) initWithTarget:(id)target;

- (id)initWithSelectedIndex:(int)index
		  andListCountBlock:(ListCountBlock)listCountBlock
		  andListTitleBlock:(ListTitleBlock)listTitleBlock
andListSelectedChangedBlock:(ListSelectedChangedBlock)listSelectedChangedBlock;

- (id) initWithSelectedIndex:(int)index
					  target:(id)target
					  action:(SEL)action
		   rowsCountSelector:(SEL)rowsCountSelector
			rowTitleSelector:(SEL)rowTitleSelector;

- (IBAction) blankAreaTapped:(id)sender;

@end
