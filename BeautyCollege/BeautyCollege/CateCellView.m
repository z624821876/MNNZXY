//
//  CateCellView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/27.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CateCellView.h"
#import "CellView.h"

@implementation CateCellView

- (void)initWithModelArray:(NSArray *)array
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat width = (UI_SCREEN_WIDTH - 40) / 3.0;
    for (NSInteger i = 0; i < [array count]; i ++) {
        NSInteger x = i % 3;
        NSInteger y = i / 3;
        CellView *view = [[CellView alloc] initWithFrame:CGRectMake(10 + (width + 10) * x, 5 + (width + 20 + 10) * y, width, width + 20) WithData:array[i]];
        view.tag = i;
        [self addSubview:view];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
