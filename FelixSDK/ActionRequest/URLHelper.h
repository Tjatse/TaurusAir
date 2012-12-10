#import <Foundation/Foundation.h>

@interface URLHelper : NSObject {    
}

+ (NSString *)getURL:(NSString *)baseUrl 
	 queryParameters:(NSDictionary*)params;

+ (NSString *)getURL:(NSString *)baseUrl 
  addQueryParameters:(NSDictionary*)params;

@end
