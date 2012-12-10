/*
 *  msgforOC.h
 *  ZM
 *
 *  Created by jin on 10-10-12.
 *  Copyright 2010 zh. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import "FSNotification.h"
#import "NSObject(notification).h"

typedef enum msg_types
{
    REMOVE_SELF_NOTI=-1,
	PHOTO_SMS,
	STOP_SMS,
}MSG_Type;