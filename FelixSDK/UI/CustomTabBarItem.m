//
//  CustomTabBarItem.m
//  FelixSDK
//
//  Created by Yang Felix on 12-3-22.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem

@synthesize customHighlightedImage;

- (void)dealloc 
{
    [customHighlightedImage release];
    customHighlightedImage = nil;
    [super dealloc];
}

- (UIImage*)selectedImage 
{
    return self.customHighlightedImage;
}

@end
