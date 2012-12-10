//
//  UIImage+Thumb.m
//  FSSDK
//
//  Created by Simon on 12-12-5.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIImage+Thumb.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Thumb)

+ (UIImage*)thumbnailImageFromData:(NSData *)data imageSize:(int)imageSize
{
    // use ImageIO to get a thumbnail for a file at a given path
    CGImageSourceRef    imageSource = NULL;
    CGImageRef          thumbnail = NULL;
    // Create a CGImageSource from the URL.
    imageSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    if (imageSource == NULL)
    {
		return nil;
    }
    CFStringRef imageSourceType = CGImageSourceGetType(imageSource);
    if (imageSourceType == NULL)
    {
        CFRelease(imageSource);
        return nil;
    }
	
    // create a thumbnail:
    // - specify max pixel size
    // - create the thumbnail with honoring the EXIF orientation flag (correct transform)
    // - always create the thumbnail from the full image (ignore the thumbnail that may be embedded in the image -
    //                                                  reason: our MAX_ICON_SIZE is larger than existing thumbnail)
	
	NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], (NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent,
							 [NSNumber numberWithLong:imageSize], (NSString *)kCGImageSourceThumbnailMaxPixelSize, //new image size 800*600
							 nil];
    //create thumbnail picture
    thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
	//   [self performSelectorOnMainThread:@selector(setPreviewImage:) withObject:image waitUntilDone:NO];
    [options release];
    
	UIImage* result = [[[UIImage alloc] initWithCGImage:thumbnail] autorelease];
	CFRelease(thumbnail);
	CFRelease(imageSource);
	
	return result;
}

+ (UIImage*)thumbnailImageFromPath:(NSString *)path imageSize:(int)imageSize
{
    // use ImageIO to get a thumbnail for a file at a given path
    CGImageSourceRef    imageSource = NULL;
    CGImageRef          thumbnail = NULL;
    // Create a CGImageSource from the URL.
    imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath: path], NULL);
    if (imageSource == NULL)
    {
		return nil;
    }
    CFStringRef imageSourceType = CGImageSourceGetType(imageSource);
    if (imageSourceType == NULL)
    {
        CFRelease(imageSource);
        return nil;
    }

    // create a thumbnail:
    // - specify max pixel size
    // - create the thumbnail with honoring the EXIF orientation flag (correct transform)
    // - always create the thumbnail from the full image (ignore the thumbnail that may be embedded in the image -
    //                                                  reason: our MAX_ICON_SIZE is larger than existing thumbnail)
	
	NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], (NSString *)kCGImageSourceCreateThumbnailFromImageIfAbsent,
							 [NSNumber numberWithLong:imageSize], (NSString *)kCGImageSourceThumbnailMaxPixelSize, //new image size 800*600
							 nil];
    //create thumbnail picture
    thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
	//   [self performSelectorOnMainThread:@selector(setPreviewImage:) withObject:image waitUntilDone:NO];
    [options release];
    
	UIImage* result = [[[UIImage alloc] initWithCGImage:thumbnail] autorelease];
	CFRelease(thumbnail);
	CFRelease(imageSource);
	
	return result;
}

@end
