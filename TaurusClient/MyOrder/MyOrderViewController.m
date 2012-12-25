//
//  MyOrderViewController.m
//  TaurusClient
//
//  Created by Simon on 12-12-12.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "MyOrderViewController.h"
#import "AppConfig.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIBGNavigationController.h"
#import "UIBarButtonItem+Blocks.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "ALToastView.h"
#import "JSONKit.h"
#import "AppDefines.h"


#define TAG_SORT_TIME   100
#define TAG_SORT_PRICE  101
#define TAG_FILTER      102

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController
@synthesize buttonFilter, buttonSortPrice, buttonSortTime;
@synthesize datas = _datas;

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
    [_tableView release];
    [buttonSortTime release];
    [buttonSortPrice release];
    [buttonSortTime release];
    [_datas release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"订单管理"];
    _sort = TIME;
    _asc = NO;
    
    if(![[AppConfig get] isLogon]){
        [self showLoginViewController];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"登录"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self showLoginViewController];
                                             }];
        [ALToastView toastPinInView:self.view withText:@"登录后才能查看订单信息。" andBottomOffset: 120];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGIN_SUC" object:nil];
    }else{
        [self initComponent];
    }

}
#pragma mark -Login Required
- (void)loginSuccess
{
    [self initComponent];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGIN_SUC" object:nil];
}

- (void)showLoginViewController
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    UIBGNavigationController *nav = [[UIBGNavigationController alloc] initWithRootViewController: vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}
#pragma mark -Login Already
- (void) initComponent
{
    self.navigationItem.rightBarButtonItem = nil;
    NSArray *subViews = [self.view subviews];
    if(subViews && [subViews count] > 0){
        for(UIView *v in subViews){
            [v removeFromSuperview];
        }
    }
    
    UIButton *_buttonSortTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSortTime setBackgroundImage:[UIImage imageNamed:@"btn-sort-highlight.png"] forState:UIControlStateNormal];
    [_buttonSortTime setFrame:CGRectMake(10, 5, 86, 29)];
    [_buttonSortTime setTitle:@"时间" forState:UIControlStateNormal];
    [_buttonSortTime setImage:[UIImage imageNamed:@"sort-asc.png"] forState:UIControlStateNormal];
    [_buttonSortTime setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 10, 8)];
    [_buttonSortTime setTag:TAG_SORT_TIME];
    [_buttonSortTime addTarget:self action:@selector(sortEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSortTime setUserInteractionEnabled:YES];
    [_buttonSortTime setShowsTouchWhenHighlighted:YES];
    buttonSortTime = [_buttonSortTime retain];
    [self.view addSubview:buttonSortTime];
    
    UIButton *_buttonSortPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonSortPrice setBackgroundImage:[UIImage imageNamed:@"btn-sort"] forState:UIControlStateNormal];
    [_buttonSortPrice setFrame:CGRectMake((SCREEN_RECT.size.width - 86)/2, 5, 86, 29)];
    [_buttonSortPrice setTitle:@"价格" forState:UIControlStateNormal];
    [_buttonSortPrice setImage:[UIImage imageNamed:@"sort-asc.png"] forState:UIControlStateNormal];
    [_buttonSortPrice setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 10, 8)];
    [_buttonSortPrice setTag:TAG_SORT_PRICE];
    [_buttonSortPrice addTarget:self action:@selector(sortEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSortPrice setUserInteractionEnabled:YES];
    [_buttonSortPrice setShowsTouchWhenHighlighted:YES];
    buttonSortPrice = [_buttonSortPrice retain];
    [self.view addSubview:buttonSortPrice];
    
    UIButton *_buttonFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonFilter setBackgroundImage:[UIImage imageNamed:@"btn-sort"] forState:UIControlStateNormal];
    [_buttonFilter setFrame:CGRectMake(SCREEN_RECT.size.width - 96, 5, 86, 29)];
    [_buttonFilter setTitle:@"筛选" forState:UIControlStateNormal];
    [_buttonFilter setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 10, 8)];
    [_buttonFilter setTag:TAG_FILTER];
    [_buttonFilter addTarget:self action:@selector(sortEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonFilter setUserInteractionEnabled:YES];
    [_buttonFilter setShowsTouchWhenHighlighted:YES];
    buttonFilter = [_buttonFilter retain];
    [self.view addSubview:buttonFilter];
    
    _datas = [[@"[{\"Cabin\":\"Y\",\"Flight\":\"CZ6132\",\"FlightLeaveTime\":\"2012-12-28,07:55,09:15\",\"FromTo\":\"PEKDLC\",\"OrderType\":1,\"Passengers\":null,\"PayState\":1710,\"State\":1010,\"Tid\":6595181},{\"Cabin\":\"N\",\"Flight\":\"MU1302\",\"FlightLeaveTime\":\"2012-12-30,15:25,17:55\",\"FromTo\":\"PEKDLC\",\"OrderType\":1,\"Passengers\":null,\"PayState\":890,\"State\":1010,\"Tid\":6595181},{\"Cabin\":\"Y\",\"Flight\":\"CZ6132\",\"FlightLeaveTime\":\"2013-01-08,07:55,09:15\",\"FromTo\":\"PEKDLC\",\"OrderType\":1,\"Passengers\":null,\"PayState\":950,\"State\":1010,\"Tid\":6595181}]" objectFromJSONString] retain];
    NSLog(@"%d", [_datas count]);
    
    // init tableview.
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 40, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
}
- (void)sortEvent: (UIButton *)button
{
    switch (button.tag) {
        case TAG_SORT_TIME: {
            if(_sort == PRICE){
                [buttonSortPrice setBackgroundImage:[UIImage imageNamed:@"btn-sort.png"] forState:UIControlStateNormal];
            }
            _sort = TIME;
            [buttonSortTime setBackgroundImage:[UIImage imageNamed:@"btn-sort-highlight.png"] forState:UIControlStateNormal];
            if(_asc){
                [buttonSortTime setImage:[UIImage imageNamed:@"sort-dsc.png"] forState:UIControlStateNormal];
            }else{
                [buttonSortTime setImage:[UIImage imageNamed:@"sort-asc"] forState:UIControlStateNormal];
            }
            _asc = !_asc;
        }
            break;
        case TAG_SORT_PRICE:{
            if(_sort == TIME){
                [buttonSortTime setBackgroundImage:[UIImage imageNamed:@"btn-sort.png"] forState:UIControlStateNormal];
            }
            _sort = PRICE;
            [buttonSortPrice setBackgroundImage:[UIImage imageNamed:@"btn-sort-highlight.png"] forState:UIControlStateNormal];
            if(_asc){
                [buttonSortPrice setImage:[UIImage imageNamed:@"sort-dsc.png"] forState:UIControlStateNormal];
            }else{
                [buttonSortPrice setImage:[UIImage imageNamed:@"sort-asc"] forState:UIControlStateNormal];
            }
            _asc = !_asc;
        }
            break;
        case TAG_FILTER:
            
            break;
    }
}

#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableview count");
    return _datas == nil ? 0 : [_datas count];
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary *data = [_datas objectAtIndex:indexPath.row];
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    [labelTime setFont:[UIFont systemFontOfSize:12]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime setText:[[[data objectForKey:@"FlightLeaveTime"] componentsSeparatedByString:@","] objectAtIndex:0]];
    [cell addSubview:labelTime];
    [labelTime release];
    
    UILabel *labelFromTo = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 150, 24)];
    [labelFromTo setFont:[UIFont boldSystemFontOfSize:14]];
    [labelFromTo setBackgroundColor:[UIColor clearColor]];
    [labelFromTo setText:[data objectForKey:@"FromTo"]];
    [cell addSubview:labelFromTo];
    [labelFromTo release];
        
    UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_RECT.size.width - 150, 0, 80, 44)];
    [labelPrice setFont:[UIFont boldSystemFontOfSize:16]];
    [labelPrice setTextColor:[UIColor redColor]];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [labelPrice setText:[NSString stringWithFormat:@"￥%@", [data objectForKey:@"PayState"]]];
    [cell addSubview:labelPrice];
    [labelPrice release];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
