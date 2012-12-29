//
//  GeocodeHelper.m
//  TaurusClient
//
//  Created by Simon on 12-12-26.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "GeocodeHelper.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface GeocodeHelper ()

+ (NSString*)buildAddressFromComponents:(NSArray*)components;
+ (NSString*)queryCityFromComponents:(NSArray*)components;

@end

@implementation GeocodeHelper

+ (NSString *)buildAddressFromComponents:(NSArray *)components
{
	NSArray* compParts = [NSArray arrayWithObjects:@"administrative_area_level_1"
						  , @"sublocality"
						  , @"route"
						  , @"street_number"
						  , nil];
	
	NSMutableString* result = [NSMutableString string];
	
	for (NSString* compPart in compParts) {
		for (NSDictionary* component in components) {
			NSArray* types = [component objectForKey:@"types"];
			if ([types containsObject:compPart]) {
				NSString* shortName = [component objectForKey:@"short_name"];
				[result appendString:shortName];
				
				break;
			}
		}
	}
	
	return result;
}

+ (NSString*)queryCityFromComponents:(NSArray*)components
{
	for (NSDictionary* component in components) {
		NSArray* types = [component objectForKey:@"types"];
		if ([types containsObject:@"locality"]
			/*|| [types containsObject:@"political"]*/) {
			
			NSString* city = [component objectForKey:@"short_name"];
			return city;
		}
	}
	
	return nil;
}

+ (void)requestGeocodeWithLat:(float)lat
					   andLon:(float)lon
				  andComplete:(OnGeocodeResponse)complete
{
	// 请求geocode
	NSString* geocodeUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&language=%@&sensor=false"
							, lat, lon, NSLocalizedString(@"GoogleLanguage", nil)];
	__block ASIHTTPRequest* geocodeReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:geocodeUrl]];
	
	OnGeocodeResponse safeComplete = [[complete copy] autorelease];
	
	[geocodeReq setCompletionBlock:^{
		NSString* respString = geocodeReq.responseString;
		NSDictionary* jsonRoot = [respString objectFromJSONString];
		NSArray* results = [jsonRoot objectForKey:@"results"];
		
		if ([results count] == 0) {
			NSString* address = [NSString stringWithFormat:NSLocalizedString(@"GEOUnkownPlace", nil), lon, lat];
			NSString* city = [NSString stringWithFormat:NSLocalizedString(@"GEOUnkownCity", nil), lon, lat];
			
			if (safeComplete != nil)
				safeComplete(address, city);
		} else {
			NSDictionary* result = [results objectAtIndex:0];
			
			/*for (NSDictionary* result in results)*/ {
				// 判断location_type
				/*NSString* locationType = [result valueForKeyPath:@"geometry.location_type"];
				 if ([locationType isEqualToString:@"ROOFTOP"])*/ {
					 NSArray* addressComponents = [result objectForKey:@"address_components"];
					 NSString* address = [self buildAddressFromComponents:addressComponents];
					 NSString* city = [self queryCityFromComponents:addressComponents];
					 
					 if (safeComplete != nil)
						 safeComplete(address, city);
					 
					 /*break;*/
				 }
			}
		}
	}];
	
	[geocodeReq startAsynchronous];
}

@end
