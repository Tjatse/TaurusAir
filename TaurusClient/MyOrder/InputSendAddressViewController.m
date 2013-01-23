//
//  InputSendAddressViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-23.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "InputSendAddressViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "PrepareOrderViewController.h"

@interface InputSendAddressViewController ()

@property (nonatomic, assign) PrepareOrderViewController*	parentVC;

@end

@implementation InputSendAddressViewController

- (void)dealloc
{
	self.sendAddress = nil;
	self.sendAddressTextVw = nil;
	[super dealloc];
}

- (id)initWithParentVC:(PrepareOrderViewController *)aParentVC
{
	if (self = [super init]) {
		self.parentVC = aParentVC;
	}
	
	return self;
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
    [super viewDidLoad];
    self.title = @"报销凭证";
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																			   andTapCallback:^(id control, UIEvent *event) {
																				   [self dismissModalViewControllerAnimated:YES];
																			   }];
	
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem generateNormalStyleButtonWithTitle:@"确定"
																				  andTapCallback:^(id control, UIEvent *event) {
																					  self.parentVC.sendAddress = self.sendAddressTextVw.text;
																					  [self dismissModalViewControllerAnimated:YES];
																				  }];
	
	self.sendAddressTextVw.text = self.sendAddress;
	[self.sendAddressTextVw becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
