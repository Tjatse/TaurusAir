//
//  NavViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "NavViewController.h"
#import "UIBGNavigationController.h"
#import "FlightSearchViewController.h"
#import "MyOrderViewController.h"
#import "ContacterViewController.h"
#import "MyInfoViewController.h"
#import "UIControl+BBlock.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "AppDelegate.h"

@interface NavViewController ()

@end

@implementation NavViewController

#pragma mark - life cycle

- (void)dealloc
{
	self.flightSearchVC = nil;
	self.myOrderVC = nil;
	self.contacterVC = nil;
	self.myInfoVC = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.flightSearchVC = [[[FlightSearchViewController alloc] init] autorelease];
	self.myOrderVC = [[[MyOrderViewController alloc] init] autorelease];
	self.contacterVC = [[[ContacterViewController alloc] init] autorelease];
	self.myInfoVC = [[[MyInfoViewController alloc] init] autorelease];
	
	self.viewControllers = [NSArray arrayWithObjects:
							[[[UIBGNavigationController alloc] initWithRootViewController:self.flightSearchVC] autorelease]
							, [[[UIBGNavigationController alloc] initWithRootViewController:self.myOrderVC] autorelease]
							, [[[UIBGNavigationController alloc] initWithRootViewController:self.contacterVC] autorelease]
							, [[[UIBGNavigationController alloc] initWithRootViewController:self.myInfoVC] autorelease]
							, nil];
	
	// tabitems...
	NSArray* tabTitles = @[@"机票搜索", @"我的订单", @"常旅客", @"我的信息"];
	
	for (int count = [self.viewControllers count], n = 0; n < count; ++n) {
		__block UINavigationController* vc = [self.viewControllers objectAtIndex:n];
		
		NSString* title = [tabTitles objectAtIndex:n];
		vc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:[tabTitles objectAtIndex:n]
													   image:[UIImage imageNamed:[NSString stringWithFormat:@"b_btn%d.png", n + 1]]
														 tag:0] autorelease];
		
		vc.topViewController.title = title;

		// back button
		vc.topViewController.navigationItem.leftBarButtonItem
		= [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
											 andTapCallback:^(id control, UIEvent *event) {
												 [vc popToRootViewControllerAnimated:NO];
												 [__APP_NAVVC__ popToRootViewControllerAnimated:YES];
											 }];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - core methods

- (void)switchToFlightSearchTab
{
	self.selectedIndex = 0;
}

- (void)switchToMyOrderTab
{
	self.selectedIndex = 1;
}

- (void)switchToContacterTab
{
	self.selectedIndex = 2;
}

- (void)switchToMyInfoTab
{
	self.selectedIndex = 3;
}

@end
