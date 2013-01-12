//
//  CharCodeHelper.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "CharCodeHelper.h"
#import "CHCSVParser.h"
#import "TwoCharCode.h"
#import "ThreeCharCode.h"
#import "City.h"
#import "CityGroup.h"
#import "NSString+pinyin.h"
#import "OrderState.h"
#import "CitySearchHelper.h"

@interface CharCodeHelper () <CHCSVParserDelegate>

@property (nonatomic, retain) NSMutableArray*			csvPureLines;
@property (nonatomic, retain) NSMutableArray*			lastLineItems;

@end

@implementation CharCodeHelper

#pragma mark - class methods

+ (NSDictionary*)allCities
{
	static NSMutableDictionary* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			result = [[NSMutableDictionary dictionary] retain];
			NSArray* items = [self allThreeCharCodes];
			
			for (ThreeCharCode* item in items) {
				City* city = [result objectForKey:item.cityName];
				
				if (city == nil) {
					city = [[City alloc] init];
					city.cityName = item.cityName;
					
					[result setValue:city forKey:item.cityName];
					[city release];
				}
				
				[city appendThreeCharCode:item];
			}
		}
	}
	
	return result;
}

+ (NSArray *)allCityGroups
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			result = [[NSMutableArray array] retain];
			
			CityGroup* popularCityGroup = [[CityGroup alloc] initWithGroupName:@"热门"
																		cities:[CitySearchHelper popularCities]];
			[result addObject:popularCityGroup];
			SAFE_RELEASE(popularCityGroup);
			
//			for (char firstCharSeq = 'A'; firstCharSeq <= 'Z'; ++firstCharSeq) {
//				NSString* firstCharStr = [NSString stringWithFormat:@"%c", firstCharSeq];
//				
//			}
			
			NSMutableDictionary* firstCharSeqDic = [NSMutableDictionary dictionary];
			NSArray* allCities = [[self allCities] allValues];
			for (City* city in allCities) {
				// pinyin
				NSString* pinyin = [NSString pinyinFromChiniseString:city.cityName];
				NSString* firstLetter = [[pinyin substringToIndex:1] uppercaseString];
				CityGroup* group = [firstCharSeqDic objectForKey:firstLetter];
				
				if (group == nil) {
					group = [[CityGroup alloc] init];
					group.groupName = firstLetter;
					[firstCharSeqDic setValue:group forKey:firstLetter];
					[group release];
				}
				
				[group appendCity:city];
			}
			
			NSMutableArray* firstCharSeqArray = [NSMutableArray arrayWithArray:[firstCharSeqDic allValues]];
			[firstCharSeqArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
				CityGroup* city1 = (CityGroup*)obj1;
				CityGroup* city2 = (CityGroup*)obj2;
				
				return [city1.groupName compare:city2.groupName];
			}];
			
			[result addObjectsFromArray:firstCharSeqArray];
		}
	}
	
	return result;
}

+ (NSArray*)parseContentOfCSVFile:(NSString*)filePath
{
	CHCSVParser* csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath];
	
	CharCodeHelper* parserWrapper = [[[CharCodeHelper alloc] init] autorelease];
	csvParser.delegate = parserWrapper;
	[csvParser parse];
	
	SAFE_RELEASE(csvParser);
	
	return parserWrapper.csvPureLines;
}

+ (NSDictionary*)allTwoCharCodesDictionary
{
	static NSDictionary* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			result = [[NSMutableDictionary dictionary] retain];
			NSArray* items = [self allTwoCharCodes];
			
			for (TwoCharCode* item in items)
				[result setValue:item forKey:item.charCode];
		}
	}
	
	return result;
}

+ (NSDictionary*)allThreeCharCodesDictionary
{
	static NSDictionary* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			result = [[NSMutableDictionary dictionary] retain];
			NSArray* items = [self allThreeCharCodes];
			
			for (ThreeCharCode* item in items)
				[result setValue:item forKey:item.charCode];
		}
	}
	
	return result;
}

 + (NSArray *)allTwoCharCodes
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			NSString* filePath = [[NSBundle mainBundle] pathForResource:@"double_char_code" ofType:@"csv"];
			NSArray* csvPureLines = [self parseContentOfCSVFile:filePath];
			
			result = [[NSMutableArray array] retain];
			for (NSArray* line in csvPureLines) {
				NSString* charCode = [line objectAtIndex:0];
				NSString* corpFullName = [line objectAtIndex:1];
				NSString* corpAbbrName = [line objectAtIndex:2];
				NSString* flightAreaCode = [line objectAtIndex:3];
				
				TwoCharCode* item = [[TwoCharCode alloc] initWithCharCode:charCode
															 corpFullName:corpFullName
															 corpAbbrName:corpAbbrName
														   flightAreaCode:[flightAreaCode intValue]];
				
				[result addObject:item];
				SAFE_RELEASE(item);
			}
		}
	}
	
	return result;
}
+ (NSDictionary *)allOrderStates
{
	static NSMutableDictionary* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			NSString* filePath = [[NSBundle mainBundle] pathForResource:@"order_state" ofType:@"csv"];
			NSArray* csvPureLines = [self parseContentOfCSVFile:filePath];
			
			result = [[NSMutableDictionary dictionary] retain];
			for (NSArray* line in csvPureLines) {
				NSString* code = [line objectAtIndex:0];
				NSString* title = [line objectAtIndex:1];
				
                OrderState *item = [[OrderState alloc] initWithCode:code title:title];
                
				[result setObject:item forKey:code];
                
				SAFE_RELEASE(item);
			}
		}
	}
	
	return result;
}
+ (NSArray *)allThreeCharCodes
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			NSString* filePath = [[NSBundle mainBundle] pathForResource:@"three_char_code" ofType:@"csv"];
			NSArray* csvPureLines = [self parseContentOfCSVFile:filePath];
			
			result = [[NSMutableArray array] retain];
			for (NSArray* line in csvPureLines) {
				NSString* charCode = [line objectAtIndex:0];
				NSString* cityName = [line objectAtIndex:1];
				NSString* airportName = [line objectAtIndex:2];
				NSString* airportAbbrName = [line objectAtIndex:3];
				NSString* flightAreaCode = [line objectAtIndex:4];
				
				ThreeCharCode* item = [[ThreeCharCode alloc] initWithCharCode:charCode
																	 cityName:cityName
																  airportName:airportName
															  airportAbbrName:airportAbbrName
															   flightAreaCode:[flightAreaCode intValue]];
				
				[result addObject:item];
				SAFE_RELEASE(item);
			}
		}
	}
	
	return result;
}

#pragma mark - life cycle

- (void)dealloc
{
	self.csvPureLines = nil;
	self.lastLineItems = nil;
	
	[super dealloc];
}

#pragma mark - csvparser delegate

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
	self.csvPureLines = [[[NSMutableArray alloc] init] autorelease];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
	self.lastLineItems = [[[NSMutableArray alloc] init] autorelease];
	[self.csvPureLines addObject:self.lastLineItems];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
	[self.lastLineItems addObject:field];
}

@end

@implementation TwoCharCode (FriendlyFlightAreaCode)

- (FlightAreaType)flightArea
{
	return self.flightAreaCode == 1 ? kFlightAreaTypeInternal : kFlightAreaTypeGlobal;
}

@end

@implementation ThreeCharCode (FriendlyFlightAreaCode)

- (FlightAreaType)flightArea
{
	return self.flightAreaCode == 1 ? kFlightAreaTypeInternal : kFlightAreaTypeGlobal;
}

@end
