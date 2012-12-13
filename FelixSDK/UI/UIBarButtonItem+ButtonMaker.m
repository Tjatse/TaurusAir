//
//  UIBarButtonItem+ButtonMaker.m
//  TaurusClient
//
//  Created by Simon on 12-12-11.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "UIBarButtonItem+ButtonMaker.h"

@implementation UIBarButtonItem (ButtonMaker)

+ (UIBarButtonItem*)generateButtonWithTitle:(NSString*)title
						 andBackgroundImage:(UIImage*)bgImg
						 andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
							 andTapCallback:(BBlockUIControlBlock)block
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setBackgroundImage:bgImg forState:UIControlStateNormal];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	button.titleEdgeInsets = titleEdgeInsets;
	[button sizeToFit];
	[button addActionForControlEvents:UIControlEventTouchUpInside
							withBlock:block];
		
	UIBarButtonItem* result = [[UIBarButtonItem alloc] initWithCustomView:button];
	return [result autorelease];
}

+ (UIBarButtonItem*)generateBackStyleButtonWithTitle:(NSString*)title
									  andTapCallback:(BBlockUIControlBlock)block
{
	UIBarButtonItem* result = [self generateButtonWithTitle:title
										 andBackgroundImage:[UIImage imageNamed:@"t_btn_left.png"]
										 andTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)
											 andTapCallback:block];
	
	return result;
}

+ (UIBarButtonItem*)generateNormalStyleButtonWithTitle:(NSString*)title
										andTapCallback:(BBlockUIControlBlock)block
{
	return [self generateButtonWithTitle:title
					  andBackgroundImage:[UIImage imageNamed:@"t_btn_right.png"]
					  andTitleEdgeInsets:UIEdgeInsetsZero
						  andTapCallback:block];
}

@end
