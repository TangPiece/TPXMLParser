//
//  TPXMLParser.m
//  TPXMLParserExample
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPXMLParser.h"
#import <objc/runtime.h>
#import "TPRequestManager.h"

@interface TPXMLParser () <NSXMLParserDelegate>{
    struct {
        unsigned int isRespondSelector : 1;
    } _delegateFlags;
}

//解析xml数据到对象中
@property (nonatomic , copy) TPXMLParserBlock responseBlock; /**<block*/
@property (nonatomic , weak) id<TPXMLParserDelegate> delegate; /**<代理*/
@property (nonatomic , assign) Class objClass;
@property (nonatomic , copy) NSString *objFlag;

@property (nonatomic , copy) NSMutableArray *allObjsMutableArray;
@property (nonatomic , assign) dispatch_queue_t dispatchQueue;
@property (nonatomic , copy) NSArray *allPropertyNames;
@property (nonatomic , copy) NSString *tempPropertyName;
@property (nonatomic , strong) id tempNews;

//获取某个标签的值
@property (nonatomic , copy) NSString *tag;
@property (nonatomic , assign) BOOL findTag;
//@property (nonatomic , copy) NSMutableArray *allTagValuesArray;
@end

@implementation TPXMLParser

#pragma mark - life cycle

+ (void)parseXMLWithURLString:(NSString *)urlString objectClass:(Class)objClass objectFlag:(NSString *)objFlag delegate:(id<TPXMLParserDelegate>)delegate{
    [[self alloc] parseXMLWithURLString:urlString objectClass:objClass objectFlag:objFlag delegate:delegate];
}

+ (void)parseXMLWithURLString:(NSString *)urlString objectClass:(__unsafe_unretained Class)objClass objectFlag:(NSString *)objFlag response:(TPXMLParserBlock)response{
    [[self alloc] parseXMLWithURLString:urlString objectClass:objClass objectFlag:objFlag response:[response copy]];
}

+ (void)tagValueWithURLString:(NSString *)urlString tag:(NSString *)tag response:(TPXMLParserBlock)response{
    [[self alloc] tagValueWithURLString:urlString tag:tag response:[response copy]];
}

#pragma mark - parser object

- (void)parseXMLWithURLString:(NSString *)urlString objectClass:(Class)objClass objectFlag:(NSString *)objFlag delegate:(id<TPXMLParserDelegate>)delegate{
    NSAssert(objClass , @"TPXMLParser的objectClass不能为空");
    NSAssert(objFlag , @"TPXMLParser的objectFlag不能为空");
    NSAssert(delegate , @"TPXMLParser的delegate不能为空");
    self.objFlag = objFlag;
    self.objClass = objClass;
    self.allPropertyNames = [self tp_getAllPropertyNamesWithClass:self.objClass];
    self.delegate = delegate;
    [self parseXMLWithURLString:urlString];
}

- (void)parseXMLWithURLString:(NSString *)urlString objectClass:(__unsafe_unretained Class)objClass objectFlag:(NSString *)objFlag response:(TPXMLParserBlock)response{
    NSAssert(objClass , @"TPXMLParser的objectClass不能为空");
    NSAssert(objFlag , @"TPXMLParser的objectFlag不能为空");
//    NSAssert(response , @"TPXMLParser的block不能为空");
    self.objFlag = objFlag;
    self.objClass = objClass;
    self.allPropertyNames = [self tp_getAllPropertyNamesWithClass:self.objClass];
    self.responseBlock = response;
    [self parseXMLWithURLString:urlString];
}

#pragma mark - get tag value

- (void)tagValueWithURLString:(NSString *)urlString tag:(NSString *)tag response:(TPXMLParserBlock)response{
    NSAssert(tag , @"TPXMLParser的tag不能为空");
    self.tag = tag;
    self.findTag = NO;
    self.responseBlock = response;
    [self parseXMLWithURLString:urlString];
}

- (void)parseXMLWithURLString:(NSString *)urlString{
//    //并行队列
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_async(globalQueue, ^{
//        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//        xmlParser.delegate = self;
//        [xmlParser parse];
//    });
    
    [TPRequestManager url:urlString params:nil isPost:NO success:^(id responseObject) {
        NSXMLParser *xmlParser = (NSXMLParser *)responseObject;
        xmlParser.delegate = self;
        [xmlParser parse];
    } fail:^(NSError *error) {
        NSLog(@"TPXMLParser error:%@" , error);
    }];
}

#pragma mark - NSXMLParserDelegate
#pragma mark -

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:self.objFlag]) { //出现类名
        self.tempNews = [[self.objClass alloc] init];
    }else if ([self.allPropertyNames containsObject:elementName]) { //出现属性名
        self.tempPropertyName = elementName;
    }
    
    //发现某个标签
    if (self.tag && [elementName isEqualToString:self.tag]) {
        self.findTag = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (string.length != 1 && self.tempPropertyName) {
        //使用KVC对数组进行赋值
        [self.tempNews setValue:string forKeyPath:self.tempPropertyName];
    }
    
    //获取某个标签值
    if (self.findTag) {
        [self.allObjsMutableArray addObject:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     //出现类名
    if ([elementName isEqualToString:self.objFlag]) {
        //保存一个对象的完整信息
        [self.allObjsMutableArray addObject:self.tempNews];
        //将临时对象置空
        self.tempNews = nil;
    }else if ([self.allPropertyNames containsObject:elementName]) {
        //将临时属性名置空
        self.tempPropertyName = nil;
    }
    
    //标签结束
    if (self.tag && [elementName isEqualToString:self.tag]) {
        self.findTag = NO;
    }
}

/**
 *  xml文档解析到最后将解析结果回调
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //使用结构体优化判断
    if (_delegateFlags.isRespondSelector) {
        [self.delegate xmlParser:self didParsedWithArray:[self.allObjsMutableArray copy]];
    }else if (self.responseBlock) {
        self.responseBlock([self.allObjsMutableArray copy]);
    }
    self.allObjsMutableArray = nil;
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

- (NSMutableArray *)allObjsMutableArray{
    if (!_allObjsMutableArray) {
        _allObjsMutableArray = [NSMutableArray array];
    }
    return _allObjsMutableArray;
}

- (dispatch_queue_t)dispatchQueue{
    if (!_dispatchQueue) {
//        _dispatchQueue =  dispatch_get_global_queue(@"global", 1);
    }
    return _dispatchQueue;
}

@end
