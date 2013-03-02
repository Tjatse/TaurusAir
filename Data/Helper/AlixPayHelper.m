//
//  AlixPayHelper.m
//  TaurusClient
//
//  Created by Simon on 13-2-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "NSDictionaryAdditions.h"
#import "NSDateAdditions.h"

#import "AlixPayHelper.h"
#import "AlixPayOrder.h"
#import "AppDefines.h"
#import "DataSigner.h"
#import "AlixPay.h"
#import "FlightSelectViewController.h"
#import "TicketOrderHelper.h"
#import "CharCodeHelper.h"
#import "ThreeCharCode.h"
#import "TwoCharCode.h"
#import "TicketOrder.h"

static NSString*						gOrderIdStr;
static FlightSelectViewController*		gVC;
static NSDictionary*					gPassangers;
static NSDictionary*					gContactor;
static NSDictionary*					gOrderDetail;

@implementation AlixPayHelper

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
+ (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

+ (void)performAlixPayWithOrderId:(NSString*)orderId
				   andProductName:(NSString*)productName
				   andProductDesc:(NSString*)productDesc
				  andProductPrice:(float)productPrice
					andPassangers:(NSDictionary*)passangers
					 andContactor:(NSDictionary*)contactor
	andFlightSelectViewController:(FlightSelectViewController*)vc
				   andOrderDetail:(NSDictionary*)orderDetail
{
	SAFE_RELEASE(gOrderIdStr);
	gOrderIdStr = [orderId retain];
	gVC = vc;
	
	SAFE_RELEASE(gPassangers);
	gPassangers = [passangers retain];
	
	SAFE_RELEASE(gContactor);
	gContactor = [contactor retain];
	
	SAFE_RELEASE(gOrderDetail);
	gOrderDetail = [orderDetail retain];
	
	// FIXME: productPrice
	productPrice = 0.01f;
	
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
	 */
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[[AlixPayOrder alloc] init] autorelease];
	order.partner = kAlixPayPartnerId;
	order.seller = kAlixPaySellerId;
	order.tradeNO = [self generateTradeNO]; //orderId; //订单ID（由商家自行制定）
	order.productName = productName; //商品标题
	order.productDescription = productDesc; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f", productPrice]; //商品价格
	order.notifyURL =  @"http://www.5pnr.com/pay/AliPay/Return.aspx"; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"TaurusClient";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(kAlixPayRSASafeCode);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
					   orderSpec, signedString, @"RSA"];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
	}
}

+ (void)alixPayCallback:(BOOL)success
{
	if (success) {
		if (gVC != nil) {
			[self processAlixPayCallbackWithVC:gVC];
			
			if (gVC.viewType == kFlightSelectViewTypeReturn) {
				[self processAlixPayCallbackWithVC:gVC.parentVC];
			}
		} else if (gOrderDetail != nil) {
			[self processAlixPayCallbackWithOrderDetail:gOrderDetail];
		}
	}
}

+ (void)processAlixPayCallbackWithOrderDetail:(NSDictionary*)dic
{
	NSString* flight = [dic getStringValueForKey:@"Flight" defaultValue:nil];
	NSArray* flights = [flight componentsSeparatedByString:@"_"];
	
	// from to
	NSDictionary* threeCodes = [CharCodeHelper allThreeCharCodesDictionary];
	
	NSString *fromStr = flights[3];
	NSString* toStr = flights[5];
    ThreeCharCode *from = [threeCodes objectForKey:fromStr];
    ThreeCharCode *to = [threeCodes objectForKey:toStr];
	NSString* airportTower = @""; //[flightInfo getStringValueForKey:@"AirportTower" defaultValue:@""];
	NSString* fromAirportTower = @""; //[airportTower substringToIndex:[airportTower rangeOfString:@" "].location];
	NSString* toAirportTower = @""; //[airportTower substringFromIndex:[airportTower rangeOfString:@" "].location];
	NSString* fromAirportFullName = [NSString stringWithFormat:@"%@ %@"
									 , from.airportAbbrName
									 , fromAirportTower];
	
	NSString* toAirportFullName = [NSString stringWithFormat:@"%@ %@"
								   , to.airportAbbrName
								   , toAirportTower];
	
	// customerName
	NSMutableString* customerName = [NSMutableString string];
	NSArray* allPassangers = [gPassangers allValues];
	for (NSDictionary* passanger in allPassangers) {
		if (customerName.length > 0)
			[customerName appendString:@" "];
		
		[customerName appendString:passanger[@"Name"]];
	}
	
	// departure time
	NSDate* leaveTime = flights[4]; // [NSDate dateFromString:[flightInfo getStringValueForKey:@"LeaveTime" defaultValue:@""]];
	NSString* flightNumStr = flights[1]; // [flightInfo getStringValueForKey:@"FlightNum" defaultValue:@""];
	
	TicketOrder* ticketOrder = [[TicketOrder alloc] initWithFromCityFullName:fromAirportFullName
															  toCityFullName:toAirportFullName
																customerName:customerName
															   departureTime:leaveTime
																flightNumber:flightNumStr
																	 orderId:gOrderIdStr];
	
	[[TicketOrderHelper sharedHelper] pushTicketOrder:ticketOrder];
	SAFE_RELEASE(ticketOrder);
	
	// 发送通知
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_REFRESH" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ALIXPAY_CALLBACK_SUCCESS" object:nil];
}

+ (void)processAlixPayCallbackWithVC:(FlightSelectViewController*)vc
{
//	@synthesize fromCity;
//	@synthesize toCity;
//	@synthesize customerName;
//	@synthesize departureTime;
//	@synthesize flightNumber;
//	@synthesize orderId;
	
	NSDictionary* flightInfo = vc.selectedPayInfos[0];
//	NSDictionary* cabinInfo = vc.selectedPayInfos[1];

	// from to
	NSDictionary* threeCodes = [CharCodeHelper allThreeCharCodesDictionary];
	
	NSString *fromTo = [flightInfo getStringValueForKey:@"FromTo" defaultValue:@""];
    ThreeCharCode *from = [threeCodes objectForKey:[fromTo substringToIndex:3]];
    ThreeCharCode *to = [threeCodes objectForKey:[fromTo substringFromIndex:3]];
	NSString* airportTower = [flightInfo getStringValueForKey:@"AirportTower" defaultValue:@""];
	NSString* fromAirportTower = [airportTower substringToIndex:[airportTower rangeOfString:@" "].location];
	NSString* toAirportTower = [airportTower substringFromIndex:[airportTower rangeOfString:@" "].location];
	NSString* fromAirportFullName = [NSString stringWithFormat:@"%@ %@"
									 , from.airportAbbrName
									 , fromAirportTower];

	NSString* toAirportFullName = [NSString stringWithFormat:@"%@ %@"
								   , to.airportAbbrName
								   , toAirportTower];

	// customerName
	NSMutableString* customerName = [NSMutableString string];
	NSArray* allPassangers = [gPassangers allValues];
	for (NSDictionary* passanger in allPassangers) {
		if (customerName.length > 0)
			[customerName appendString:@" "];
		
		[customerName appendString:passanger[@"Name"]];
	}
	
	// departure time
	NSDate* leaveTime = [NSDate dateFromString:[flightInfo getStringValueForKey:@"LeaveTime" defaultValue:@""]];
	NSString* flightNumStr = [flightInfo getStringValueForKey:@"FlightNum" defaultValue:@""];

	TicketOrder* ticketOrder = [[TicketOrder alloc] initWithFromCityFullName:fromAirportFullName
															  toCityFullName:toAirportFullName
																customerName:customerName
															   departureTime:leaveTime
																flightNumber:flightNumStr
																	 orderId:gOrderIdStr];
		
	[[TicketOrderHelper sharedHelper] pushTicketOrder:ticketOrder];
	SAFE_RELEASE(ticketOrder);
	
	// 发送通知
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_REFRESH" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ALIXPAY_CALLBACK_SUCCESS" object:nil];
}

@end
