//
//  UIBGNavigationController.m
//  FelixSDK
//
//  Created by Yang Felix on 12-3-13.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "UIBGNavigationController.h"
#import "UINavigationBar(RemoveGradient).h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewAdditions.h"

@interface UIBGNavigationController ()

@end

@implementation UIBGNavigationController

@synthesize onBackButtonTapBlock;

- (void)dealloc
{
	self.onBackButtonTapBlock = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
	
    return self;
}

- (void)viewDidLoad
{
//    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbk.jpg"] forBarMetrics:0];
//		self.navigationBar.clipsToBounds = YES;
//        self.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0,1.0);
//        self.navigationBar.layer.shadowOpacity = 0.4;
//        self.navigationBar.layer.shadowRadius = 1.0;
//	}
	
    [super viewDidLoad];
	self.delegate = self;
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:[UIImage imageNamed:@"t_btn_left.png"] forState:UIControlStateNormal];
	[backButton addTarget:self
				   action:@selector(buttonClick:)
		 forControlEvents:UIControlEventTouchUpInside];
	[backButton setTitle:@"返回"
				forState:UIControlStateNormal];
	backButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
	backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
	[backButton sizeToFit];
	
	if ([self.viewControllers count] != 0) {
		UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		viewController.navigationItem.leftBarButtonItem = backItem;
		SAFE_RELEASE(backItem);
	}

	[super pushViewController:viewController animated:animated];
}

- (void)presentModalViewController:(UIViewController *)vc animated:(BOOL)animated
{
	if (animated) {
		[super presentModalViewController:vc animated:YES];
		
//		CABasicAnimation* scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
//		scaleAni.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//		scaleAni.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1)];
//		scaleAni.removedOnCompletion = YES;
//		
//		CABasicAnimation* opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//		opacityAni.fromValue = [NSNumber numberWithFloat:1.0f];
//		opacityAni.toValue = [NSNumber numberWithFloat:0.5f];
//		opacityAni.removedOnCompletion = YES;
//		
//		CAAnimationGroup* groupAni = [CAAnimationGroup animation];
//		groupAni.animations = [NSArray arrayWithObjects:scaleAni, opacityAni, nil];
//		groupAni.duration = 0.7f;
//		groupAni.removedOnCompletion = YES;
//		groupAni.fillMode = kCAFillModeForwards;
//		
//		//	[groupAni setAnimationDidStartBlock:nil
//		//			   andAnimationDidStopBlock:^(CAAnimation *anim, BOOL finished) {
//		//				   if (finished) {
//		//					   [fromNC.view removeFromSuperview];
//		//					   fromNC.view.layer.opacity = 1.0f;
//		//				   } else {
//		//				   }
//		//			   }];
//		
//		[self.view.layer addAnimation:groupAni forKey:@"sink"];
//		
//		CAKeyframeAnimation* appearMoveAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//		appearMoveAni.duration = 0.6f;
//		CGMutablePathRef path = CGPathCreateMutable();
//		CGPathMoveToPoint(path, NULL, vc.view.width / 2.0f, vc.view.height * 1.5f);
//		CGPathAddLineToPoint(path, NULL, vc.view.width / 2.0f, vc.view.height * 0.5f - vc.view.height * 0.05f);
//		CGPathAddLineToPoint(path, NULL, vc.view.width / 2.0f, vc.view.height * 0.5f);
//		
//		appearMoveAni.removedOnCompletion = YES;
//		appearMoveAni.path = path;
//		appearMoveAni.fillMode = kCAFillModeForwards;
//		
//		CGPathRelease(path);
//		
//		[vc.view.layer addAnimation:appearMoveAni forKey:@"blowup"];
	} else {
		[super presentModalViewController:vc animated:NO];
	}
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
	if (animated) {
		[super dismissModalViewControllerAnimated:YES];
		
//		UIViewController* parentVC = self.parentViewController;
//		
//		if (parentVC == nil)
//			parentVC = self.presentingViewController;
//		
//		CABasicAnimation* scaleAni1 = [CABasicAnimation animationWithKeyPath:@"transform"];
//		scaleAni1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1)];
//		scaleAni1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1)];
//		scaleAni1.removedOnCompletion = YES;
//		scaleAni1.duration = 0.35f;
//		
//		CABasicAnimation* scaleAni2 = [CABasicAnimation animationWithKeyPath:@"transform"];
//		scaleAni2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1)];
//		scaleAni2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
//		scaleAni2.removedOnCompletion = YES;
//		scaleAni2.beginTime = 0.35f;
//		scaleAni2.duration = 0.35f;
//		
//		CABasicAnimation* opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
//		opacityAni.fromValue = [NSNumber numberWithFloat:0.5f];
//		opacityAni.toValue = [NSNumber numberWithFloat:1.0f];
//		opacityAni.removedOnCompletion = YES;
//		opacityAni.duration = 0.7f;
//		
//		CAAnimationGroup* groupAni = [CAAnimationGroup animation];
//		groupAni.animations = [NSArray arrayWithObjects:scaleAni1, scaleAni2, opacityAni, nil];
//		groupAni.duration = 0.7f;
//		groupAni.removedOnCompletion = YES;
//		groupAni.fillMode = kCAFillModeForwards;
//		
//		[parentVC.view.layer addAnimation:groupAni forKey:@"sink"];
	} else {
		[super dismissModalViewControllerAnimated:NO];
	}
}

- (IBAction)buttonClick:(id)sender
{
	if (onBackButtonTapBlock != nil)
		onBackButtonTapBlock(self);
	
    [self popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	[viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	[viewController viewDidAppear:animated];
}

@end
