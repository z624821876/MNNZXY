//
//  ChatCell.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/25.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (strong, nonatomic) UIImageView       *logo;
@property (strong, nonatomic) UIImageView       *mark;
@property (strong, nonatomic) UIView            *bgView;
@property (strong, nonatomic) UILabel           *contentLabel;
@property (strong, nonatomic) UIButton          *image;

@property (strong, nonatomic) BaseCellModel     *model;
@property (strong, nonatomic) NSString          *date;
@end
