//
//  AppDefines.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//


#ifndef __TC_CONFIG_H
#define __TC_CONFIG_H
typedef enum{
    NewOrder = 1010,                // 新订单
    ApplyPrice = 1060,              // 申请定价
    PricedForCommon = 1110,         // 普通单定价完成
    CommonPayOnline = 1150,         // 普通单-在线支付
    CommonPayAtCounter = 1160,      // 普通单-柜台收银
    CommonAirportTicket = 1170,     // 普通单-机场取票后支付
    CommonDraftConfirmed = 1180,    // 普通单-授信确认
    CommonPayAfterSend = 1190,      // 普通单-送票后支付
    CommonConfirmed = 1200,         // 普通确认订单
    AllowDZ = 1210,                 // 可出票
    DZFinish = 1260,                // 出票完成
    ApplyChange = 1310,             // 新变更单
    PricedForChange = 1360,         // 变更定价完成
    ChangePayOnline = 1370,         // 变更单-在线支付
    ChangePayAtCounter = 1380,      // 变更单-柜台收银
    ChangeDraftConfirmed = 1390,    // 变更单-授信确认
    ChangeConfirmed = 1410, // 变更确认
    FinishChange = 1460,    // 变更成功
    ApplyRefund = 1510,     // 申请退废
    RefundConfirmed = 1530, // 确认退废
    FinishRefund = 1560,    // 退废成功
    ApplyCancel = 1610,     // 申请取消
    Canceled = 1660         // 取消订单
} OrderState;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_RECT             [[UIScreen mainScreen] bounds]
#define STATUSBAR_FRAME         [[UIApplication sharedApplication] statusBarFrame]
#define NAVBAR_HEIGHT           44

// uris
#define REACHABLE_HOST      @"http://211.144.155.155:5001"
#define CLIENT_ID           @"m_b2c_001"
#define SAFECODE            @""
#define ACCOUNT_REG         @"Interfaces/RegistUser.ashx"
#define ACCOUNT_UPDATE      @"Interfaces/EditUserInfo.ashx"
#define ACCOUNT_LOGIN       @"Interfaces/UserLogin.ashx"
#define ACCOUNT_LOGOUT      @"Interfaces/UserLoginOut.ashx"
#define ACCOUNT_UPDPWD      @"Interfaces/EditUserPwd.ashx"
#define ACCOUNT_FINDPWD     @"Interfaces/PasswordRecovery.ashx"


#endif // __TC_CONFIG_H



