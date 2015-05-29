
//
//  HomeworkCellView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "HomeworkCellView.h"

@implementation HomeworkCellView

- (instancetype)initWithFrame:(CGRect)frame Model:(BaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dateLable = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 80, 10, 70, 20)];
        self.dateLable.font = [UIFont systemFontOfSize:12];
        self.dateLable.text = model.date;
        [self addSubview:self.dateLable];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.dateLable.left - 10, 20)];
        
        self.titleLable.font = [UIFont systemFontOfSize:15];
        self.titleLable.text = model.title;
        [self addSubview:self.titleLable];
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
