//
//  UIBGNavigationController.h
//  FelixSDK
//
//  Created by Yang Felix on 12-3-13.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBGNavigationController;

typedef void (^OnBackButtonTapBlock)(UIBGNavigationController*);

@interface UIBGNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic, copy) OnBackButtonTapBlock	onBackButtonTapBlock;

@end
