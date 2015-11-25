//
//  TPXMLParser.m
//  TPXMLParserExample
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPXMLParser.h"
#import <objc/runtime.h>

@interface TPXMLParser () <NSXMLParserDelegate>{
    struct {
        unsigned int isRespondSelector : 1;
    } _delegateFlags;
}

@property (nonatomic , copy) TPXMLParserBlock responseBlock; /**<block*/
@property (nonatomic , weak) id<TPXMLParserDelegate> delegate; /**<代理*/
@property (nonatomic , assign) Class objClass;
@property (nonatomic , copy) NSString *objFlag;

@property (nonatomic , copy) NSMutableArray *allNewsMutableArray;
@property (nonatomic , copy) NSArray *allPropertyNames;
@property (nonatomic , copy) NSString *tempPropertyName;
@property (nonatomic , strong) id tempNews;
@end

@implementation TPXMLParser

+ (void)parseXMLWithURL:(NSURL *)url objectClass:(Class)objClass objectFlag:(NSString *)objFlag delegate:(id<TPXMLParserDelegate>)delegate{
    [[self alloc] parseXMLWithURL:url];
}

- (void)parseXMLWithURL:(NSURL *)url objectClass:(Class)objClass objectFlag:(NSString *)objFlag delegate:(id<TPXMLParserDelegate>)delegate{
    NSAssert(objClass , @"TPXMLParser的objectClass不能为空");
    NSAssert(objFlag , @"TPXMLParser的objectFlag不能为空");
    NSAssert(delegate , @"TPXMLParser的delegate不能为空");
    self.objFlag = objFlag;
    self.objClass = objClass;
    self.allPropertyNames = [self tp_getAllPropertyNamesWithClass:self.objClass];
    self.delegate = delegate;
    [self parseXMLWithURL:url];
}

+ (void)parseXMLWithURL:(NSURL *)url objectClass:(__unsafe_unretained Class)objClass objectFlag:(NSString *)objFlag response:(TPXMLParserBlock)response{
    [[self alloc] parseXMLWithURL:url objectClass:objClass objectFlag:objFlag response:response];
}

- (void)parseXMLWithURL:(NSURL *)url objectClass:(__unsafe_unretained Class)objClass objectFlag:(NSString *)objFlag response:(TPXMLParserBlock)response{
    NSAssert(objClass , @"TPXMLParser的objectClass不能为空");
    NSAssert(objFlag , @"TPXMLParser的objectFlag不能为空");
//    NSAssert(response , @"TPXMLParser的block不能为空");
    self.objFlag = objFlag;
    self.objClass = objClass;
    self.allPropertyNames = [self tp_getAllPropertyNamesWithClass:self.objClass];
    self.responseBlock = response;
    [self parseXMLWithURL:url];
}

- (void)parseXMLWithURL:(NSURL *)url{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    xmlParser.delegate = self;
    [xmlParser parse];
}

#pragma mark - NSXMLParserDelegate
#pragma mark -

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:self.objFlag]) { //出现类名
        self.tempNews = [[self.objClass alloc] init];
    }else if ([self.allPropertyNames containsObject:elementName]) { //出现属性名
        self.tempPropertyName = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (string.length != 1 && self.tempPropertyName) {
        //使用KVC对数组进行赋值
        [self.tempNews setValue:string forKeyPath:self.tempPropertyName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     //出现类名
    if ([elementName isEqualToString:self.objFlag]) {
        //保存一个对象的完整信息
        [self.allNewsMutableArray addObject:self.tempNews];
        //将临时对象置空
        self.tempNews = nil;
    }else if ([self.allPropertyNames containsObject:elementName]) {
        //将临时属性名置空
        self.tempPropertyName = nil;
    }
}

/**
 *  xml文档解析到最后将解析结果回调
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    if (_delegateFlags.isRespondSelector) {
        [self.delegate xmlParser:self didParsedWithArray:[self.allNewsMutableArray copy]];
    }else if (self.responseBlock) {
        self.responseBlock([self.allNewsMutableArray copy]);
    }
    self.allNewsMutableArray = nil;
}

#pragma mark - pravite methods

/**
 * 使用Runtime获取给定类的所有属性
 */
- (NSArray *)tp_getAllPropertyNamesWithClass:(Class)objClass{
    NSMutableArray *tempArray = [NSMutableArray array];
    ///存储属性的个数
    unsigned int propertyCount = 0;
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(objClass , &propertyCount);
    for (int i = 0 ; i < propertyCount ; i++ ) {
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        [tempArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return tempArray;
}

#pragma mark - setter方法

- (void)setDelegate:(id<TPXMLParserDelegate>)delegate{
    _delegate = delegate;
    _delegateFlags.isRespondSelector = [_delegate respondsToSelector:@selector(xmlParser:didParsedWithArray:)];
}

#pragma mark - getter方法

- (NSMutableArray *)allNewsMutableArray{
    if (!_allNewsMutableArray) {
        _allNewsMutableArray = [NSMutableArray array];
    }
    return _allNewsMutableArray;
}

@end
