//
//  MainViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-11.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "MainViewController.h"
#import "AppContext.h"
#import "NavViewController.h"
#import "UIBGNavigationController.h"
#import "FlightNotificationViewController.h"
#import "FeedbackViewController.h"
#import "BasicSettingsViewController.h"
#import "AboutViewController.h"
#import "ALToastView.h"
#import "AppDefines.h"
#import "UIApplicationAdditions.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (nonatomic, retain) NavViewController*	navVC;

- (IBAction)onFlightSearchButtonTap:(id)sender;
- (IBAction)onMyOrderButtonTap:(id)sender;
- (IBAction)onContacterButtonTap:(id)sender;
- (IBAction)onMyInfoButtonTap:(id)sender;
- (IBAction)onFlightNotificationButtonTap:(id)sender;
- (IBAction)onBasicSettingsButtonTap:(id)sender;
- (IBAction)onFeedbackButtonTap:(id)sender;
- (IBAction)onAboutButtonTap:(id)sender;

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGOUT" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ALIXPAY_CALLBACK_SUCCESS" object:nil];

	self.navVC = nil;
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNav:) name:@"LOGOUT" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallbackSuccess) name:@"ALIXPAY_CALLBACK_SUCCESS" object:nil];
    }
    return self;
}

#pragma mark - impl props

- (NavViewController *)navVC
{
	if (_navVC == nil){
		_navVC = [[NavViewController alloc] init];
        [AppContext get].navController = _navVC;
    }
	
	return _navVC;
}

#pragma mark - ui actions

- (IBAction)onFlightSearchButtonTap:(id)sender
{
	[self.navVC switchToFlightSearchTab];
	[self.navigationController pushViewController:self.navVC animated:YES];
}

- (IBAction)onMyOrderButtonTap:(id)sender
{
    [self.navVC switchToMyOrderTab];
    [self.navigationController pushViewController:self.navVC animated:YES];
}

- (IBAction)onContacterButtonTap:(id)sender
{
	[self.navVC switchToContacterTab];
	[self.navigationController pushViewController:self.navVC animated:YES];
}

- (IBAction)onMyInfoButtonTap:(id)sender
{
	[self.navVC switchToMyInfoTab];
	[self.navigationController pushViewController:self.navVC animated:YES];
}

- (void)onFlightNotificationButtonTap:(id)sender
{
	FlightNotificationViewController* vc = [[FlightNotificationViewController alloc] init];
	UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
	
	[self.navigationController presentModalViewController:navVC animated:YES];
	
	SAFE_RELEASE(navVC);
	SAFE_RELEASE(vc);
}

- (void)onBasicSettingsButtonTap:(id)sender
{
	BasicSettingsViewController* vc = [[BasicSettingsViewController alloc] init];
	UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
	
	[self.navigationController presentModalViewController:navVC animated:YES];
	
	SAFE_RELEASE(navVC);
	SAFE_RELEASE(vc);
}

- (void)onFeedbackButtonTap:(id)sender
{
	FeedbackViewController* vc = [[FeedbackViewController alloc] init];
	UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
	
	[self.navigationController presentModalViewController:navVC animated:YES];
	
	SAFE_RELEASE(navVC);
	SAFE_RELEASE(vc);
}

- (void)onAboutButtonTap:(id)sender
{
	AboutViewController* vc = [[AboutViewController alloc] init];
	UIBGNavigationController* navVC = [[UIBGNavigationController alloc] initWithRootViewController:vc];
	
	[self.navigationController presentModalViewController:navVC animated:YES];
	
	SAFE_RELEASE(navVC);
	SAFE_RELEASE(vc);
}

#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)resetNav:(NSNotification *)notification
{
    self.navVC = nil;
    [[AppContext get] setNavController:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - core methods

- (void)alipayCallbackSuccess
{
	[self.navigationController popToRootViewControllerAnimated:YES];
	[__APP_NAVVC__.topViewController dismissModalViewControllerAnimated:YES];
	[self onMyOrderButtonTap:nil];
	
	[ALToastView toastInView:[UIApplication mainWindow]
					withText:@"支付成功。"
			 andBottomOffset:84 andType:INFOMATION];
}

@end
