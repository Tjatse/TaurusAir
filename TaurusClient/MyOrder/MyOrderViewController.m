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
#import "OrderHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#define TAG_SORT_TIME   100
#define TAG_SORT_PRICE  101
#define TAG_FILTER      102

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController
@synthesize buttonFilter, buttonSortPrice, buttonSortTime;
@synthesize datas = _datas;
@synthesize clonedDatas = _clonedDatas;
@synthesize sortImageView = _sortImageView;

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
    [_sortImageView release];
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
        [ALToastView toastPinInView:self.view withText:@"登录后才能访问“订单管理”。" andBottomOffset: 120 andType: ERROR];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中...";
    [OrderHelper orderListWithUser:[AppConfig get].currentUser
                           success:^(NSArray *orders) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [self renderViews:orders];
                           }
                           failure:^(NSString *errorMsg) {
                               [self setRightButton:NO];
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                           }];
}

- (void)renderViews:(NSArray *)orders
{
    _datas = [orders mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterOrder:) name:@"ORDER_FILTER" object:nil];
    _orderStates = [[NSDictionary alloc] initWithDictionary:[CharCodeHelper allOrderStates]];
    _threeCodes = [[NSDictionary alloc] initWithDictionary:[CharCodeHelper allThreeCharCodesDictionary]];
    
    [self setRightButton: NO];
    
    NSArray *subViews = [self.view subviews];
    if(subViews && [subViews count] > 0){
        for(UIView *v in subViews){
            [v removeFromSuperview];
        }
    }
    
    buttonSortTime = [[self generateSortButton:CGRectMake(10, 5, 87, 31)
                                         title:@"时间"
                                     highlight:NO
                                      needSort:YES
                                           tag:TAG_SORT_TIME] retain];
    [self.view addSubview:buttonSortTime];
    
    buttonSortPrice = [[self generateSortButton:CGRectMake((SCREEN_RECT.size.width - 87)/2, 5, 87, 31)
                                          title:@"航班"
                                      highlight:NO
                                       needSort:YES
                                            tag:TAG_SORT_PRICE] retain];
    [self.view addSubview:buttonSortPrice];
    
    buttonFilter = [[self generateSortButton:CGRectMake(SCREEN_RECT.size.width - 96, 5, 87, 31)
                                       title:@"筛选"
                                   highlight:NO
                                    needSort:NO
                                         tag:TAG_FILTER] retain];
    [self.view addSubview:buttonFilter];
    
    _sortImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_icon.png"]];
    [_sortImageView setFrame:CGRectMake(80, 14, 8, 11)];
    [self.view addSubview:_sortImageView];
    [self.view bringSubviewToFront:_sortImageView];
    
    _clonedDatas = [_datas mutableCopy];
    
    // init tableview.
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 40, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:YES];
    [self.view addSubview:_tableView];
    
    _asc = true;
    [self sortEvent:buttonSortTime];
}
#pragma mark Refresh
- (void)setRightButton: (BOOL)refreshing{
    if(!refreshing){
        [self.navigationItem setRightBarButtonItem:nil];
        self.navigationItem.rightBarButtonItem =
        [UIBarButtonItem generateNormalStyleButtonWithTitle:@"刷新"
                                             andTapCallback:^(id control, UIEvent *event) {
                                                 [self refresh];
                                             }];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 61, 30)];
        [imageView setImage:[UIImage imageNamed:@"t_btn_right.png"]];
        
        UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [ind setFrame:CGRectMake(20, 5, 20, 20)];
        [imageView addSubview:ind];
        self.navigationItem.rightBarButtonItem.customView = imageView;
        [ind startAnimating];
        [ind release];
        [imageView release];
    }
}
- (void)refresh
{
    [self setRightButton:YES];
    
    [OrderHelper orderListWithUser:[AppConfig get].currentUser
                           success:^(NSArray *orders) {
                               [_datas release], _datas = nil;
                               _datas = [orders mutableCopy];
                               [_clonedDatas release], _clonedDatas = nil;
                               _clonedDatas = [_datas mutableCopy];
                             
                               [self filterOrder:[NSNotification notificationWithName:@"ORDER_FILTER" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"selectedRow"]]];
                             
                               [_tableView reloadData];
                               [self setRightButton:NO];
                           }
                           failure:^(NSString *errorMsg) {
                               [self setRightButton:NO];
                               [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                           }];
}
#pragma mark Filter
- (void)setButtonState: (UIButton *)button andState:(BOOL)selected
{
    [button setBackgroundImage:[UIImage imageNamed:(selected ? @"sort_btn_focus_bg.png":@"sort_btn_bg.png")] forState:UIControlStateNormal];
    if(button == buttonSortTime && selected){
        [_sortImageView setFrame:CGRectMake(80, 14, 8, 11)];
    }else if(button == buttonSortPrice && selected){
        [_sortImageView setFrame:CGRectMake((SCREEN_RECT.size.width - 86)/2 + 70, 14, 8, 11)];
    }else if(button == buttonFilter && selected){
        return;
    }
    
    CATransform3D trans1 = CATransform3DMakeRotation(0, 0, 0, 1);
    CATransform3D trans2 = CATransform3DMakeRotation(1.0 * M_PI, 0, 0, 1);
    
    CABasicAnimation* rotateAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotateAni.removedOnCompletion = YES;
    rotateAni.fromValue = [NSValue valueWithCATransform3D:!_asc ? trans1 : trans2];
    rotateAni.toValue = [NSValue valueWithCATransform3D:_asc ? trans1 : trans2];
    
    _sortImageView.layer.transform = _asc ? trans1 : trans2;
    [_sortImageView.layer addAnimation:rotateAni forKey:nil];
}
- (void)filterOrder: (NSNotification *)notification
{
    _selectedRow = [[[notification userInfo] objectForKey:@"selectedRow"] intValue];
    if(_sort == PRICE){
        [self setButtonState:buttonSortPrice andState:NO];
    }
    else if(_sort == TIME){
        [self setButtonState:buttonSortTime andState:NO];
    }
    _asc = NO;
    
    _sort = TIME;
    [self setButtonState:buttonFilter andState:YES];
    [self setButtonState:buttonSortTime andState:YES];
    NSPredicate *predicate = nil;
    switch (_selectedRow) {
        case 0: // 全部
            [self setButtonState:buttonFilter andState:NO];
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
    [self sortByKey:@"FlightLeaveTime" andASC:_asc];
    [_tableView reloadData];
    if([_datas count] == 0){
        [ALToastView toastInView:self.view withText:@"没有符合筛选条件的订单信息。" andBottomOffset: 40 andType:ERROR];
    }
}
#pragma mark Generate Buttons
- (UIButton *)generateSortButton: (CGRect)frame
                           title: (NSString *)title
                       highlight: (BOOL)highlight
                        needSort: (BOOL)needSort
                             tag: (int)tag
{
    UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:[UIImage imageNamed:(highlight ? @"sort_btn_focus_bg.png":@"sort_btn_bg.png")] forState:UIControlStateNormal];
    [_button setFrame:frame];
    [_button setTitle:title forState:UIControlStateNormal];
    
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
                [self setButtonState:buttonSortPrice andState:NO];
            }
            _sort = TIME;
            _asc = !_asc;
            
            [self setButtonState:buttonSortTime andState:YES];
            [self sortByKey:@"FlightLeaveTime" andASC:_asc];
            [_tableView reloadData];
        }
            break;
        case TAG_SORT_PRICE:{
            if(_sort == TIME){
                [self setButtonState:buttonSortTime andState:NO];
            }
            _sort = PRICE;
            _asc = !_asc;
            [self setButtonState:buttonSortPrice andState:YES];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    [vc setOrderListItem: [_datas objectAtIndex:indexPath.row]];
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
