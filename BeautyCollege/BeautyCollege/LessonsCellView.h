//
//  LessonsCellView.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonsCellView : UIView

@property (nonatomic, strong) UIImageView   *logo;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UIButton      *btn;

- (instancetype)initWithFrame:(CGRect)frame Model:(BaseCellModel *)model;
@end
