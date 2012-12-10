//
//  UIImage+RadiusBorder.m
//  FelixSDK
//
//  Created by Yang Felix on 12-4-11.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIImage+RadiusBorder.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+RoundedCorner.m"

@implementation UIImage (RadiusBorder)

- (UIImage*)imageWithRadiusBorder:(float)radius
					  borderWidth:(int)borderWidth
					  borderColor:(UIColor*)borderColor
{
	float newWidth = self.size.width + borderWidth * 2;
	float newHeight = self.size.height + borderWidth * 2;
	
	CGSize size = CGSizeMake(newWidth, newHeight);
	if (UIGraphicsBeginImageContextWithOptions != NULL)
		UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	else
		UIGraphicsBeginImageContext(size);

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(context);
    CGContextMoveToPoint(context, newWidth, newHeight/2);
    CGContextAddArcToPoint(context, newWidth, newHeight, newWidth/2, newHeight,   radius);
    CGContextAddArcToPoint(context, 0, newHeight, 0, newHeight/2, radius);
    CGContextAddArcToPoint(context, 0, 0, newWidth/2, 0, radius);
    CGContextAddArcToPoint(context, newWidth, 0, newWidth, newHeight/2, radius);
    CGContextClosePath(context);
    CGContextClip(context);
	
	// 绘制边框背景
	CGContextSetFillColorWithColor(context, borderColor.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, newWidth, newHeight));
	
	// 新的半径
	float newRadius = radius - (float)borderWidth;
	UIImage* imgWithCorner = [self roundedCornerImage:(int)newRadius borderSize:0];
	
	[imgWithCorner drawAtPoint:CGPointMake(borderWidth, borderWidth)];
	
	CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor darkGrayColor] CGColor]);		
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

@end
