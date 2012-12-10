//
//  UIImageView+AsyncRemoteImage.m
//  FSSDK
//
//  Created by 杨 芹勍 on 12-11-16.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIImageView+AsyncRemoteImage.h"
#import "UIViewAdditions.h"

//@interface UIImageView(IAP)
//@end


@implementation UIImageView (AsyncRemoteImage)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url options:0];
}

- (void)setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
	UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
	loadingView.autoresizingMask = UIViewAutoresizingNone;
	loadingView.tag = 9900;
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
	
	[loadingView release];
	loadingView = nil;
}

#if NS_BLOCKS_AVAILABLE

- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
	UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
	loadingView.autoresizingMask = UIViewAutoresizingNone;
	loadingView.tag = 9900;
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
	
	[loadingView release];
	loadingView = nil;
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
	
	UIActivityIndicatorView* loading = (UIActivityIndicatorView*)[self viewWithTag:9900];
	[loading removeFromSuperview];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    [self setNeedsLayout];
	
	UIActivityIndicatorView* loading = (UIActivityIndicatorView*)[self viewWithTag:9900];
	[loading removeFromSuperview];
}

@end
