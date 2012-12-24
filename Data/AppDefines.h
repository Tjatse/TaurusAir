//
//  AppDefines.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//


#ifndef __TC_CONFIG_H
#define __TC_CONFIG_H

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



