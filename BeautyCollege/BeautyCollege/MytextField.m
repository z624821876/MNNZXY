//
//  MytextField.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MytextField.h"

@implementation MytextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);//更好理解些
    return inset;
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}


@end
