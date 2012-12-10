//
//  UIImage+Thumb.h
//  FSSDK
//
//  Created by Simon on 12-12-5.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumb)

+ (UIImage*)thumbnailImageFromData:(NSData *)data imageSize:(int)imageSize;
+ (UIImage*)thumbnailImageFromPath:(NSString *)path imageSize:(int)imageSize;

@end
