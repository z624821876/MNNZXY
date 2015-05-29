//
//  CustomScrollView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/22.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
