//
//  CustomTabBarItem.h
//  FelixSDK
//
//  Created by Yang Felix on 12-3-22.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem
{
    UIImage  *customHighlightedImage;
}

@property (nonatomic, retain) UIImage* customHighlightedImage;

@end
