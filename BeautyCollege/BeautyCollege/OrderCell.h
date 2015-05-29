//
//  OrderCell.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UIView

- (instancetype)initWithFrame:(CGRect)frame withModel:(BaseCellModel *)model;
- (void)changeDataWithModel:(BaseCellModel *)model;
@end
