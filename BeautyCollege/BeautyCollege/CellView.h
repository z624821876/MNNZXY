//
//  CellView.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/17.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//


@interface CellView : UIButton

@property (strong, nonatomic) UIView        *bgView;
@property (strong, nonatomic) UIImageView   *logoImg;
@property (strong, nonatomic) UILabel       *titleLabel2;
@property (strong, nonatomic) UILabel       *priceLabel;
@property (strong, nonatomic) UIButton      *countBtn;
@property (strong, nonatomic) UILabel       *discountPrice;
@property (strong, nonatomic) UIButton      *topBtn;
@property (strong, nonatomic) UIImageView   *lineimg1;

- (void)initGUI;
- (void)initGUI4WithData:(BaseCellModel *)model;
- (void)initGUIWithData:(BaseCellModel *)model;
- (void)initGUI2WithData:(BaseCellModel *)model;
- (void)initGUI3WithData:(BaseCellModel *)model;
- (instancetype)initWithFrame:(CGRect)frame WithData:(BaseCellModel *)model;
@end
