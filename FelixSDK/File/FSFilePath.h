//
//  NSFilePath.h
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFilePath : NSObject 
{
	NSString*iFilePath;
}

@property(nonatomic,retain)NSString*iFilePath;

-(NSString*)pushPathNode:(NSString*)pathNode;//添加目录节点。返回的是添加之后的目录路径
-(BOOL)deletePathNode:(NSString*)pathNode;//删除目录节点，返回是否删除成功。
-(NSString*)addFileName:(NSString*)fileName;//添加文件名称。返回的是整个文件路径。
-(NSString*)fullFilePath;//获取整个文件的路径。返回的是整个文件路径

@end
