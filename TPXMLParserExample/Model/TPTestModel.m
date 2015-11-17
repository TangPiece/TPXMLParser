//
//  TPTestModel.m
//  TPXMLParserExample
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPTestModel.h"

@implementation TPTestModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"*** title:%@,date:%@,source:%@,image:%@, add:%@", self.title , self.date , self.source , self.image , self.add];
}

@end
