//
//  TPTestTableViewController.m
//  TPXMLParserExample
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPTestTableViewController.h"
#import "TPTestTableViewCell.h"
#import "TPTestModel.h"
#import "TPXMLParser.h"
#import "TPTestTag.h"

static NSString *const kReuseID = @"Cell";

@interface TPTestTableViewController ()
@property (nonatomic , copy) NSArray *allInfos;
@end

@implementation TPTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TPTestTableViewCell class] forCellReuseIdentifier:kReuseID];
#warning 调用TPXMLParser进行解析xml
    //使用block方式
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    [TPXMLParser parseXMLWithURLString:url.absoluteString objectClass:[TPTestModel class] objectFlag:@"news" response:^(NSArray *responseObjects) {
        NSLog(@"response:%@" , responseObjects);
        self.allInfos = responseObjects;
    }];
    [TPXMLParser parseXMLWithURLString:url.absoluteString objectClass:[TPTestTag class] objectFlag:@"count" response:^(NSArray *responseObjects) {
        TPTestTag *tag = responseObjects[0];
        NSLog(@"response:%@" , tag.count);
    }];
    //或者使用代理方法
    //并实现代理方法:- (void)xmlParser:(TPXMLParser *)xmlParser didParsedWithArray:(NSArray *)responseObjects
//    [TPXMLParser parseXMLWithURL:url objectClass:[TPTestModel class] objectFlag:@"jdt" delegate:self];
}

//#pragma mark TPXMLParserDelegate
//
//- (void)xmlParser:(TPXMLParser *)xmlParser didParsedWithArray:(NSArray *)responseObjects{
//#warning 在此接收解析的结果
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TPTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseID forIndexPath:indexPath];
    cell.testModel = self.allInfos[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - setter方法

- (void)setAllInfos:(NSArray *)allInfos{
    _allInfos = [allInfos copy];
    [self.tableView reloadData];
}

@end
