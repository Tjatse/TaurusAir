//
//  UIImageView+AsyncRemoteImage.h
//  FSSDK
//
//  Created by 杨 芹勍 on 12-11-16.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@interface UIImageView (AsyncRemoteImage) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options;

#if NS_BLOCKS_AVAILABLE

- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
- (void)setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;

#endif

- (void)cancelCurrentImageLoad;

@end
