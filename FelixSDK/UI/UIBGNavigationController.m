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
	[backButton setBackgroundImage:[UIImage imageNamed:@"nav_back_btn_bg.png"] forState:UIControlStateNormal];
	[backButton addTarget:self
				   action:@selector(buttonClick:)
		 forControlEvents:UIControlEventTouchUpInside];
	[backButton setImage:[UIImage imageNamed:@"cancel_icon.png"]
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
