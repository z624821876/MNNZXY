//
//  CustomCollectionCell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        self.titleLabel.backgroundColor = [UIColor grayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
@end
