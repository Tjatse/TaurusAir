//
//  UIBarButtonItem+Blocks.m
//  FSSDK
//
//  Created by 杨 芹勍 on 12-11-16.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIBarButtonItem+Blocks.h"

@interface NSObject (BlocksInvoke)

-(void)blockInvoke:(UIBarButtonItem*)sender;

@end

@implementation NSObject (BlocksInvoke)

-(void)blockInvoke:(UIBarButtonItem*)sender
{
	void(^block)(UIBarButtonItem*) = (void*)self;
	block(sender);
}

@end

@implementation UIBarButtonItem (Blocks)

- (id)initWithImage:(UIImage *)image
			  style:(UIBarButtonItemStyle)style
		   callback:(BarButtonItemCallbackBlock)block
{
	return [self initWithImage:image
						 style:style
						target:[[block copy] autorelease]
						action:@selector(blockInvoke:)];
}

- (id)initWithImage:(UIImage *)image
landscapeImagePhone:(UIImage *)landscapeImagePhone
			  style:(UIBarButtonItemStyle)style
		   callback:(BarButtonItemCallbackBlock)block
{
	return [self initWithImage:image
		   landscapeImagePhone:landscapeImagePhone
						 style:style
						target:[[block copy] autorelease]
						action:@selector(blockInvoke:)];
}

- (id)initWithTitle:(NSString *)title
			  style:(UIBarButtonItemStyle)style
		   callback:(BarButtonItemCallbackBlock)block
{
	return [self initWithTitle:title
						 style:style
						target:[[block copy] autorelease]
						action:@selector(blockInvoke:)];
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
						 callback:(BarButtonItemCallbackBlock)block
{
	return [self initWithBarButtonSystemItem:systemItem
									  target:[[block copy] autorelease]
									  action:@selector(blockInvoke:)];
}

@end
