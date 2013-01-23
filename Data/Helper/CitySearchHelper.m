//
//  CitySearchHelper.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "CitySearchHelper.h"
#import "City.h"
#import "CharCodeHelper.h"
#import "NSStringAdditions.h"
#import "NSString+pinyin.h"
#import "SearchCityResult.h"

@implementation CitySearchHelper

+ (NSArray*)popularCities
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			result = [[NSMutableArray array] retain];
			NSArray* cityNames = @[@"北京",
			@"上海",
			@"广州",
			@"昆明",
			@"杭州",
			@"西安",
			@"成都",
			@"南京",
			@"深圳",
			@"长沙",
			@"重庆",
			@"乌鲁木齐",
			@"沈阳",
			@"三亚",
			@"海口",
			@"青岛",
			@"大连",
			@"长春",
			@"郑州",
			@"济南",
			@"哈尔滨",
			@"天津",
			@"厦门",
			@"太原"
];
			
			for (NSString* cityName in cityNames)
				[result addObject:[self queryCityWithCityName:cityName]];
		}
	}
	
	return result;
}

+ (City *)queryCityWithCityName:(NSString *)cityName
{
	NSDictionary* cities = [CharCodeHelper allCities];
	return [cities objectForKey:cityName];
}

+ (NSArray *)queryCityWithFilterKey:(NSString *)filterKey
{
	NSMutableArray* result = [NSMutableArray array];
	NSArray* allCities = [CharCodeHelper allCities].allValues;
	for (City* city in allCities) {
		// 获取拼音、简称、三字码
		NSString* simplePinyin = [NSString pinyinFirstCharFromChineseString:city.cityName];
		NSString* pinyin = [NSString pinyinFromChiniseString:city.cityName];
		NSArray* threeCharCodes = city.threeCharCodes;
		
		if ([city.cityName rangeOfString:filterKey options:NSCaseInsensitiveSearch].location != NSNotFound) {
			// 判断城市名
			[result addObject:[[[SearchCityResult alloc] initWithCity:city reason:nil] autorelease]];
		} else if ([simplePinyin rangeOfString:filterKey options:NSCaseInsensitiveSearch].location != NSNotFound) {
			// 判断拼音简称
			[result addObject:[[[SearchCityResult alloc] initWithCity:city reason:simplePinyin] autorelease]];
		} else if ([pinyin rangeOfString:filterKey options:NSCaseInsensitiveSearch].location != NSNotFound) {
			// 判断拼音
			[result addObject:[[[SearchCityResult alloc] initWithCity:city reason:pinyin] autorelease]];
		} else {
			// 判断三字码
			for (ThreeCharCode* threeCharCode in threeCharCodes) {
				if ([threeCharCode.charCode rangeOfString:filterKey options:NSCaseInsensitiveSearch].location != NSNotFound) {
					[result addObject:[[[SearchCityResult alloc] initWithCity:city reason:threeCharCode.charCode] autorelease]];
					
					break;
				}
			}
		}
	}
	
	return result;
}

@end
