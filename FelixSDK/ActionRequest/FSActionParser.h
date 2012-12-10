//
//  NSBaseParse.h
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "GDataXMLNode.h"
#import "NSDictionaryAdditions.h"

@class FSActionRequest;

typedef enum parseType
{
	JSON,
	XML
}ParseType;

@interface FSActionParser : NSObject {
	/**
	 * 解析方式 json
	 */
	
	/**
	 * 解析方式xml
	 */
	
	/**
	 * 解析类型，默认是json
	 */
	ParseType parseType;
	
	/**
	 * 如果是json解析，该对象有效
	 */
	
	/**
	 * 如果xml解析，该对象有效
	 */
	//GDataXMLDocument *doc;
	
	FSActionRequest*		_busi;
}
-(id)initParse:(ParseType)type;
-(BOOL)parse:(NSString*)data;
//1、public BaseParse(int type)。构造解析方法，参数为0表示为json解析，1表示为xml解析，默认下为json解析。
//2、protected  boolean Parse(byte[]data) 公用的解析接口，提供给基类重写，但是基类处理的时候先调用该方法super.Parse(data)。
//Data参数为字节数组也是OC里面的NSData。解析成功返回true，否则false。该方法会判断是解析json还是xml，
//如果是json则提供json基本的对象提供具体的解析使用。xml也一样。具体的解析抛给重写的BaseParse方法。

@property (nonatomic, assign) FSActionRequest* busi;

@end
