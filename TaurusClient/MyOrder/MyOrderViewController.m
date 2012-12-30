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
#import "CharCodeHelper.h"
#import "OrderFilterViewController.h"
#import "OrderDetailViewController.h"
#import "OrderState.h"

#define TAG_SORT_TIME   100
#define TAG_SORT_PRICE  101
#define TAG_FILTER      102

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController
@synthesize buttonFilter, buttonSortPrice, buttonSortTime;
@synthesize datas = _datas;
@synthesize clonedDatas = _clonedDatas;

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
    [_threeCodes release];
    [_orderStates release];
    [_clonedDatas release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
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
        [ALToastView toastPinInView:self.view withText:@"登录后才能访问“订单管理”。" andBottomOffset: 120];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterOrder:) name:@"ORDER_FILTER" object:nil];
    _orderStates = [[NSDictionary alloc] initWithDictionary:[CharCodeHelper allOrderStates]];
    _threeCodes = [[NSDictionary alloc] initWithDictionary:[CharCodeHelper allThreeCharCodesDictionary]];
    
    self.navigationItem.rightBarButtonItem = nil;
    NSArray *subViews = [self.view subviews];
    if(subViews && [subViews count] > 0){
        for(UIView *v in subViews){
            [v removeFromSuperview];
        }
    }
    
    buttonSortTime = [[self generateSortButton:CGRectMake(10, 5, 86, 29)
                                         title:@"时间"
                                     highlight:NO
                                      needSort:YES
                                           tag:TAG_SORT_TIME] retain];
    [self.view addSubview:buttonSortTime];
    
    buttonSortPrice = [[self generateSortButton:CGRectMake((SCREEN_RECT.size.width - 86)/2, 5, 86, 29)
                                          title:@"航班"
                                      highlight:NO
                                       needSort:YES
                                            tag:TAG_SORT_PRICE] retain];
    [self.view addSubview:buttonSortPrice];
    
    buttonFilter = [[self generateSortButton:CGRectMake(SCREEN_RECT.size.width - 96, 5, 86, 29)
                                       title:@"筛选"
                                   highlight:NO
                                    needSort:NO
                                         tag:TAG_FILTER] retain];
    [self.view addSubview:buttonFilter];
        
    _datas = [[@"[{\"Cabin\":\"Y\",\"Flight\":\"CZ6132\",\"FlightLeaveTime\":\"2012-12-28,07:55,09:15\",\"FromTo\":\"PEKDLC\",\"OrderType\":1,\"Passengers\":null,\"PayState\":1710,\"State\":1010,\"Tid\":6595181},{\"Cabin\":\"N\",\"Flight\":\"MU1302\",\"FlightLeaveTime\":\"2012-12-30,15:25,17:55\",\"FromTo\":\"FUOHIA\",\"OrderType\":1,\"Passengers\":null,\"PayState\":1710,\"State\":1170,\"Tid\":6595181},{\"Cabin\":\"Y\",\"Flight\":\"CZ6132\",\"FlightLeaveTime\":\"2013-01-08,07:55,09:15\",\"FromTo\":\"HJJDQA\",\"OrderType\":1,\"Passengers\":null,\"PayState\":1710,\"State\":1200,\"Tid\":6595181}]" objectFromJSONString] retain];
    _clonedDatas = [_datas mutableCopy];
    
    // init tableview.
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 40, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [self.view addSubview:_tableView];
}
#pragma mark Filter
- (void)filterOrder: (NSNotification *)notification
{
    _selectedRow = [[[notification userInfo] objectForKey:@"selectedRow"] intValue];
    if(_sort == PRICE){
        [buttonSortPrice setBackgroundImage:[UIImage imageNamed:@"btn-sort.png"] forState:UIControlStateNormal];
    }
    else if(_sort == TIME){
        [buttonSortTime setBackgroundImage:[UIImage imageNamed:@"btn-sort.png"] forState:UIControlStateNormal];
    }
    
    [buttonFilter setBackgroundImage:[UIImage imageNamed:@"btn-sort-highlight.png"] forState:UIControlStateNormal];
    NSPredicate *predicate = nil;
    switch (_selectedRow) {
        case 0: // 全部
            [buttonFilter setBackgroundImage:[UIImage imageNamed:@"btn-sort"] forState:UIControlStateNormal];
            break;
        case 1: // 新订单 1010
            predicate = [NSPredicate predicateWithFormat:@"State==1010"];
            break;
        case 2: // 处理中 1200，1210
            predicate = [NSPredicate predicateWithFormat:@"State==1200 || State==1210"];
            break;
        case 3: // 出票完成 1260
            predicate = [NSPredicate predicateWithFormat:@"State==1260"];
            break;
        case 4: // 退票处理中 1510,1530
            predicate = [NSPredicate predicateWithFormat:@"State==1510 || State==1530"];
            break;
        case 5: // 退票完成 1560
            predicate = [NSPredicate predicateWithFormat:@"State==1560"];
            break;
    }
    
    [_datas release];
    if(predicate){
        _datas = [[_clonedDatas filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        _datas = [_clonedDatas mutableCopy];
    }
    [_tableView reloadData];
}
#pragma mark Generate Buttons
- (UIButton *)generateSortButton: (CGRect)frame
                           title: (NSString *)title
                       highlight: (BOOL)highlight
                        needSort: (BOOL)needSort
                             tag: (int)tag
{
    UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:[UIImage imageNamed:(highlight ? @"btn-sort-highlight.png":@"btn-sort")] forState:UIControlStateNormal];
    [_button setFrame:frame];
    [_button setTitle:title forState:UIControlStateNormal];
    if(needSort){
        [_button setImage:[UIImage imageNamed:@"sort-asc.png"] forState:UIControlStateNormal];
        [_button setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 10, 8)];
    }
    [_button setTag:tag];
    [_button addTarget:self action:@selector(sortEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_button setUserInteractionEnabled:YES];
    [_button setShowsTouchWhenHighlighted:YES];
    return _button;
}
#pragma mark Sort
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
            [self sortByKey:@"FlightLeaveTime" andASC:_asc];
            [_tableView reloadData];
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
            [self sortByKey:@"Flight" andASC:_asc];
            [_tableView reloadData];
        }
            break;
        case TAG_FILTER:{
            OrderFilterViewController *vc = [[OrderFilterViewController alloc] init];
            vc.selectedRow = _selectedRow;
            UIBGNavigationController *nav = [[UIBGNavigationController alloc] initWithRootViewController: vc];
            [self.navigationController presentModalViewController:nav animated:YES];
            [vc release];
            [nav release];
        }
            break;
    }
}

#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 20)];
    [labelTime setFont:[UIFont systemFontOfSize:12]];
    [labelTime setTextColor:[UIColor darkGrayColor]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    NSArray *times = [[data objectForKey:@"FlightLeaveTime"] componentsSeparatedByString:@","];
    [labelTime setText: times[0]];
    [cell addSubview:labelTime];
    [labelTime release];
    
    NSString *fromTo = [data objectForKey:@"FromTo"];
    ThreeCharCode *from = [_threeCodes objectForKey:[fromTo substringToIndex:3]];
    ThreeCharCode *to = [_threeCodes objectForKey:[fromTo substringFromIndex:3]];
    
    UILabel *labelFromTo = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 150, 24)];
    [labelFromTo setFont:[UIFont boldSystemFontOfSize:14]];
    [labelFromTo setBackgroundColor:[UIColor clearColor]];
    [labelFromTo setText:[NSString stringWithFormat:@"%@-%@",
                          from == nil ? @"未知":from.cityName,
                          to == nil ? @"未知":to.cityName]];
    [cell addSubview:labelFromTo];
    [labelFromTo release];
        
    UILabel *labelFlight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_RECT.size.width - 150, 0, 80, 44)];
    [labelFlight setFont:[UIFont systemFontOfSize:14]];
    [labelFlight setTextColor:[UIColor blackColor]];
    [labelFlight setText:[data objectForKey:@"Flight"]];
    [labelFlight setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:labelFlight];
    [labelFlight release];
    
    
    OrderState *state = [_orderStates objectForKey:[NSString stringWithFormat:@"%@", [data objectForKey:@"State"]]];
    UILabel *labelState = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_RECT.size.width - 70, 0, 60, 44)];
    [labelState setText:(state ? state.title: @"未知")];
    [labelState setNumberOfLines:0];
    [labelState setAdjustsFontSizeToFitWidth:YES];
    [labelState setLineBreakMode:UILineBreakModeWordWrap];
    [labelState setBackgroundColor:[UIColor clearColor]];
    [labelState setFont:[UIFont systemFontOfSize:10]];
    [labelState setTextColor:[UIColor blackColor]];
    [cell addSubview:labelState];
    [labelState release];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    UIBGNavigationController *nav = [[UIBGNavigationController alloc] initWithRootViewController: vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}
#pragma mark - Sort
- (void)sortByKey: (NSString *)key andASC:(BOOL)asc
{
    if(!_datas) return;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: key ascending:asc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSMutableArray *items = [_datas mutableCopy];
    [items sortUsingDescriptors:sortDescriptors];
    [_datas release];
    _datas = [items mutableCopy];
    [items release];    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
