//
//  LessonsCellView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "LessonsCellView.h"

@implementation LessonsCellView

- (instancetype)initWithFrame:(CGRect)frame Model:(BaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 55, 40)];
        NSString *str;
        self.logo.contentMode = UIViewContentModeScaleAspectFill;
        self.logo.clipsToBounds = YES;
        if ([model.logo hasPrefix:@"http"]) {
            
            str = model.logo;
        }else {
            str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,model.logo];
        }
        [self.logo sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
        [self addSubview:self.logo];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.logo.right + 10, 24, self.width - 20 - self.logo.right, 20)];
        self.nameLabel.text = model.title;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.nameLabel];
        
        UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        LineView.backgroundColor = [UIColor grayColor];
        LineView.alpha = 0.5;
        [self addSubview:LineView];
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = self.bounds;
        [self addSubview:_btn];
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
