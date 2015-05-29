//
//  Shopcatcell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "Shopcatcell.h"

@implementation Shopcatcell
{
    UILabel *label1;
    UIImageView *img;
    UILabel *Label2;
    UILabel *label3;
    UILabel *Label4;
    UIView *lineView;
    UIImageView *typeImg;
}


- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorWithRGBA(215.0, 225.0, 227.0, 1);
        img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.contentView addSubview:img];
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 5, img.top, UI_SCREEN_WIDTH - 20 - img.right - 5 - 45, 40)];
        label1.numberOfLines = 2;
        label1.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label1];
        
        Label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom + 10, label1.width, 20)];
        Label2.textColor = [UIColor grayColor];
        Label2.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:Label2];
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(Label2.left, Label2.bottom + 10, (UI_SCREEN_WIDTH - 20 - img.right - 15) / 2.0, 20)];
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label3];
        
        Label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.right, label3.top, label3.width, label3.height)];
        Label4.font = [UIFont systemFontOfSize:15];
        Label4.textAlignment = NSTextAlignmentRight;
        Label4.textColor = BaseColor;
        [self.contentView addSubview:Label4];
        
        typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(label1.right + 5, label1.bottom + 10, 20, 20)];
        [typeImg setImage:[UIImage imageNamed:@"reg8.png"]];
        [self.contentView addSubview:typeImg];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0 , img.bottom + 9.5, UI_SCREEN_WIDTH - 20, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:lineView];
        
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.frame = CGRectMake(label1.left, label1.bottom + 15, 30, 30);
        [_reduceBtn setImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
        [_reduceBtn setTitle:@"r" forState:UIControlStateNormal];
        [_reduceBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_reduceBtn];
        
        _numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numBtn.userInteractionEnabled = NO;
        _numBtn.frame = CGRectMake(_reduceBtn.right, _reduceBtn.top, 50, _reduceBtn.height);
        _numBtn.layer.borderColor = BaseColor.CGColor;
        _numBtn.layer.borderWidth = 0.5;
        [_numBtn setTitle:@"1" forState:UIControlStateNormal];
        [_numBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_numBtn];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(_numBtn.right, _numBtn.top, 30, 30);
        [_addBtn setImage:[UIImage imageNamed:@"addbtnimg.png"] forState:UIControlStateNormal];
        [_addBtn setTitle:@"a" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_addBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *url ;
    if ([_model.logo hasPrefix:@"http"]) {
        url = _model.logo;
    }else {
        url = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
    }
    [img sd_setImageWithURL:[NSURL URLWithString:url]];
    label1.text = _model.title;
    Label2.text = _model.name;
    NSString *str1 = [NSString stringWithFormat:@"%@件",_model.count];
    NSString *str = [NSString stringWithFormat:@"数量:%@",str1];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:str1]];
    label3.attributedText = string;
    Label4.text = [NSString stringWithFormat:@"￥%@",_model.price];
    [_numBtn setTitle:_model.count forState:UIControlStateNormal];
    
    if (_model.type == 1) {
        
        [typeImg setImage:[UIImage imageNamed:@"reg8.png"]];
    }else {
        [typeImg setImage:[UIImage imageNamed:@"reg9.png"]];
    }
    
    if (_type == 1) {
        Label2.hidden = NO;
        label3.hidden = NO;
        _reduceBtn.hidden = YES;
        _numBtn.hidden = YES;
        _addBtn.hidden = YES;
    }else {
        Label2.hidden = YES;
        label3.hidden = YES;
        _reduceBtn.hidden = NO;
        _numBtn.hidden = NO;
        _addBtn.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
