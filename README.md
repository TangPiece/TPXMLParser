# TPXMLParser
just one step for parsing xml data
只需调用一个类方法，即可将xml数据解析到对应的对象中，从此让xml解析和json解析一样简单
使用概述

    //用block方式
    [TPXMLParser parseXMLWithURL:url objectClass:[CustomClass class] objectFlag:@"object element in .xml" response:^(NSArray *responseObjects) {
        //在这里处理解析好的数据，数据以对象的形式保存在数组中
    }];
    
    //或者使用代理方法
    //并实现代理方法:- (void)xmlParser:(TPXMLParser *)xmlParser didParsedWithArray:(NSArray *)responseObjects
    [TPXMLParser parseXMLWithURL:url objectClass:[CustomClass class] objectFlag:@"object element in .xml" delegate:self];

提醒

    本框架纯ARC，例子需要Xcode7运行

期待

    如果在使用过程中遇到BUG，希望你能Issue我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
    如果在使用过程中发现功能不够用，希望你能Issue我，我非常想为这个框架增加更多好用的功能，谢谢
