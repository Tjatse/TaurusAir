//
//  UIImage+RadiusBorder.h
//  FelixSDK
//
//  Created by Yang Felix on 12-4-11.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RadiusBorder)

- (UIImage*)imageWithRadiusBorder:(float)radius
					  borderWidth:(int)borderWidth
					  borderColor:(UIColor*)borderColor;

@end
