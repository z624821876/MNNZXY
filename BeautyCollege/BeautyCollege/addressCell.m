//
//  addressCell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/7.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "addressCell.h"

@implementation addressCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 20, 10 + 60 + 15 * UI_scaleY + (30 + 5 * UI_scaleY) * 2 + 30 + 10 + 30)];
        [_img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)]];
        [self.contentView addSubview:_img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + 15, 40, 30)];
        label.textColor = [UIColor grayColor];
        label.text = @"地址";
        [self.contentView addSubview:label];
        
        _addlabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, 10, _img.width - label.right - 15 + 10, 60)];
        _addlabel.numberOfLines = 0;
        [self.contentView addSubview:_addlabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_img.left, _addlabel.bottom + 5 * UI_scaleY - 0.5, _img.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:lineView];
        
        _labelArray = [[NSMutableArray alloc] init];
        NSArray *array = @[@"邮编",@"姓名",@"电话"];
        for (NSInteger i = 0; i < 3; i ++) {
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom + 5 * UI_scaleY + (30 + 5 * UI_scaleY) * i, 40, 30)];
            label1.textColor = [UIColor grayColor];
            label1.text = array[i];
            [self.contentView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.right + 5, label1.top, _img.width - label1.right - 5, 30)];

            [self.contentView addSubview:label2];
            [_labelArray addObject:label2];
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_img.left, label1.bottom + 5 * UI_scaleY - 0.5, _img.width, 0.5)];
            lineView1.backgroundColor = [UIColor grayColor];
            [self.contentView addSubview:lineView1];

        }
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(20, _img.bottom - 30, 20, 20);
        [_selectBtn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectBtn];
        
        _deleteBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBnt.frame = CGRectMake(_img.width - 40, _img.bottom - 30, 20, 20);
        [_deleteBnt setImage:[UIImage imageNamed:@"ico_dustbin.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBnt];
    }

    return self;
}


- (void)layoutSubviews
{
    _addlabel.text = _model.address;
    UILabel *label1 = _labelArray[0];
    UILabel *label2 = _labelArray[1];
    UILabel *label3 = _labelArray[2];
    label1.text = _model.postcode;
    label2.text = _model.name;
    label3.text = _model.mobile;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
