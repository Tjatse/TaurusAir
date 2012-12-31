//
//  OrderFilterViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "OrderFilterViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "AppDefines.h"
#import "BBlock.h"

@interface OrderFilterViewController ()

@end

@implementation OrderFilterViewController
@synthesize tableView = _tableView;
@synthesize selectedRow = _selectedRow;

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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.self.title = @"登录/注册";
    
    [self setTitle:@"订单筛选"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _datas = [[NSArray alloc] initWithArray: @[@"全部", @"新订单", @"处理中", @"出票完成", @"退票处理中", @"退票完成"]];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem generateNormalStyleButtonWithTitle:@"确定"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_FILTER" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", _selectedRow] forKey:@"selectedRow"]];
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if(indexPath.row == _selectedRow){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedRow == indexPath.row){
        return;
    }
    UITableViewCell *oldCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedRow = indexPath.row;
    [cell setSelected:NO];
}

@end
