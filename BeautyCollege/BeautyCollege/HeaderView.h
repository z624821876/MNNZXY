//
//  HeaderView.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (strong, nonatomic) UIImageView   *headerImg;
@property (strong, nonatomic) UILabel       *nameLabel;
@property (strong, nonatomic) UILabel       *jobLabel;
@property (strong, nonatomic) UIButton      *button;

- (instancetype)initWithFrame:(CGRect)frame dataDic:(BaseCellModel *)model;
@end
