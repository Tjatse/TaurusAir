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
	
}

- (void)onBasicSettingsButtonTap:(id)sender
{
	
}

- (void)onFeedbackButtonTap:(id)sender
{
	
}

- (void)onAboutButtonTap:(id)sender
{
	
}

#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNav:) name:@"LOGOUT" object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGOUT" object:nil];
    [super viewDidUnload];
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

@end
