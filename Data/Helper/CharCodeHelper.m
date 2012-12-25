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

@interface CharCodeHelper () <CHCSVParserDelegate>

@property (nonatomic, retain) NSMutableArray*			csvPureLines;
@property (nonatomic, retain) NSMutableArray*			lastLineItems;

+ (NSArray*)parseContentOfCSVFile:(NSString*)filePath;

@end

@implementation CharCodeHelper

#pragma mark - class methods

+ (NSArray*)parseContentOfCSVFile:(NSString*)filePath
{
	CHCSVParser* csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath];
	
	CharCodeHelper* parserWrapper = [[[CharCodeHelper alloc] init] autorelease];
	csvParser.delegate = parserWrapper;
	[csvParser parse];
	
	SAFE_RELEASE(csvParser);
	
	return parserWrapper.csvPureLines;
}

 + (NSArray *)allTwoCharCodes
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			NSString* filePath = [[NSBundle mainBundle] pathForResource:@"double_char_code" ofType:@"csv"];
			NSArray* csvPureLines = [self parseContentOfCSVFile:filePath];
			
			result = [NSMutableArray array];
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

+ (NSArray *)allThreeCharCodes
{
	static NSMutableArray* result = nil;
	
	@synchronized (self) {
		if (result == nil) {
			NSString* filePath = [[NSBundle mainBundle] pathForResource:@"three_char_code" ofType:@"csv"];
			NSArray* csvPureLines = [self parseContentOfCSVFile:filePath];
			
			result = [NSMutableArray array];
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
