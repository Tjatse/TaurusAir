//
//  FSTool.m
//  FSSDK
//
//  Created by Felix on 11-11-6.
//  Copyright 2011 deep. All rights reserved.
//
//
//view sourceprint?01@implementation CurrentLocation
//
//　　02
//
//　　03@synthesize locationManager;
//
//　　04@synthesize target,callBack;
//
//　　05
//
//　　06#pragma mark --
//
//　　07#pragma mark Public
//
//　　08-(void) startUpdatingLocation{
//	
//	　　09 [[self locationManager] startUpdatingLocation];
//	
//	　　10}
//
//　　11#pragma mark --
//
//　　12#pragma mark Memory management
//
//　　13-(void) dealloc{
//	
//	　　14 [super dealloc];
//	
//	　　15 [locationManager release];
//	
//	　　16}
//
//　　17#pragma mark --
//
//　　18#pragma mark Location manager
//
//　　19/*
//	 
//	 　　20 Return a location manager -- create one if necessary.
//	 
//	 　　21 */
//
//　　22- (CLLocationManager *)locationManager {
//	
//	　　23 if (locationManager != nil) {return locationManager;}
//	
//	　　24 locationManager = [[CLLocationManager alloc] init];
//	
//	　　25 [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//	
//	　　26 [locationManager setDelegate:self];
//	
//	　　27 return locationManager;
//	
//	　　28}
//
//　　29#pragma mark --
//
//　　30#pragma mark CLLocationManagerDelegate methods
//
//　　31/*
//	 
//	 　　32 Conditionally enable the Add button:
//	 
//	 　　33 If the location manager is generating updates, then enable the button;
//	 
//	 　　34 If the location manager is failing, then disable the button.
//	 
//	 　　35 */
//
//　　36- (void)locationManager:(CLLocationManager *)manager
//
//　　37 didUpdateToLocation:(CLLocation *)newLocation
//
//　　38 fromLocation:(CLLocation *)oldLocation {
//	
//	　　39 NSLog(@"获取到经纬度!");
//	
//	　　40}
//
//　　41- (void)locationManager:(CLLocationManager *)manager
//
//　　42 didFailWithError:(NSError *)error {
//	
//	　　接上页
//	
//	　　43 NSLog(@"获取失败!");
//	
//	　　44 }
//
//　　45@end
//
//　　2: 获取当前手机经纬度的详细地址
//
//　　view sourceprint?01@implementation AddressReverseGeoder
//
//　　02
//
//　　03#pragma mark --
//
//　　04#pragma mark Public
//
//　　05//根据经纬度开始获取详细地址信息
//
//　　06- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude{
//	
//	　　07 CLLocationCoordinate2D coordinate2D;
//	
//	　　08 coordinate2D.longitude = longitude;
//	
//	　　09 coordinate2D.latitude = latitude;
//	
//	　　10 //
//	
//	　　11 MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
//	
//	　　12 geoCoder.delegate = self;
//	
//	　　13 [geoCoder start];
//	
//	　　14}
//
//　　15#pragma mark --
//
//　　16#pragma mark MKReverseGeocoderDelegate methods
//
//　　17//获得地址信息
//
//　　18- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
//	
//	　　19 NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",
//							  
//							  　　20 placemark.country,
//							  
//							  　　21 placemark.administrativeArea,
//							  
//							  　　22 placemark.locality,
//							  
//							  　　23 placemark.subLocality,
//							  
//							  　　24 placemark.thoroughfare,
//							  
//							  　　25 placemark.subThoroughfare];
//	
//	　　26 NSLog(@"经纬度所对应的详细:%@", address);
//	
//	　　27 geocoder = nil;
//	
//	　　28}
//
//　　29//错误处理
//
//　　30- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
//	
//	　　31 NSLog(@"error %@" , error);
//	
//	　　32}
//
//　　33#pragma mark --
//
//　　34#pragma mark Memory management
//
//　　35- (void)dealloc {
//	
//	　　36 [super dealloc];
//	
//	　　37}
//
//　　38@end

#import "FSTool.h"

@implementation FSTool

+(NSString*)url2Filepath:(NSString*)fileUrl
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectoryPath = nil;
    if (!fileUrl || [fileUrl isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [fileUrl rangeOfString:@"://"];
    if (rang.location != NSNotFound) {
        NSString *sub = [fileUrl substringFromIndex:rang.location+rang.length];
		documentsDirectoryPath = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],sub];
        rang = [documentsDirectoryPath rangeOfString:@"/" options:NSBackwardsSearch];
        NSString* dic = [documentsDirectoryPath substringToIndex:rang.location];
        NSFileManager *file = [NSFileManager defaultManager];
        if (![file fileExistsAtPath:dic]) {
            [file createDirectoryAtPath:dic withIntermediateDirectories:YES attributes:nil error:nil];
        }
        sub = [documentsDirectoryPath substringFromIndex:rang.location+1];
        if ([sub isEqualToString:@""]) {
            documentsDirectoryPath = [NSString stringWithFormat:@"%@/hello",documentsDirectoryPath];
        }
    }

    return documentsDirectoryPath;
}

+(CLLocation*)getCurLocation
{
	CLLocationManager*man = [CLLocationManager new];
	[man setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[man startUpdatingLocation];
	CLLocation *local = man.location;
	[man release];
	return local;
}

+(NSString*)getAddressByLocation:(CLLocation*)local
{
	//NSString*addr = nil;
	return [local description];
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

@end
