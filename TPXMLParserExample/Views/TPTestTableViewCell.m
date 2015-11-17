//
//  TPTestTableViewCell.m
//  TPXMLParserExample
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPTestTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TPTestModel.h"

@interface TPTestTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel; /**<标题*/
@property (nonatomic,strong)UILabel *timeLabel; /**<时间*/
@property (nonatomic,strong)UILabel *sourceLabel; /**<来源*/
@property (nonatomic,strong)UIImageView *photoView; /**<图片*/
@end

@implementation TPTestTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.sourceLabel];
        [self addSubview:self.photoView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    CGFloat imageHeight = frame.size.height;
    self.photoView.frame = CGRectMake(0 , 0 , imageHeight, imageHeight - 10);
    
    frame.size.height = frame.size.height * 0.5f;
    frame.origin.x = CGRectGetMaxX(self.photoView.frame);
    frame.size.width = frame.size.width - imageHeight;
    self.titleLabel.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(self.titleLabel.frame);
    frame.size.width = frame.size.width * 0.5f;
    self.timeLabel.frame = frame;
    
    frame.origin.x = CGRectGetMaxX(self.timeLabel.frame);
    self.sourceLabel.frame = frame;
}

- (void)setTestModel:(TPTestModel *)testModel{
    _testModel = testModel;
    self.titleLabel.text = _testModel.title;
    self.timeLabel.text = _testModel.date;
    self.sourceLabel.text = _testModel.source;
    NSString *imageName = _testModel.image;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"a"]];
}

#pragma mark - getter方法

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sourceLabel;
}

- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
    }
    return _photoView;
}

@end
