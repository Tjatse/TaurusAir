//
//  BasicSettingsViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "BasicSettingsViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIControl+BBlock.h"
#import "UIAlertView+BBlock.h"
#import "AppContext.h"

@interface BasicSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*		tableView;
@property (nonatomic, retain) UITableViewCell*			departureCell;
@property (nonatomic, retain) UITableViewCell*			arrivalCell;
@property (nonatomic, retain) UITableViewCell*			sortCell;
@property (nonatomic, retain) UITableViewCell*			notificationCell;
@property (nonatomic, retain) UIView*					resetButtonVw;

@end

@implementation BasicSettingsViewController

- (void)dealloc
{
	self.tableView = nil;
	self.departureCell = nil;
	self.arrivalCell = nil;
	self.sortCell = nil;
	self.notificationCell = nil;
	self.resetButtonVw = nil;
	
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"基本设置";
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																			   andTapCallback:^(id control, UIEvent *event) {
																				   [self dismissModalViewControllerAnimated:YES];
																			   }];
	
	self.departureCell = [[NSBundle mainBundle] loadNibNamed:@"BasicSettingsCells" owner:0 options:0][0];
	self.arrivalCell = [[NSBundle mainBundle] loadNibNamed:@"BasicSettingsCells" owner:0 options:0][1];
	self.sortCell = [[NSBundle mainBundle] loadNibNamed:@"BasicSettingsCells" owner:0 options:0][2];
	self.notificationCell = [[NSBundle mainBundle] loadNibNamed:@"BasicSettingsCells" owner:0 options:0][3];
	self.resetButtonVw = [[NSBundle mainBundle] loadNibNamed:@"BasicSettingsCells" owner:0 options:0][4];
	
	// reset button
	UIButton* resetButton = (UIButton*)[self.resetButtonVw viewWithTag:100];
	[resetButton addActionForControlEvents:UIControlEventTouchUpInside
								 withBlock:^(id control, UIEvent *event) {
									 UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
																						 message:@"确认恢复默认设置?"
																			   cancelButtonTitle:@"取消"
																				otherButtonTitle:@"确定"
																				 completionBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
																					 if (buttonIndex == 1) {
																						 [[AppContext get] initSettings];
																						 [self.tableView reloadData];
																					 }
																				 }];
									 
									 [alertView show];
									 SAFE_RELEASE(alertView);
								 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return 0;
	else
		return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 4;
	else
		return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return nil;
	else
		return self.resetButtonVw;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			UITableViewCell* result = self.departureCell;
		
			
			
			return result;
		} else if (indexPath.row == 1)
			return self.arrivalCell;
		else if (indexPath.row == 2)
			return self.sortCell;
		else
			return self.notificationCell;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
