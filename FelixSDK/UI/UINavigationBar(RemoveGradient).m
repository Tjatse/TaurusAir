//
//  UINavigationBar(RemoveGradient).m
//  FelixSDK
//
//  Created by felix on 12-1-15.
//  Copyright 2012 deep. All rights reserved.
//

#import "UINavigationBar(RemoveGradient).h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar(RemoveGradient)

- (UIImage*) barBackground
{
	return [UIImage imageNamed:@"mainbk.jpg"];
}

- (void) didMoveToSuperview 
{
//    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//		[self setBarStyle:<#(UIBarStyle)#>];
//        [self setBackgroundImage:[self barBackground] forBarMetrics:0];
	
	NSArray* subviews = self.subviews;
	for (UIView* subview in subviews) {
		//NSLog(@"view name: %s", object_getClassName(subview));
		
		if (strcmp(object_getClassName(subview), "UINavigationBarBackground") == 0 /*ios5*/
			|| strcmp(object_getClassName(subview), "_UINavigationBarBackground") == 0) /*ios6*/ {
			
			subview.layer.opacity = 0.0f;
		}
	}
}

- (void) drawRect:(CGRect)rect 
{
//	self.backgroundColor = [UIColor clearColor];
//	[super drawRect:rect];
	
//    [[self barBackground] drawInRect:rect];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSaveGState(context);
//	CGContextBeginPath(context);
//	//CGFloat color[4] = {102 / 256.0f, 153 / 256.0f, 0, 1.0};
//	//CGContextSetFillColor(ref, color);
//	//CGContextFillRect(ref, self.bounds);
//	
//	self.tintColor = [UIColor colorWithRed:19.0f/255.0f green:120.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
//	
//	CGContextDrawImage(context, self.bounds, [self barBackground].CGImage);
//	CGContextStrokePath(context);
//	CGContextRestoreGState(context);
}

@end
