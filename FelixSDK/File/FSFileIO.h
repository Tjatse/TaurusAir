//
//  NSFileIO.h
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFileIO : NSObject 

+(NSInteger)read:(NSString*)fileFullPath withBuf:(NSData*)data atPos:(NSInteger)pos withSize:(NSInteger)size withSkip:(NSInteger)skip;
// int read(String fileFullPath, byte[] pBuf, int pos, int size, int skip)
//。类方法，对文件进行读写。fileFullPath为文件的路径，pBuf表示内存空间，读到的数据往里面存放。Pos表示从多少字节开始存放。Size表示读多少个字节，skip表示跳跃多少字节读取这个文件。返回读取的字节数。
+(NSInteger)readAll:(NSString*)fileFullPath withBuf:(NSData*)data;
//+ public int readAll(String fileFullPath，byte[] pBuf)。
//类方法，把该文件全部读取出来。参数fileFullPath表示文件路径，pBuf表示存储数据的字节数组。返回读取的大小。
+(BOOL)write:read:(NSString*)fileFullPath withBuf:(NSData*)data atPos:(NSInteger)pos withSize:(NSInteger)size withSkip:(NSInteger)skip;
//public boolean write(String fileFullPath, byte[] pBuf, int pos, int size, int skip)。
//写文件，如果该文件不存在，这创建路径和文件，支持多目录的创建。
//fileFullPath为文件的路径，pBuf表示需要写文件的数据。Pos表示从pBuf处多少字节开始。
//Size表示写多少个字节，skip表示跳跃多少字节写这个文件。写成功返回true，否则false。
+(NSInteger)getSize:(NSString*)fileFullPath;
//+ public int getSize(String fileFullPath)  获取文件的大小。fileFullPath为文件的路径，返回文件大小。
+(BOOL)fileExist:(NSString*)fileFullPath;
//+public  boolean fileExist(String fileFullPath)。判断文件是否存在。
+(BOOL)delFile:(NSString*)fileFullPath;
//+public  boolean delFile(String filePath) 
//删除文件，如果路径为目录则删除目录及目录底下所有内容。删除成功返回true，否则false。
+(BOOL)createDirectory:(NSString*)fileFullPath;
//+public  boolean createDirectory(String fileFullPath )创建目录，如果有三个目录节点都没有那就创建三个。
+(NSArray*)getDirectory:(NSString*)filePath;
//+public  File[] getDirectory(String filePath)，获取目录下面的文件数组。返回的是文件对象数组。

@end
