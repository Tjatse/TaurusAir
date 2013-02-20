//
//  AppDefines.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//


#ifndef __TC_CONFIG_H
#define __TC_CONFIG_H

typedef enum {
    CONTACTER = 0,
    TRAVELER = 1
} CONTACTER_TYPE;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_RECT             [[UIScreen mainScreen] bounds]
#define STATUSBAR_FRAME         [[UIApplication sharedApplication] statusBarFrame]
#define NAVBAR_HEIGHT           44
#define SANDBOX                 @"Production" // Production or Development
#define IS_DEPLOYED()           ([SANDBOX isEqualToString:@"Production"])

#define APP_VERSION         @"金牛信息ISO 003版"
#define APP_SHORTVERSION    1.0
#define APP_PHONE           @"010-53510125"
#define APP_URL             @"http://www.jinniuit.com"
#define APP_COPYRIGHT       @"CopyRight © 2010-2012 \n北京金牛座信息技术有限公司 All Rights Reserved"
#define VERSION_CHECK       @"http://119.167.156.135/womeeting/jn/v.json"

// uris
// account.
#define REACHABLE_HOST      @"http://211.144.155.155:5001"
#define CLIENT_ID           @"m_b2c_001"
#define SAFE_CODE           @""
#define ACCOUNT_REG         @"Interfaces/RegistUser.ashx"
#define ACCOUNT_UPDATE      @"Interfaces/EditUserInfo.ashx"
#define ACCOUNT_LOGIN       @"Interfaces/UserLogin.ashx"
#define ACCOUNT_GET         @"Interfaces/GetUserInfoById.ashx"
#define ACCOUNT_LOGOUT      @"Interfaces/UserLoginOut.ashx"
#define ACCOUNT_UPDPWD      @"Interfaces/EditUserPwd.ashx"
#define ACCOUNT_FINDPWD     @"Interfaces/PasswordRecovery.ashx"
#define ACCOUNT_VERIFY_CODE @"Interfaces/GetVerifyCode.ashx"
// order.
#define ORDER_LIST          @"Interfaces/GetTicketOrdersByCondition.ashx"
#define ORDER_DETAIL        @"Interfaces/GetTicketOrderDetailById.ashx"
#define ORDER_CANCEL        @"Interfaces/CancelOrder.ashx"
#define ORDER_REFUND        @"Interfaces/ApplyRefund.ashx"

// traveler.
#define TRAVELER_PASSENGERS @"Interfaces/GetPassengers.ashx"
#define TRAVELER_CONTACTERS @"Interfaces/GetContactors.ashx"
#define TRAVELER_PSG_OPR    @"Interfaces/OperatePassenger.ashx"
#define TRAVELER_CTC_OPR    @"Interfaces/OperateContactor.ashx"

// flight search
extern NSString* const		kFlightSearchURL;
extern NSString* const		kFlightPlaceOrderURL;
extern NSString* const		kOrderCreatePayUrl;
extern NSString* const		kCabinRemarkURL;

// alixpay
extern NSString* const		kAlixPayPartnerId;
extern NSString* const		kAlixPaySellerId;
extern NSString* const		kAlixPayRSASafeCode;
extern NSString* const		kAlixPayRSAPublicKey;

// feedback
extern NSString* const		kFeedbackURL;

#define setRequestAuth(request) \
		[request setPostValue:CLIENT_ID forKey:@"ClientId"]; \
		[request setPostValue:SAFE_CODE forKey:@"safeCode"];

#endif // __TC_CONFIG_H



