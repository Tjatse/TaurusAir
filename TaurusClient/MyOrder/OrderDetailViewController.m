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
#import "NSDateAdditions.h"
#import "NSDictionaryAdditions.h"
#import "CRUDViewController.h"
#import "AppContext.h"
#import "OrderRefundViewController.h"
#import "AlixPayHelper.h"

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
    [_passengers release];
	[_voidPassengers release];
	self.payButtonTapBlock = nil;
	
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundComplete:) name:@"ORDER_REFUND" object:nil];
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
                                           [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ORDER_REFUND" object:nil];
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                       }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中...";
    _size = CGSizeZero;
    _status = OrderStatusOther;
    
    NSString *orderId = [NSString stringWithFormat:@"%d",[[_orderListItem objectForKey:@"Tid"] intValue]];
    [OrderHelper orderDetailWithId:orderId
                            user:[AppConfig get].currentUser
                           success:^(NSDictionary *order) {
                               _datas = [[NSArray alloc] initWithArray:@[@[@"订单状态",@"订单编号",@"预订日期"],@[@"航班信息"],@[@"航班信息"],@[@"登机人",@"联系人",@"配送"]]];
                               
                               _detail = [order mutableCopy];
                               NSString *flightInfo = [_detail objectForKey:@"Flight"];
                               int c = [[flightInfo componentsSeparatedByString:@"^"] count];
                               _hasReturn = c == 2;
                               
                               NSString *psg = [_detail objectForKey:@"Traveler"];
                               if(psg != nil && (NSNull *)psg != [NSNull null]){
                                   NSArray *ts = [psg componentsSeparatedByString:@"^"];
                                   
                                   [_passengers release], _passengers = nil;
                                   _passengers = [[NSMutableArray alloc] initWithCapacity:0];
                                   for(NSString *t in ts){
                                       NSArray *ps = [t componentsSeparatedByString:@"_"];
                                       if([ps count] == 3){
                                           [_passengers addObject:@{@"name":ps[0],@"type":ps[1],@"chinaId":ps[2]}];
                                       }
                                   }
                               }
                               NSString *voidPsgs = [_detail getStringValueForKey:@"VoidPassengers" defaultValue:nil];
                               if(voidPsgs != nil){
                                   _voidPassengers = [[NSMutableDictionary alloc] initWithCapacity:0];
                                   NSArray *vpsgs = [voidPsgs componentsSeparatedByString:@";"];
                                   for(NSString *ps in vpsgs){
                                       if(ps != nil && [ps length] > 0){
                                           NSArray *nfs = [ps componentsSeparatedByString:@":"];
                                           id existValue = [_voidPassengers objectForKey:nfs[0]];
                                           if(existValue != nil && (NSNull *)existValue != [NSNull null]){
                                               [_voidPassengers setValue:[NSString stringWithFormat:@"%@, %@",existValue,nfs[1]] forKey:nfs[0]];
                                           }else{
                                               [_voidPassengers setValue:nfs[1] forKey:nfs[0]];
                                           }
                                       }
                                   }
                               }
                               
                               NSString *sendAddress = [_detail getStringValueForKey:@"SendAddress" defaultValue:@""];
                               
                               CGSize textSize = {200,1000};
                               _size = [sendAddress sizeWithFont:[UIFont systemFontOfSize:14]
                                               constrainedToSize:textSize
                                                   lineBreakMode:UILineBreakModeWordWrap];
                               _size.height = _size.height+10;
                               if (_size.height < 44) {
                                   _size.height = 44;
                               }
                               
                               int orderType = [_detail getIntValueForKey:@"OrderType" defaultValue:-1];
                               int state = [_detail getIntValueForKey:@"State" defaultValue:-1];
                               
                               if(orderType == 1 && state == 1010){
                                   _status = OrderStatusPayAndCancel;
                               }else if(orderType == 1 && (state == 1200 || state == 1210 || state == 1260)){
                                   _status = OrderStatusRollback;
                               }else{
                                   _status = OrderStatusOther;
                               }
                               
                               [self initComponents];
                               [_tableView reloadData];
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                           failure:^(NSString *errorMsg) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                           }];
}
- (void)refundComplete: (NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ORDER_REFUND" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_REFRESH" object:nil userInfo:[NSDictionary dictionaryWithObject:@"退票已完成。" forKey:@"MSG"]];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Init components
- (void)initComponents
{
    if(_status != OrderStatusPayAndCancel){
        [_viewBottom setHidden:YES];
        CGRect f = _tableView.frame;
        f.size.height = f.size.height + 36;
        [_tableView setFrame:f];
        return;
    }
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
    
    UIButton *buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPlay setFrame:CGRectMake(SCREEN_RECT.size.width - 80, 0, 80, 36)];
    [buttonPlay setTitle:@"支付" forState:UIControlStateNormal];
    [buttonPlay.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonPlay.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonPlay setShowsTouchWhenHighlighted:YES];
    [buttonPlay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [_viewBottom addSubview:buttonPlay];
}
#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 || (_hasReturn && indexPath.section == 2)){
        return 182;
    }
    else if(((_hasReturn && indexPath.section == 3) || (!_hasReturn && indexPath.section == 2)) && indexPath.row == 0){
        if(_passengers == nil || [_passengers count] == 0){
            return 44;
        }else{
            return 44 * [_passengers count];
        }
    }else if(((_hasReturn && indexPath.section == 3) || (!_hasReturn && indexPath.section == 2)) && indexPath.row == 2){
        return _size.height < 44 ? 44: _size.height;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int index = section;
    if(!_hasReturn && section == 2){
        index ++;
    }else if((_hasReturn && section == 4) || (!_hasReturn && section == 3)){
        return 0;
    }
    return [_datas[index] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int c = [_datas count] - (_hasReturn ? 0 : 1);
    return (c < 0 ? 0:c) + (_status != OrderStatusOther ? 1:0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    
    if((_hasReturn && section == 4) || (!_hasReturn && section == 3)){
        return 54;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        if(indexPath.section == 1 || (_hasReturn && indexPath.section == 2)){
            cell = [[NSBundle mainBundle] loadNibNamed:@"PrepareOrderCells" owner:nil options:nil][0];
        }else{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify]
                autorelease];
        }
    }
    [cell setNeedsDisplay];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    if(indexPath.section == 1 || (_hasReturn && indexPath.section == 2)){
        cell.clipsToBounds = YES;
        [self parseFlightInfoCell:cell andIndexPath:indexPath];
    }else{
        
        int index = indexPath.section;
        if(!_hasReturn && index == 2){
            index ++;
        }

        int r = indexPath.row;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setText:_datas[index][r]];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        
        if (index == 0) {
            switch (r) {
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
        }else if(index == 3){
            switch (indexPath.row) {
                case 0:{
                    int l = 0;
                    if(_passengers == nil || (l = [_passengers count]) == 0){
                        [cell.detailTextLabel setText:@"-"];
                    }else{
                        int offset = 0;
                        UIImage *lineImg = [UIImage imageNamed:@"gray-point.png"];
                        for(NSDictionary *p in _passengers){
                            UIView *ctn = [[UIView alloc] initWithFrame:CGRectMake(100, offset * 44, 210, 44)];
                            
                            int t = [[p objectForKey:@"type"] intValue];
                            NSString *tn = @"成人";
                            if(t == 2){
                                tn = @"儿童";
                            }
                            NSString *name = [p objectForKey:@"name"];
                            UILabel *labelName = [self generateLabel:CGRectMake(0, 0, 100, 26)
                                                        withFontSize:14
                                                            andColor:cell.detailTextLabel.textColor];
                            [labelName setText:[NSString stringWithFormat:@"%@, %@", name, tn]];
                            [ctn addSubview:labelName];
                                                        
                            UILabel *labelChinaId = [self generateLabel:CGRectMake(0, 20, 200, 24)
                                                        withFontSize:12
                                                            andColor:cell.detailTextLabel.textColor];
                            [labelChinaId setText:[p objectForKey:@"chinaId"]];
                            [ctn addSubview:labelChinaId];
                            
                            if(_voidPassengers != nil && [_voidPassengers count] > 0){
                                NSString *flts = [_voidPassengers objectForKey:name];
                                if(flts != nil && (NSNull *)flts != [NSNull null] && [flts length] > 0){
                                    UILabel *labelRefund = [self generateLabel:CGRectMake(ctn.frame.size.width - 70, 0, 70, 44) withFontSize:10 andColor:[UIColor redColor]];
                                    NSString *fmt = [[_detail objectForKey:@"State"] intValue] == 1560 ? @"已退废：\n%@":@"正在退票中：\n%@";
                                    labelRefund.text = [NSString stringWithFormat:fmt, flts];
                                    [labelRefund setNumberOfLines:0];
                                    [ctn addSubview:labelRefund];
                                }
                            }
                            
                            if(offset != l - 1){
                                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ctn.frame.size.height - 1, ctn.frame.size.width, 1)];
                                [imgView setImage:[lineImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
                                [ctn addSubview:imgView];
                                [imgView release];
                            }
                            
                            [cell addSubview:ctn];
                            [ctn release];
                            offset++;
                        }
                    }
                }
                    break;
                case 1:{
                    _contactorPhone = [[_detail getStringValueForKey:@"ContactorPhone" defaultValue:@""] retain];
                    NSString *cn = [_detail getStringValueForKey:@"ContactorName" defaultValue:@""];
                    
                    UIView *ctn = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 210, 44)];
                    
                    UILabel *labelName = [self generateLabel:CGRectMake(0, 0, 100, 26)
                                                withFontSize:14
                                                    andColor:cell.detailTextLabel.textColor];
                    [labelName setText:cn];
                    [ctn addSubview:labelName];
                    
                    UILabel *labelPhone = [self generateLabel:CGRectMake(0, 20, 200, 24)
                                                   withFontSize:12
                                                       andColor:cell.detailTextLabel.textColor];
                    [labelPhone setText:_contactorPhone];
                    [ctn addSubview:labelPhone];
                    
                    [cell addSubview:ctn];
                    [ctn release];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                    break;
                case 2:{
                    UILabel *labelAddr = [self generateLabel:CGRectMake(100, 0, 200, _size.height)
                                                withFontSize:14
                                                    andColor:cell.detailTextLabel.textColor];
                    [labelAddr setNumberOfLines:0];
                    [labelAddr setLineBreakMode:UILineBreakModeWordWrap];
                    NSString *address = [_detail objectForKey:@"SendAddress"];
                    [labelAddr setText:(NSNull *)address == [NSNull null] ? @"-":address];
                    [cell addSubview:labelAddr];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    return cell;
}

- (UILabel *)generateLabel: (CGRect)frame
              withFontSize: (float)fontSize
                  andColor: (UIColor *)color
{
    UILabel *labelTime = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [labelTime setFont:[UIFont systemFontOfSize:fontSize]];
    [labelTime setTextColor:color];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    return labelTime;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if((!_hasReturn && indexPath.section == 2) || (_hasReturn && indexPath.section == 3)){
        if(indexPath.row == 1 && _contactorPhone && [_contactorPhone length] > 0){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat: @"拨打 %@", _contactorPhone] otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
            [sheet release];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if((_hasReturn && section == 4) || (!_hasReturn && section == 3)){
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 64)] autorelease];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
        NSString *title = @"取消订单";
        if(_status == OrderStatusPayAndCancel){
            title = @"取消订单";
        }else if(_status == OrderStatusRollback){
            title = @"申请退票";
        }
        [button setTitle: title forState:UIControlStateNormal];
        CGFloat x = (tableView.frame.size.width - 278)/2;
        [button setFrame:CGRectMake(x, 5, 278, 45)];
        [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}
#pragma mark - Flight Information

- (void)parseFlightInfoCell:(UITableViewCell*)cell andIndexPath: (NSIndexPath *)indexPath
{
    if(_detail == nil || (NSNull *)_detail == [NSNull null] || [_detail count] == 0){
        return;
    }
    NSArray *flights = [[_detail objectForKey:@"Flight"] componentsSeparatedByString:@"^"];
    NSString *flight = [flights objectAtIndex:indexPath.section - 1];
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
	NSString* airportTower = fs[7];
	NSString* fromAirportTower = [airportTower substringToIndex:[airportTower rangeOfString:@" "].location];
	NSString* toAirportTower = [airportTower substringFromIndex:[airportTower rangeOfString:@" "].location];
	NSString* fromAirportFullName = [NSString stringWithFormat:@"%@ %@"
									 , fromTCC.airportAbbrName
									 , fromAirportTower];
	NSString* toAirportFullName = [NSString stringWithFormat:@"%@ %@"
								   , toTCC.airportAbbrName
								   , toAirportTower];
    
    _flight = [@[corp, flt, pos, from, start, to, end] retain];
	
	UIImageView* bgImgVw = (UIImageView*)[cell viewWithTag:99];
	UILabel* dateLabel = (UILabel*)[cell viewWithTag:102];
	UILabel* twoCharLabel = (UILabel*)[cell viewWithTag:103];
	UILabel* purePriceLabel = (UILabel*)[cell viewWithTag:104];
	UILabel* otherPriceLabel = (UILabel*)[cell viewWithTag:105];
	UILabel* durationTimeLabel = (UILabel*)[cell viewWithTag:106];
	UILabel* departureAirportLabel = (UILabel*)[cell viewWithTag:107];
	UILabel* arrivalAirportLabel = (UILabel*)[cell viewWithTag:108];
	UIButton* viewAirplaneDetailBtn = (UIButton*)[cell viewWithTag:109];
	UIButton* viewReturnTicketDetailBtn = (UIButton*)[cell viewWithTag:110];
	
    UIImage *ghImg = [UIImage imageNamed:@"group-header.png"];
    [bgImgVw setFrame:CGRectMake(0, 0, 300, 63)];
    [bgImgVw setImage:[ghImg stretchableImageWithLeftCapWidth:50 topCapHeight:5]];
    
    
    if(indexPath.section == 2){
        // departureOrReturnImgVw
        UIImageView* departureOrReturnImgVw = (UIImageView*)[cell viewWithTag:100];
        UILabel* departureOrReturnLabel = (UILabel*)[cell viewWithTag:101];
        departureOrReturnImgVw.image = [UIImage imageNamed:@"order_return_btn_bg.png"];
        departureOrReturnLabel.text = @"返程";
    }
	
	// twoCharLabel
	twoCharLabel.text = [NSString stringWithFormat:@"%@%@", corp, flt];
    
	// purePriceLabel
	int purePrice = [_detail getFloatValueForKey:@"Fare" defaultValue:0];
	
	purePriceLabel.text = [NSString stringWithFormat:@"￥%d", purePrice];
	
	// otherPrice
	int airportPrice = [_detail getFloatValueForKey:@"Airport" defaultValue:0];
	int fuelPrice = [_detail getFloatValueForKey:@"Fuel" defaultValue:0];
	
	otherPriceLabel.text = [NSString stringWithFormat:@"￥%d/%d", airportPrice, fuelPrice];
	
	// durationTimeLabel
    NSArray *startDates = [start componentsSeparatedByString:@" "];
    NSArray *endDates = [end componentsSeparatedByString:@" "];
	durationTimeLabel.text = [NSString stringWithFormat:@"%@     -       %@"
							  , [startDates objectAtIndex:[startDates count] - 1]
							  , [endDates objectAtIndex:[endDates count] - 1]];
    
    dateLabel.text = [startDates objectAtIndex:0];
	
	// departureAirportLabel
	departureAirportLabel.text = fromAirportFullName;
	
	// arrivalAirportLabel
	arrivalAirportLabel.text = toAirportFullName;
	
	// viewAirplaneDetailBtn
	[viewAirplaneDetailBtn
	 addActionForControlEvents:UIControlEventTouchUpInside
	 withBlock:^(id control, UIEvent *event) {
         OrderFlightDetailViewController *vc = [[OrderFlightDetailViewController alloc] init];
         vc.detail = _flight;
         vc.showHomeButton = YES;
         [self.navigationController pushViewController:vc animated:YES];
         [vc release];
	 }];
	
	// viewReturnTicketDetailBtn
	[viewReturnTicketDetailBtn
	 addActionForControlEvents:UIControlEventTouchUpInside
	 withBlock:^(id control, UIEvent *event) {
         CRUDViewController *vc = [[CRUDViewController alloc] init];
         vc.cabin = pos;
         vc.ezm = fs[0];
         [self.navigationController pushViewController:vc animated:YES];
         [vc release];

	 }];
}
- (void)cancel:(UIButton *)button{
    if(_status == OrderStatusRollback){
        OrderRefundViewController *vc = [[OrderRefundViewController alloc] init];
        [vc setDetail:_detail];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"关        闭" destructiveButtonTitle: button.titleLabel.text otherButtonTitles:nil, nil];
        actionSheet.tag = 100;
        [actionSheet showFromTabBar:[AppContext get].navController.tabBar];
        [actionSheet release];
    }
}

- (void)pay:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"关        闭" destructiveButtonTitle: @"支付订单" otherButtonTitles:nil, nil];
    actionSheet.tag = 101;
    [actionSheet showFromTabBar:[AppContext get].navController.tabBar];
    [actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        if(actionSheet.tag == 100){
            if(_status == OrderStatusPayAndCancel){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.dimBackground = YES;
                // cancel ticket.
                hud.labelText = @"取消中...";
                [OrderHelper cancelWithId:[_detail getStringValueForKey:@"Tid" defaultValue:@""]
                                     user:[AppConfig get].currentUser
                                  success:^() {
                                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_REFRESH" object:nil userInfo:[NSDictionary dictionaryWithObject:@"订单已取消。" forKey:@"MSG"]];
                                      [self.navigationController dismissModalViewControllerAnimated:YES];
                                  }
                                  failure:^(NSString *errorMsg) {
                                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                      [ALToastView toastInView:self.view withText:errorMsg andBottomOffset:44 andType:ERROR];
                                  }];
            }
        }else if(actionSheet.tag == 101){
//            // TODO: Play
            NSLog(@"%@", _detail);
			
			if (self.payButtonTapBlock != nil)
				self.payButtonTapBlock();
			else {
				NSString* travelerStr = _detail[@"Traveler"];
				NSArray* travelers = [travelerStr componentsSeparatedByString:@"^"];
				NSMutableDictionary* passangers = [NSMutableDictionary dictionary];
				
				for (NSString* traveler in travelers) {
					NSArray* travelerDetails = [traveler componentsSeparatedByString:@"_"];
					NSString* travelerName = travelerDetails[0];
					
					[passangers setValue:[NSDictionary dictionaryWithObjectsAndKeys:travelerName, @"Name", nil]
								  forKey:travelerName];
				}
				
				[AlixPayHelper performAlixPayWithOrderId:[_detail getStringValueForKey:@"Tid" defaultValue:@""]
										  andProductName:@"机票"
										  andProductDesc:@"机票"
										 andProductPrice:[[_detail objectForKey:@"OrderPrice"] floatValue]
										   andPassangers:passangers
											andContactor:nil
						   andFlightSelectViewController:nil
										  andOrderDetail:_detail];
			}
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _contactorPhone]]];
        }
    }
}
@end
