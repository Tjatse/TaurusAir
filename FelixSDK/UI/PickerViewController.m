//
//  SurroundRangeViewController.m
//  FelixSDK
//
//  Created by felix on 12-1-29.
//  Copyright 2012 deep. All rights reserved.
//

#import "PickerViewController.h"
#import "UIViewAdditions.h"

@interface PickerViewController ()

- (void) okButtonTapped;
- (void) cancelButtonTapped;
- (void) performButtonTapped;
- (void) performAnimationStoped;

@end

@implementation PickerViewController

@synthesize selectedIndex = _selectedIndex;
@synthesize cmdActionSelector = _cmdActionSelector;
@synthesize rowsCountSelector = _rowsCountSelector;
@synthesize rowTitleSelector = _rowTitleSelector;
@synthesize listTitleBlock;
@synthesize listCountBlock;
@synthesize listSelectedChangedBlock;

- (id) initWithTarget:(id)target {
	if (self = [self initWithSelectedIndex:-1 
									target:target 
									action:nil 
						 rowsCountSelector:nil 
						  rowTitleSelector:nil]) {
		
	}
	
	return self;
}

- (id) initWithSelectedIndex:(int)index
					  target:(id)target
					  action:(SEL)action
		   rowsCountSelector:(SEL)rowsCountSelector
			rowTitleSelector:(SEL)rowTitleSelector {
	
	if (self = [super init]) {
		_selectedIndex = index;
		_cmdTarget = target;
		_cmdActionSelector = action;
		_rowsCountSelector = rowsCountSelector;
		_rowTitleSelector = rowTitleSelector;
	}
	
	return self;
}

- (id)initWithSelectedIndex:(int)index
		  andListCountBlock:(ListCountBlock)aListCountBlock
		  andListTitleBlock:(ListTitleBlock)aListTitleBlock
andListSelectedChangedBlock:(ListSelectedChangedBlock)aListSelectedChangedBlock
{
	if (self = [super init]) {
		_selectedIndex = index;
		self.listCountBlock = aListCountBlock;
		self.listTitleBlock = aListTitleBlock;
		self.listSelectedChangedBlock = aListSelectedChangedBlock;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
	
	okBtn.target = self;
	okBtn.action = @selector(okButtonTapped);
	
	cancelBtn.target = self;
	cancelBtn.action = @selector(cancelButtonTapped);
	
	okBtn.title = NSLocalizedString(@"OK", nil);
	cancelBtn.title = NSLocalizedString(@"Cancel", nil);
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[pickerView selectRow:_selectedIndex inComponent:0 animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[toolbar setTop:[self.view height]];
	[pickerView setTop:[toolbar bottom]];
	
	[UIView beginAnimations:nil context:nil];
	
	[toolbar setTop:[self.view height] - [pickerView height] - [toolbar height]];
	[pickerView setTop:[self.view height] - [pickerView height]];
	
	[UIView commitAnimations];
}

- (void) okButtonTapped {
	_isOkBtnTapped = YES;
	[self performButtonTapped];
}

- (void) cancelButtonTapped {
	_isOkBtnTapped = NO;
	[self performButtonTapped];
}

- (IBAction) blankAreaTapped:(id)sender {
	[self cancelButtonTapped];
}

- (void) performButtonTapped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(performAnimationStoped)];
	
	[toolbar setTop:[self.view height]];
	[pickerView setTop:[toolbar bottom]];
	
	[UIView commitAnimations];
}

- (void) performAnimationStoped {
	[UIView setAnimationDelegate:nil];
	[UIView setAnimationDidStopSelector:nil];
	
	if ([_cmdTarget respondsToSelector:_cmdActionSelector])
		[_cmdTarget performSelector:_cmdActionSelector 
						 withObject:[NSNumber numberWithBool:_isOkBtnTapped] 
						 withObject:[NSNumber numberWithInt:[pickerView selectedRowInComponent:0]]];
	
	if (self.listSelectedChangedBlock != nil)
		self.listSelectedChangedBlock(_isOkBtnTapped, [pickerView selectedRowInComponent:0]);
	
	[self.view removeFromSuperview];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) dealloc {
	pickerView = nil;
	okBtn = nil;
	cancelBtn = nil;
	toolbar = nil;
	_cmdTarget = nil;
	_cmdActionSelector = nil;
	
	self.listCountBlock = nil;
	self.listSelectedChangedBlock = nil;
	self.listTitleBlock = nil;
	
    [super dealloc];
}

- (void) setRowsCountSelector:(SEL)value {
	_rowsCountSelector = value;
	[pickerView reloadAllComponents];
}

- (void)setListCountBlock:(ListCountBlock)aListCountBlock
{
	SAFE_RELEASE(listCountBlock);
	listCountBlock = [aListCountBlock copy];
	[pickerView reloadAllComponents];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
	if ([_cmdTarget respondsToSelector:_rowsCountSelector]) {
		NSNumber* rows = [_cmdTarget performSelector:_rowsCountSelector];
		int result = [rows intValue];
		
		return result;
	} else if (self.listCountBlock != nil) {
		int result = self.listCountBlock();
		return result;
	}
	
	return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView 
			  titleForRow:(NSInteger)row 
			 forComponent:(NSInteger)component 
{	
	if ([_cmdTarget respondsToSelector:_rowTitleSelector]) {
		NSString* result = [_cmdTarget performSelector:_rowTitleSelector withObject:[NSNumber numberWithInt:row]];
		return result;
	} else if (self.listTitleBlock != nil) {
		NSString* result = self.listTitleBlock(row);
		return result;
	}
	
	return nil;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

@end
