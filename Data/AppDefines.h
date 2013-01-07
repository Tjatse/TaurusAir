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
#define SANDBOX                 @"Development" // Production or Development
#define IS_DEPLOYED()           ([SANDBOX isEqualToString:@"Production"])

// uris
// account.
#define REACHABLE_HOST      @"http://211.144.155.155:5001"
#define CLIENT_ID           @"m_b2c_001"
#define SAFE_CODE           @""
#define ACCOUNT_REG         @"Interfaces/RegistUser.ashx"
#define ACCOUNT_UPDATE      @"Interfaces/EditUserInfo.ashx"
#define ACCOUNT_LOGIN       @"Interfaces/UserLogin.ashx"
#define ACCOUNT_LOGOUT      @"Interfaces/UserLoginOut.ashx"
#define ACCOUNT_UPDPWD      @"Interfaces/EditUserPwd.ashx"
#define ACCOUNT_FINDPWD     @"Interfaces/PasswordRecovery.ashx"
// order.
#define ORDER_LIST          @"Interfaces/GetTicketOrdersByCondition.ashx"

#define setRequestAuth(request) [request setPostValue:CLIENT_ID forKey:@"ClientId"];[request setPostValue:SAFE_CODE forKey:@"safeCode"];

#endif // __TC_CONFIG_H



