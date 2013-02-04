//
//  AlixPayHelper.m
//  TaurusClient
//
//  Created by Simon on 13-2-4.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "AlixPayHelper.h"
#import "AlixPayOrder.h"
#import "AppDefines.h"
#import "DataSigner.h"
#import "AlixPay.h"

@implementation AlixPayHelper

+ (void)performAlixPayWithOrderId:(NSString*)orderId
				   andProductName:(NSString*)productName
				   andProductDesc:(NSString*)productDesc
				  andProductPrice:(float)productPrice
{
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
	 */
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = kAlixPayPartnerId;
	order.seller = kAlixPaySellerId;
	order.tradeNO = orderId; //订单ID（由商家自行制定）
	order.productName = productName; //商品标题
	order.productDescription = productDesc; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f", productPrice]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"AlixPayDemo";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
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

@end
