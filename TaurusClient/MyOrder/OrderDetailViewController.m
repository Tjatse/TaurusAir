//
//  OrderDetailViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "AppDefines.h"
#import "BBlock.h"
#import "CharCodeHelper.h"
#import "OrderState.h"
#import "TwoCharCode.h"
#import "ThreeCharCode.h"
#import "OrderFlightDetailViewController.h"
#import "UIBGNavigationController.h"
#import "MBProgressHUD.h"
#import "OrderHelper.h"
#import "AppConfig.h"
#import "ALToastView.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController
@synthesize tableView = _tableView;
@synthesize viewBottom = _viewBottom;
@synthesize orderListItem = _orderListItem;

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
    [_viewBottom release];
    [_orderStates release];
    [_threeCodes release];
    [_twoCodes release];
    [_flight release];
    [_contactorPhone release];
    [_orderListItem release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"订单详情"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _threeCodes = [[CharCodeHelper allThreeCharCodesDictionary] retain];
    _twoCodes = [[CharCodeHelper allTwoCharCodesDictionary] retain];
    _orderStates = [[NSDictionary alloc] initWithDictionary:[CharCodeHelper allOrderStates]];
    
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_viewBottom setFrame:CGRectMake(0, SCREEN_RECT.size.height - STATUSBAR_FRAME.size.height - NAVBAR_HEIGHT - 36, SCREEN_RECT.size.width, 36)];
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中...";
    NSString *orderId = [NSString stringWithFormat:@"%d",[[_orderListItem objectForKey:@"OrderId"] intValue]];
    [OrderHelper orderDetailWithId:orderId
                            userId:[AppConfig get].currentUser.userId
                           success:^(NSDictionary *order) {
                               _datas = [[NSArray alloc] initWithArray:@[@[@"订单状态",@"订单编号",@"预订日期"],@[@"航班信息"],@[@"登机人",@"联系人",@"配送"]]];
                               
                               _detail = [order mutableCopy];
                               
                               [self initComponents];
                               [_tableView reloadData];
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                           failure:^(NSString *errorMsg) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                           }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Init components
- (void)initComponents
{   
    UILabel *labelPriceInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 36)];
    [labelPriceInfo setText:@"订单金额："];
    [labelPriceInfo setTextColor:[UIColor whiteColor]];
    [labelPriceInfo setBackgroundColor:[UIColor clearColor]];
    [labelPriceInfo setFont:[UIFont systemFontOfSize:14]];
    [labelPriceInfo setTextAlignment:UITextAlignmentRight];
    [_viewBottom addSubview:labelPriceInfo];
    [labelPriceInfo release];
    
    UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 36)];
    [labelPrice setText:[NSString stringWithFormat:@"￥%@", [_detail objectForKey:@"OrderPrice"]]];
    [labelPrice setTextColor:UIColorFromRGB(0xf36400)];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [labelPrice setFont:[UIFont systemFontOfSize:18]];
    [_viewBottom addSubview:labelPrice];
    [labelPrice release];
    
    UIImage *imageLine = [UIImage imageNamed:@"gray-point.png"];
    UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_RECT.size.width - 80, 1, 1, 34)];
    [imageViewLine setImage:[imageLine stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [_viewBottom addSubview:imageViewLine];
    [imageViewLine release];
    
    NSNumber *state = [_detail objectForKey:@"State"];
    if([state isEqualToNumber:[NSNumber numberWithInt:1200]] ||
       [state isEqualToNumber:[NSNumber numberWithInt:1210]] ||
       [state isEqualToNumber:[NSNumber numberWithInt:1260]]){
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCancel setFrame:CGRectMake(SCREEN_RECT.size.width - 80, 0, 80, 36)];
        [buttonCancel setTitle:@"申请退票" forState:UIControlStateNormal];
        [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCancel.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonCancel setShowsTouchWhenHighlighted:YES];
        [buttonCancel addTarget:self action:@selector(cancelTicket:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBottom addSubview:buttonCancel];
    }else{
        UILabel *labelCancel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_RECT.size.width - 80, 0, 80, 36)];
        [labelCancel setText:@"申请退票"];
        [labelCancel setTextAlignment:UITextAlignmentCenter];
        [labelCancel setTextColor:[UIColor grayColor]];
        [labelCancel setBackgroundColor:[UIColor clearColor]];
        [labelCancel setFont:[UIFont systemFontOfSize:14]];
        [_viewBottom addSubview:labelCancel];
        [labelCancel release];
    }
}
- (void)cancelTicket:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的订单将被取消，确定继续？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}
// TODO: cancel order.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSLog(@"%d", buttonIndex);
    }
}
#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setText:_datas[indexPath.section][indexPath.row]];
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    OrderState *state = [_orderStates objectForKey:[[_detail objectForKey:@"State"] stringValue]];
                    [cell.detailTextLabel setText:(state?state.title:@"未知")];
                }
                    break;
                case 1:{
                    [cell.detailTextLabel setText:[[_detail objectForKey:@"Tid"] stringValue]];
                }
                    break;
                case 2:{
                    [cell.detailTextLabel setText:[_detail objectForKey:@"BookTime"]];
                }
                    break;
                default:
                    break;
            }
        }    
            break;
        case 1:{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSString *flight = [_detail objectForKey:@"Flight"];
            NSArray *fs = [flight componentsSeparatedByString:@"_"];
            TwoCharCode *tcc = [_twoCodes objectForKey:fs[0]];
            NSString *corp = tcc ? tcc.corpAbbrName:@"";
            NSString *flt = fs[1];
            NSString *pos = fs[2];
            ThreeCharCode *fromTCC = [_threeCodes objectForKey:fs[3]];
            NSString *from = fromTCC ? fromTCC.cityName:@"";
            NSString *start = fs[4];
            ThreeCharCode *toTCC = [_threeCodes objectForKey:fs[5]];
            NSString *to = toTCC ? toTCC.cityName:@"";
            NSString *end = fs[6];
            
            _flight = [@[corp, flt, pos, from, start, to, end] retain];
            
            [cell.detailTextLabel setText: [NSString stringWithFormat:@"%@ %@", corp, fs[1]]];
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    [cell.detailTextLabel setText:[_detail objectForKey:@"Traveler"]];
                }
                    break;
                case 1:{
                    _contactorPhone = [[_detail objectForKey:@"ContactorPhone"] retain];
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@(%@)",
                                                   [_detail objectForKey:@"ContactorName"],
                                                   _contactorPhone]];
                    if(_contactorPhone){
                        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                    }
                }
                    break;
                case 2:{
                    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
                    [cell.detailTextLabel setNumberOfLines:0];
                    [cell.detailTextLabel setText:[_detail objectForKey:@"SendAddress"]];
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){
        OrderFlightDetailViewController *vc = [[OrderFlightDetailViewController alloc] init];
        vc.detail = _flight;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else if(indexPath.section == 2){
        if(indexPath.row == 1 && _contactorPhone){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat: @"拨打 %@", _contactorPhone] otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            [sheet release];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _contactorPhone]]];
    }
}

@end
