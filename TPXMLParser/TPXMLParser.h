//
//  TPXMLParser.h
//  TPXMLParserExample
//
//  Created by TangPiece on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

 /*********************
  使用时，只需将TPXMLParser文件夹引入工程中
  #import "TPXMLParser.h"
  调用下面任意一个类方法即可
  **********************/

#import <Foundation/Foundation.h>

@class TPXMLParser;

@protocol TPXMLParserDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param xmlParser       TPXMLParser对象
 *  @param responseObjects 数组保存解析结果
 */
- (void)xmlParser:(TPXMLParser *)xmlParser didParsedWithArray:(NSArray *)responseObjects;
@end

/**
 * block
 */
typedef void (^TPXMLParserBlock) (NSArray *responseObjects);


@interface TPXMLParser : NSObject
/**
 *  用代理的方式接收解析结果
 *
 *  @param url      获取xml的URL，可以是网络url，也可以是文件的url
 *  @param objClass 保存数据的类的Class
 *  @param objFlag  xml文档中表示一个对象的标记
 *  @param delegate 代理
 */
+ (void)parseXMLWithURL:(NSURL *)url objectClass:(Class)objClass objectFlag:(NSString *)objFlag delegate:(id<TPXMLParserDelegate>)delegate;

/**
 *  用block回调接收解析结果
 *
 *  @param url      获取xml的URL，可以是网络url，也可以是文件的url
 *  @param objClass 保存数据的类的Class
 *  @param objFlag  xml文档中表示一个对象的标记
 *  @param response 回调的block
 */
+ (void)parseXMLWithURL:(NSURL *)url objectClass:(Class)objClass objectFlag:(NSString *)objFlag response:(TPXMLParserBlock)response;
@end