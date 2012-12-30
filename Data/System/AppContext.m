//
//  AppContext.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AppContext.h"
#import "Reachability.h"
#import "GeocodeHelper.h"

@interface AppContext () <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager*	locMgr;

@end

@implementation AppContext

@synthesize online;
@synthesize tabbar;

#pragma mark - life cycle

- (void)dealloc
{
	self.locMgr = nil;
	self.currentLocationCity = nil;
	self.currentLocationGeocode = nil;
	
    [tabbar release], tabbar = nil;
	[super dealloc];
}

+ (AppContext *)get
{   
    static dispatch_once_t onceQueue;
    static AppContext *appContext = nil;
    
    dispatch_once(&onceQueue, ^{ appContext = [[self alloc] init]; });
    return appContext;
}

- (id)init
{
	if (self = [super init]) {
		int64_t delayInSeconds = 1.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self requestMyLocation];
		});
	}
	
	return self;
}

#pragma mark - core methods

- (BOOL)online
{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return status != NotReachable;
}

- (void)requestMyLocation
{
#if !(TARGET_IPHONE_SIMULATOR)
	if ([CLLocationManager locationServicesEnabled])
#endif
	{
		if (_locMgr == nil) {
			_locMgr = [[CLLocationManager alloc] init];
			_locMgr.delegate = self;
			_locMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		}
		
		[_locMgr startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	_currentLatitude = (CGFloat)newLocation.coordinate.latitude; // 39.8986
	_currentLongitude = (CGFloat)newLocation.coordinate.longitude; // 116.502
	
	self.isLocationAvailable = YES;
	self.currentLocationGeocode = [NSString stringWithFormat:NSLocalizedString(@"GEOUnkownPlace", nil), _currentLongitude, _currentLatitude];
	
	__block AppContext* blockSelf = self;
	[GeocodeHelper requestGeocodeWithLat:_currentLatitude
								  andLon:_currentLongitude
							 andComplete:^(NSString *address, NSString* city) {
								 blockSelf.currentLocationGeocode = address;
								 blockSelf.currentLocationCity = city;
							 }];
}

@end


#if TARGET_IPHONE_SIMULATOR

@interface CLLocationManager (Simulator)
@end

@implementation CLLocationManager (Simulator)

- (void)startUpdatingLocation
{
    float latitude = 39.9453964f;
    float longitude = 116.287048f;
    CLLocation* setLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
    [[AppContext get] locationManager:self didUpdateToLocation:setLocation
						 fromLocation:setLocation];
}

@end
#endif // TARGET_IPHONE_SIMULATOR

