//
//  UIBarButtonItem+Blocks.h
//  FSSDK
//
//  Created by 杨 芹勍 on 12-11-16.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BarButtonItemCallbackBlock)(UIBarButtonItem* item);

@interface UIBarButtonItem (Blocks)

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style callback:(BarButtonItemCallbackBlock)block;
- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style callback:(BarButtonItemCallbackBlock)block NS_AVAILABLE_IOS(5_0); // landscapeImagePhone will be used for the bar button image in landscape bars in UIUserInterfaceIdiomPhone only
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style callback:(BarButtonItemCallbackBlock)block;
- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem callback:(BarButtonItemCallbackBlock)block;

@end
