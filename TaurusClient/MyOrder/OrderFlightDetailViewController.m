//
//  OrderFlightDetailViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "OrderFlightDetailViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "AppDefines.h"
#import "BBlock.h"

@interface OrderFlightDetailViewController ()

@end

@implementation OrderFlightDetailViewController
@synthesize detail = _detail;
@synthesize tableView = _tableView;
@synthesize showHomeButton = _showHomeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_datas release];
    [_tableView release];
    [_detail release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.[self setTitle:@"订单筛选"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setTitle:@"航班信息"];
    
    _datas = [[NSArray alloc] initWithArray: @[@"航空公司", @"航班", @"舱位", @"出发机场", @"出发时间", @"到达机场", @"到达时间"]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    if(_showHomeButton){
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"订单"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    }
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.row]];
    
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setText:_detail[indexPath.row]];
    return cell;
}
@end
