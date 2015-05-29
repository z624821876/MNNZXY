//
//  addressCell.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/7.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addressCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray        *labelArray;
@property (nonatomic, strong) UIImageView           *img;
@property (nonatomic, strong) UILabel               *addlabel;

@property (nonatomic, strong) BaseCellModel         *model;

@property (nonatomic, strong) UIButton              *selectBtn;
@property (nonatomic, strong) UIButton              *deleteBnt;

@end
