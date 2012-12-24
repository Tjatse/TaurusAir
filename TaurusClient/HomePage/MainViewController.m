//
//  MainViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-11.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "MainViewController.h"
#import "NavViewController.h"
#import "AppConfig.h"
#import "LoginViewController.h"

@interface MainViewController ()

@property (nonatomic, retain) NavViewController*	navVC;

@end

@implementation MainViewController

#pragma mark - life cycle

- (void)dealloc
{
	self.navVC = nil;
	
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

#pragma mark - impl props

- (NavViewController *)navVC
{
	if (_navVC == nil)
		_navVC = [[NavViewController alloc] init];
	
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

#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES];
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

@end
