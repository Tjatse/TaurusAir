//
//  StringInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StringInputTableViewCell.h"

@implementation StringInputTableViewCell

@synthesize delegate = _delegate;
@synthesize stringValue = _stringValue;
@synthesize textField = _textField;

- (void)dealloc {
	[_delegate release];
	[_stringValue release];
	[_textField release];
    [super dealloc];
}


- (void)initalizeInputView {
	// Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_textField = [[UITextField alloc] initWithFrame:CGRectZero];
	_textField.autocorrectionType = UITextAutocorrectionTypeDefault;
	_textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	_textField.textAlignment = UITextAlignmentRight;
	_textField.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	_textField.font = [UIFont systemFontOfSize:17.0f];
	_textField.clearButtonMode = UITextFieldViewModeNever;
	_textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	[self addSubview:_textField];
	
	self.accessoryType = UITableViewCellAccessoryNone;
	
	_textField.delegate = self;
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

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[_textField becomeFirstResponder];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		[_textField becomeFirstResponder];
	}
}

- (void)setStringValue:(NSString *)value {
	_textField.text = value;
}

- (NSString *)stringValue {
	return _textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[_textField resignFirstResponder];
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	if (_delegate && [_delegate respondsToSelector:@selector(tableViewCell:didBeginEditingWithString:)]) {
		[_delegate tableViewCell:self didBeginEditingWithString:self.stringValue];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_delegate && [_delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithString:)]) {
		[_delegate tableViewCell:self didEndEditingWithString:self.stringValue];
	}
	UITableView *tableView = (UITableView *)self.superview;
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect editFrame = CGRectInset(self.contentView.frame, 10, 10);
	
	if (self.textLabel.text && [self.textLabel.text length] != 0) {
		CGSize textSize = [self.textLabel sizeThatFits:CGSizeZero];
		editFrame.origin.x += textSize.width + 10;
		editFrame.size.width -= textSize.width + 10;
		_textField.textAlignment = UITextAlignmentRight;
	} else {
		_textField.textAlignment = UITextAlignmentLeft;
	}
	
	_textField.frame = editFrame;
}

@end
