//
//  HeaderView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame dataDic:(BaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {

        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _headerImg.layer.cornerRadius = 10;
        _headerImg.layer.masksToBounds = YES;
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
        [self addSubview:_headerImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headerImg.bottom, self.width, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = model.name;
        [self addSubview:_nameLabel];
        
        _jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom, self.width, 20)];
        _jobLabel.textColor = [UIColor whiteColor];
        _jobLabel.font = [UIFont systemFontOfSize:14];
        _jobLabel.text = model.city;
        [self addSubview:_jobLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom, self.width, 0.5)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        [self addSubview:_button];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
