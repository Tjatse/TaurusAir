//
//  DateInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateInputTableViewCell.h"

@implementation DateInputTableViewCell

@synthesize delegate = _delegate;
@synthesize dateValue = _dateValue;
@synthesize dateFormatter = _dateFormatter;
@synthesize datePicker = _datePicker;
@synthesize timerValue = _timerValue;
@synthesize datePickerMode = _datePickerMode;
- (void)dealloc
{
    [_delegate release];
    [_datePicker release];
    [_dateFormatter release];
    [_dateValue release];
    [popoverController release];
    [inputAccessoryView release];
    [super dealloc];
}
- (void)initalizeInputView {
	_dateValue = [[NSDate date] retain];
	
// Initialization code
	_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	[_datePicker setDatePickerMode:UIDatePickerModeDate];
	_datePicker.date = _dateValue;
	[_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view = _datePicker;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate = self;
        [popoverContent release];
	} else {
		CGRect frame = self.inputView.frame;
		frame.size = [_datePicker sizeThatFits:CGSizeZero];
		self.inputView.frame = frame;
		_datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	}
	
	_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	_dateFormatter.timeStyle = NSDateFormatterNoStyle;
	_dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	
	if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
        self.detailTextLabel.text = [self timerStringValue];
    } else {
        self.detailTextLabel.text = [_dateFormatter stringFromDate:_dateValue];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initalizeInputView];
    }
    return self;
}


- (UIView *)inputView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		return _datePicker;
	}
}

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
            [doneBtn release];
            [flexibleSpaceLeft release];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender {
	[self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGSize pickerSize = [_datePicker sizeThatFits:CGSizeZero];
		CGRect frame = _datePicker.frame;
		frame.size = pickerSize;
		_datePicker.frame = frame;
		popoverController.popoverContentSize = pickerSize;
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	} else {
		// nothing to do
	}
    
    if (_datePickerMode == UIDatePickerModeCountDownTimer) {
        _datePicker.countDownDuration = _timerValue;
    } else {
        _datePicker.date = _dateValue;
    }
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	} else {
		// Nothing to do
	}
	UITableView *tableView = (UITableView *)self.superview;
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	return [super resignFirstResponder];
}

- (void)prepareForReuse {
	_dateFormatter.timeStyle = NSDateFormatterNoStyle;
	_dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	_datePicker.datePickerMode = UIDatePickerModeDate;
	_datePicker.maximumDate = nil;
	_datePicker.minimumDate = nil;
}

- (void)setDateValue:(NSDate *)value {
	_dateValue = [value retain];
    if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
        // self.detailTextLabel.text = [self timerStringValue];
    } else {
        self.detailTextLabel.text = [_dateFormatter stringFromDate:_dateValue];
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)mode {
	_datePicker.datePickerMode = mode;
	_dateFormatter.dateStyle = (mode==UIDatePickerModeDate||mode==UIDatePickerModeDateAndTime)?NSDateFormatterMediumStyle:NSDateFormatterNoStyle;
	_dateFormatter.timeStyle = (mode==UIDatePickerModeTime||mode==UIDatePickerModeDateAndTime)?NSDateFormatterShortStyle:NSDateFormatterNoStyle;
    if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
        // _dateValue = nil; // Causes crash
        _timerValue = 60.0;
        self.detailTextLabel.text = [self timerStringValue];
    } else {
        _dateValue = [[NSDate date] retain];
        _timerValue = 0;
        self.detailTextLabel.text = [_dateFormatter stringFromDate:_dateValue];
    }
}

- (UIDatePickerMode)datePickerMode {
	return _datePicker.datePickerMode;
}

- (void)setMaxDate:(NSDate *)max {
	_datePicker.maximumDate = max;
}

- (void)setMinDate:(NSDate *)min {
	_datePicker.minimumDate = min;
}

- (void)setMinuteInterval:(NSUInteger)value {
#pragma warning "Check with Apple why this causes a crash"
	//	[_datePicker setMinuteInterval:value];
}

- (void)dateChanged:(id)sender {
	_dateValue = ((UIDatePicker *)sender).date;
    _timerValue = ((UIDatePicker *)sender).countDownDuration;
    
	if (_delegate && _dateValue) {
        if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer && [_delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithDuration:)]) {
            [_delegate tableViewCell:self didEndEditingWithDuration:_timerValue];
        } else if ([_delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithDate:)]) {
            [_delegate tableViewCell:self didEndEditingWithDate:_dateValue];
        }
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

	if (selected) {
		[self becomeFirstResponder];
	}
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (NSTimeInterval)timerValue {
    return _datePicker.countDownDuration;
}

- (void)setTimerValue:(NSTimeInterval)timerValue {
    if (_datePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
		_datePicker.countDownDuration = timerValue;
		_timerValue = timerValue;

        self.detailTextLabel.text = [self timerStringValue];
    } else {
        // self.detailTextLabel.text = [_dateFormatter stringFromDate:_dateValue];
    }
}

- (NSString *)timerStringValue {
    NSTimeInterval time = _timerValue;
    NSString *result = nil;
    
    if (time >= 3600.0) {
        result = [NSString stringWithFormat:@"%uhr, %umin ", (int)(time / 3600.0), (int)((time / 60.0) - (floor(time / 3600.0) * 60.0))];
    } else if (time >= 60.0) {
        result = [NSString stringWithFormat:@"%umin       ", (int)(time / 60.0)];
    } else {
        result = [NSString stringWithFormat:@"%usec       ", (int)time];
    } // The padding at the end makes it impossible for the detail label to trim the text
    
    // NSLog(@"%@", result);
    return result;
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UITableView *tableView = (UITableView *)self.superview;
		[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
		[self resignFirstResponder];
	}
}

@end
