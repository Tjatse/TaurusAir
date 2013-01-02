//
//  AboutViewController.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "AboutViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*		tableView;

@end

@implementation AboutViewController

- (void)dealloc
{
	self.tableView = nil;
	
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
    self.title = @"关于我们";
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
																			   andTapCallback:^(id control, UIEvent *event) {
																				   [self dismissModalViewControllerAnimated:YES];
																			   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		UITableViewCell* result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														 reuseIdentifier:nil];
		
		result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		result.textLabel.text = @"系统版本";
		result.detailTextLabel.text = @"金牛信息ISO 888版";
		
		return [result autorelease];
	} else if (indexPath.row == 1) {
		UITableViewCell* result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
														 reuseIdentifier:nil];
		
		result.textLabel.text = @"公司信息";
		result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return [result autorelease];
	} else if (indexPath.row == 2) {
		UITableViewCell* result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														 reuseIdentifier:nil];
		
		result.textLabel.text = @"公司网址";
		result.detailTextLabel.text = @"jinniuit.com";
		result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return [result autorelease];
	} else {
		UITableViewCell* result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
														 reuseIdentifier:nil];
		
		result.textLabel.text = @"公司电话";
		result.detailTextLabel.text = @"010-53510125";
		result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return [result autorelease];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
	} else if (indexPath.row == 1) {
	} else if (indexPath.row == 2) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.jinniuit.com"]];
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:010-53510125"]];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
