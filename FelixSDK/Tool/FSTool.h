//
//  FSTool.h
//  FSSDK
//
//  Created by Felix on 11-11-6.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCallBack.h"
#import <CoreLocation/CoreLocation.h>

#define SAFE_DELETE(p) do { if(p){ delete p; p=NULL;} } while(false)
#define SAFE_FREE(p) do { if(p){ free(p); p=NULL;} } while (false)
#define SAFE_RELEASE(p) do { if(p) {[p release];p=nil; } } while (false)

@interface FSTool : NSObject

//1、获取地理位置，经纬度。
//2、通过经纬度获取地址。
//3、通过经纬度调用地图。
+(CLLocation*)getCurLocation;
+(NSString*)getAddressByLocation:(CLLocation*)local;
+(NSString*)url2Filepath:(NSString*)fileUrl;
//()把url转成文件路径，根路径为应用路径。转成功返回true。

+ (NSString*)getPreferredLanguage;

@end
