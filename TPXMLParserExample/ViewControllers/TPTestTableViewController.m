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

static NSString *const kReuseID = @"Cell";

@interface TPTestTableViewController () <TPXMLParserDelegate>
@property (nonatomic , copy) NSArray *allInfos;
@end

@implementation TPTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[TPTestTableViewCell class] forCellReuseIdentifier:kReuseID];
#warning 调用TPXMLParser进行解析xml
    //通过url获取数据
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    [TPXMLParser parseXMLWithURL:url objectClass:[TPTestModel class] objectFlag:@"jdt" response:^(NSArray *responseObjects) {
        NSLog(@"response:%@" , responseObjects);
        self.allInfos = responseObjects;
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
