#import "URLHelper.h"

@implementation URLHelper

+ (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}


+ (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}


+ (NSString *)getURL:(NSString *)baseUrl 
	 queryParameters:(NSDictionary*)params {
    NSString* fullPath = [[baseUrl copy] autorelease];
	if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
	return fullPath;
}

+ (NSString *)getURL:(NSString *)baseUrl 
	 addQueryParameters:(NSDictionary*)params {
    NSString* fullPath = [[baseUrl copy] autorelease];
	if (params) {
        //fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
        NSString*base = fullPath;
        // Append base if specified.
        NSMutableString *str = [NSMutableString stringWithCapacity:0];
        if (base) {
            [str appendString:base];
        }
        
        // Append each name-value pair.
        if (params) {
            int i;
            NSArray *names = [params allKeys];
            for (i = 0; i < [names count]; i++) {
                if (i == 0 && YES) {
                    [str appendString:@"?"];
                } else if (i > 0) {
                    [str appendString:@"&"];
                }
                NSString *name = [names objectAtIndex:i];
                [str appendString:[NSString stringWithFormat:@"%@=%@", 
                                   name, [params objectForKey:name]]];
            }
        }
        fullPath = str;
    }
	return fullPath;
}

@end
