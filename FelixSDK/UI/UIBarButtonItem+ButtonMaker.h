//
//  UIBarButtonItem+ButtonMaker.h
//  TaurusClient
//
//  Created by Simon on 12-12-11.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+BBlock.h"

@interface UIBarButtonItem (ButtonMaker)

+ (UIBarButtonItem*)generateButtonWithTitle:(NSString*)title
						 andBackgroundImage:(UIImage*)bgImg
						 andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
							 andTapCallback:(BBlockUIControlBlock)block;

+ (UIBarButtonItem*)generateBackStyleButtonWithTitle:(NSString*)title
									  andTapCallback:(BBlockUIControlBlock)block;

+ (UIBarButtonItem*)generateNormalStyleButtonWithTitle:(NSString*)title
										andTapCallback:(BBlockUIControlBlock)block;

@end
