//
//  NSStringAdditions.m
//  Weibo
//
//  Created by junmin liu on 10-9-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSStringAdditions.h"
#import "NSString+pinyin.h"

@implementation NSString (Additions)

+ (NSString *)generateGuid {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [uuidString autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	for (NSInteger i = 0; i < self.length; ++i) {
		unichar c = [self characterAtIndex:i];
		if (![whitespace characterIsMember:c]) {
			return NO;
		}
	}
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace {
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
	NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	NSScanner* scanner = [[[NSScanner alloc] initWithString:self] autorelease];
	while (![scanner isAtEnd]) {
		NSString* pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
		if (kvPair.count == 2) {
			NSString* key = [[kvPair objectAtIndex:0]
							 stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString* value = [[kvPair objectAtIndex:1]
							   stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:pairs];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [query keyEnumerator]) {
		NSString* value = [query objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[pairs addObject:pair];
	}
	
	NSString* params = [pairs componentsJoinedByString:@"&"];
	if ([self rangeOfString:@"?"].location == NSNotFound) {
		return [self stringByAppendingFormat:@"?%@", params];
	} else {
		return [self stringByAppendingFormat:@"&%@", params];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other {
	NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
	NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
	
	// The parts before the "a"
	NSString *oneMain = [oneComponents objectAtIndex:0];
	NSString *twoMain = [twoComponents objectAtIndex:0];
	
	// If main parts are different, return that result, regardless of alpha part
	NSComparisonResult mainDiff;
	if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame) {
		return mainDiff;
	}
	
	// At this point the main parts are the same; just deal with alpha stuff
	// If one has an alpha part and the other doesn't, the one without is newer
	if ([oneComponents count] < [twoComponents count]) {
		return NSOrderedDescending;
	} else if ([oneComponents count] > [twoComponents count]) {
		return NSOrderedAscending;
	} else if ([oneComponents count] == 1) {
		// Neither has an alpha part, and we know the main parts are the same
		return NSOrderedSame;
	}
	
	// At this point the main parts are the same and both have alpha parts. Compare the alpha parts
	// numerically. If it's not a valid number (including empty string) it's treated as zero.
	NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
	NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
	return [oneAlpha compare:twoAlpha];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString *)URLEncodedString 
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
}

+ (NSString*) imageCachePath {
	NSString* result = [[self documentsPath] stringByAppendingPathComponent:@"imageCache"];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr createDirectoryAtPath:result 
	   withIntermediateDirectories:YES 
						attributes:nil 
							 error:nil];
	
	return result;
}

+ (NSString*) fileCachePath {
	NSString* result = [[self documentsPath] stringByAppendingPathComponent:@"fileCache"];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr createDirectoryAtPath:result 
	   withIntermediateDirectories:YES 
						attributes:nil 
							 error:nil];
	
	return result;
}

+ (NSString*) actionCachePath {
	NSString* result = [[self documentsPath] stringByAppendingPathComponent:@"actionCache"];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr createDirectoryAtPath:result 
	   withIntermediateDirectories:YES 
						attributes:nil 
							 error:nil];
	
	return result;
}

+ (NSString*) documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (BOOL)writeFileAtPath: (NSString*)filePath withFileName:(NSString*) fileName withUTF8Data:(NSData*) data {
	NSFileManager* fm = [NSFileManager defaultManager];
	
	NSString* absFileName = [filePath stringByAppendingPathComponent:fileName];
	if ([fm fileExistsAtPath: filePath]) {
		if (![fm fileExistsAtPath:absFileName]) {
			[fm createFileAtPath:absFileName contents:data attributes:nil];
		}else {
			NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:absFileName];
			[fileHandle writeData:data];
			return YES;
		} 
	}else {
		if ([fm createDirectoryAtPath:filePath 
		  withIntermediateDirectories: YES attributes:nil error:nil]) {
			[fm createFileAtPath:absFileName contents:data attributes:nil];
			return YES;
		}
	}
	return NO;
}

+ (BOOL) isCacheExist: (NSString*) reqURL cachePath:(NSString*) cachePath cacheData:(NSMutableData*) cacheData {
	static NSString* ampStr = @"&amp";
	static NSString* andStr = @"&";
	NSString* url = [reqURL stringByReplacingOccurrencesOfString:ampStr withString:andStr];
	NSString* digValue = [url md5Hash];	
	NSString* filePath = [cachePath stringByAppendingPathComponent:digValue];
	
	NSFileManager* fm = [[NSFileManager alloc] init];
	if ([fm fileExistsAtPath: filePath]) {
		NSMutableData* data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
		[cacheData setData:data];
		[data release];
		
		SAFE_RELEASE(fm);
		return YES;
	}
	
	SAFE_RELEASE(fm);
	
	return NO;
}

- (NSString*) chineseFirstLetter {
	/*
	static int li_SecPosValue[] = {
		1601, 1637, 1833, 2078, 2274, 2302, 2433, 2594, 2787, 3106, 3212,
		3472, 3635, 3722, 3730, 3858, 4027, 4086, 4390, 4558, 4684, 4925, 5249
	};
	static char lc_FirstLetter[] = {
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O',
		'P', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z'
	};
	static char* ls_SecondSecTable =
	"CJWGNSPGCGNE[Y[BTYYZDXYKYGT[JNNJQMBSGZSCYJSYY[PGKBZGY[YWJKGKLJYWKPJQHY[W[DZLSGMRYPYWWCCKZNKYYGTTNJJNYKKZYTCJNMCYLQLYPYQFQRPZSLWBTGKJFYXJWZLTBNCXJJJJTXDTTSQZYCDXXHGCK[PHFFSS[YBGXLPPBYLL[HLXS[ZM[JHSOJNGHDZQYKLGJHSGQZHXQGKEZZWYSCSCJXYEYXADZPMDSSMZJZQJYZC[J[WQJBYZPXGZNZCPWHKXHQKMWFBPBYDTJZZKQHY"
	"LYGXFPTYJYYZPSZLFCHMQSHGMXXSXJ[[DCSBBQBEFSJYHXWGZKPYLQBGLDLCCTNMAYDDKSSNGYCSGXLYZAYBNPTSDKDYLHGYMYLCXPY[JNDQJWXQXFYYFJLEJPZRXCCQWQQSBNKYMGPLBMJRQCFLNYMYQMSQYRBCJTHZTQFRXQHXMJJCJLXQGJMSHZKBSWYEMYLTXFSYDSWLYCJQXSJNQBSCTYHBFTDCYZDJWYGHQFRXWCKQKXEBPTLPXJZSRMEBWHJLBJSLYYSMDXLCLQKXLHXJRZJMFQHXHWY"
	"WSBHTRXXGLHQHFNM[YKLDYXZPYLGG[MTCFPAJJZYLJTYANJGBJPLQGDZYQYAXBKYSECJSZNSLYZHSXLZCGHPXZHZNYTDSBCJKDLZAYFMYDLEBBGQYZKXGLDNDNYSKJSHDLYXBCGHXYPKDJMMZNGMMCLGWZSZXZJFZNMLZZTHCSYDBDLLSCDDNLKJYKJSYCJLKWHQASDKNHCSGANHDAASHTCPLCPQYBSDMPJLPZJOQLCDHJJYSPRCHN[NNLHLYYQYHWZPTCZGWWMZFFJQQQQYXACLBHKDJXDGMMY"
	"DJXZLLSYGXGKJRYWZWYCLZMSSJZLDBYD[FCXYHLXCHYZJQ[[QAGMNYXPFRKSSBJLYXYSYGLNSCMHZWWMNZJJLXXHCHSY[[TTXRYCYXBYHCSMXJSZNPWGPXXTAYBGAJCXLY[DCCWZOCWKCCSBNHCPDYZNFCYYTYCKXKYBSQKKYTQQXFCWCHCYKELZQBSQYJQCCLMTHSYWHMKTLKJLYCXWHEQQHTQH[PQ[QSCFYMNDMGBWHWLGSLLYSDLMLXPTHMJHWLJZYHZJXHTXJLHXRSWLWZJCBXMHZQXSDZP"
	"MGFCSGLSXYMJSHXPJXWMYQKSMYPLRTHBXFTPMHYXLCHLHLZYLXGSSSSTCLSLDCLRPBHZHXYYFHB[GDMYCNQQWLQHJJ[YWJZYEJJDHPBLQXTQKWHLCHQXAGTLXLJXMSL[HTZKZJECXJCJNMFBY[SFYWYBJZGNYSDZSQYRSLJPCLPWXSDWEJBJCBCNAYTWGMPAPCLYQPCLZXSBNMSGGFNZJJBZSFZYNDXHPLQKZCZWALSBCCJX[YZGWKYPSGXFZFCDKHJGXDLQFSGDSLQWZKXTMHSBGZMJZRGLYJB"
	"PMLMSXLZJQQHZYJCZYDJWBMYKLDDPMJEGXYHYLXHLQYQHKYCWCJMYYXNATJHYCCXZPCQLBZWWYTWBQCMLPMYRJCCCXFPZNZZLJPLXXYZTZLGDLDCKLYRZZGQTGJHHGJLJAXFGFJZSLCFDQZLCLGJDJCSNZLLJPJQDCCLCJXMYZFTSXGCGSBRZXJQQCTZHGYQTJQQLZXJYLYLBCYAMCSTYLPDJBYREGKLZYZHLYSZQLZNWCZCLLWJQJJJKDGJZOLBBZPPGLGHTGZXYGHZMYCNQSYCYHBHGXKAMTX"
	"YXNBSKYZZGJZLQJDFCJXDYGJQJJPMGWGJJJPKQSBGBMMCJSSCLPQPDXCDYYKY[CJDDYYGYWRHJRTGZNYQLDKLJSZZGZQZJGDYKSHPZMTLCPWNJAFYZDJCNMWESCYGLBTZCGMSSLLYXQSXSBSJSBBSGGHFJLYPMZJNLYYWDQSHZXTYYWHMZYHYWDBXBTLMSYYYFSXJC[DXXLHJHF[SXZQHFZMZCZTQCXZXRTTDJHNNYZQQMNQDMMG[YDXMJGDHCDYZBFFALLZTDLTFXMXQZDNGWQDBDCZJDXBZGS"
	"QQDDJCMBKZFFXMKDMDSYYSZCMLJDSYNSBRSKMKMPCKLGDBQTFZSWTFGGLYPLLJZHGJ[GYPZLTCSMCNBTJBQFKTHBYZGKPBBYMTDSSXTBNPDKLEYCJNYDDYKZDDHQHSDZSCTARLLTKZLGECLLKJLQJAQNBDKKGHPJTZQKSECSHALQFMMGJNLYJBBTMLYZXDCJPLDLPCQDHZYCBZSCZBZMSLJFLKRZJSNFRGJHXPDHYJYBZGDLQCSEZGXLBLGYXTWMABCHECMWYJYZLLJJYHLG[DJLSLYGKDZPZXJ"
	"YYZLWCXSZFGWYYDLYHCLJSCMBJHBLYZLYCBLYDPDQYSXQZBYTDKYXJY[CNRJMPDJGKLCLJBCTBJDDBBLBLCZQRPPXJCJLZCSHLTOLJNMDDDLNGKAQHQHJGYKHEZNMSHRP[QQJCHGMFPRXHJGDYCHGHLYRZQLCYQJNZSQTKQJYMSZSWLCFQQQXYFGGYPTQWLMCRNFKKFSYYLQBMQAMMMYXCTPSHCPTXXZZSMPHPSHMCLMLDQFYQXSZYYDYJZZHQPDSZGLSTJBCKBXYQZJSGPSXQZQZRQTBDKYXZK"
	"HHGFLBCSMDLDGDZDBLZYYCXNNCSYBZBFGLZZXSWMSCCMQNJQSBDQSJTXXMBLTXZCLZSHZCXRQJGJYLXZFJPHYMZQQYDFQJJLZZNZJCDGZYGCTXMZYSCTLKPHTXHTLBJXJLXSCDQXCBBTJFQZFSLTJBTKQBXXJJLJCHCZDBZJDCZJDCPRNPQCJPFCZLCLZXZDMXMPHJSGZGSZZQLYLWTJPFSYASMCJBTZKYCWMYTCSJJLJCQLWZMALBXYFBPNLSFHTGJWEJJXXGLLJSTGSHJQLZFKCGNNNSZFDEQ"
	"FHBSAQTGYLBXMMYGSZLDYDQMJJRGBJTKGDHGKBLQKBDMBYLXWCXYTTYBKMRTJZXQJBHLMHMJJZMQASLDCYXYQDLQCAFYWYXQHZ";
	NSMutableString* result = [[[NSMutableString alloc] init] autorelease];
	int H, L, W;
	int i;
	int stringlen = [self length];
	int j;
	for (i = 0; i < stringlen - 1; i++) {
		H = (unsigned char) [self characterAtIndex:i + 0];
		L = (unsigned char) [self characterAtIndex:i + 1];
		if (H < 0xA1 || L < 0xA1) {
			 [result appendString:self];
			 continue;
		} else {
			W = (H - 160) * 100 + L - 160;
		}
		
		if (W > 1600 && W < 5590) {
			for (j = 22; j >= 0; j--) {
				if (W >= li_SecPosValue[j]) {
					char ch = lc_FirstLetter[j];
					[result appendString:[NSString stringWithFormat:@"%C", ch]];
					i ++;
					break;
				}
			}
			
			continue;
		} else {
			i++;
			W = (H - 160 - 56) * 94 + L - 161;
			if (W >= 0 && W <= 3007) {
				char ch = ls_SecondSecTable[W];
				[result appendString:[NSString stringWithFormat:@"%C", ch]];
			}
			else {
				char ch = (char) H;
				[result appendString:[NSString stringWithFormat:@"%C", ch]];
				
				ch = (char) L;
				[result appendString:[NSString stringWithFormat:@"%C", ch]];
			}
		}
	} 
	
	return result;*/
	
	NSString* pinyin = [NSString pinyinFromChiniseString:self];
	NSString* result = [pinyin substringToIndex:1];
	
	return result;
}

+ (NSString*) stringWithTime:(NSDate*)time isIncludeTime:(BOOL)isIncludeTime
{
	return [self stringWithTime:time isIncludeTime:isIncludeTime isDisplayTodayStr:YES];
}

+ (NSString*)stringWithTime:(NSDate*)time isIncludeTime:(BOOL)isIncludeTime isDisplayTodayStr:(BOOL)isDisplayTodayStr
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDateComponents* comp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:time];
	
	NSDate* currDate = [NSDate date];
	NSDateComponents* currComp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:currDate];
	
	NSMutableString* timeStr = [[NSMutableString alloc] init];
	if ([currComp year] == [comp year]
		&& [currComp month] == [comp month]
		&& [currComp day] == [comp day]
		&& isDisplayTodayStr) {
		
		[timeStr appendString:NSLocalizedString(@"Today", nil)];
	} else {
		[timeStr appendFormat:@"%d-%d-%d", [comp year], [comp month], [comp day]];
	}
	
	if (isIncludeTime)
		[timeStr appendFormat:@" %02d:%02d:%02d", [comp hour], [comp minute], [comp second]];
	
	return [timeStr autorelease];
}

+ (NSString*) stringWithTimeIntervalSince1970:(NSTimeInterval)interval isIncludeTime:(BOOL)isIncludeTime {
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
	return [[self class] stringWithTime:date isIncludeTime:isIncludeTime];
}

+ (NSString*) stringWithTime:(NSDate*)time {
	return [[self class] stringWithTime:time isIncludeTime:YES];
}

+ (NSString*) stringWithTimeIntervalSince1970:(NSTimeInterval)interval {
	return [[self class] stringWithTimeIntervalSince1970:interval isIncludeTime:YES];
}

@end
