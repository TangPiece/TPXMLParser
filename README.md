# TPXMLParser
只需调用一个类方法，即可将xml数据解析到对应的对象中，从此让xml解析和json解析一样简单

    //用block方式
    [TPXMLParser parseXMLWithURL:url objectClass:[CustomClass class] objectFlag:@"object element in .xml" response:^(NSArray *responseObjects) {
        //在这里处理解析好的数据，数据以对象的形式保存在数组中
    }];
    
    //或者使用代理方法
    //并实现代理方法:- (void)xmlParser:(TPXMLParser *)xmlParser didParsedWithArray:(NSArray *)responseObjects
    [TPXMLParser parseXMLWithURL:url objectClass:[TPTestModel class] objectFlag:@"jdt" delegate:self];
