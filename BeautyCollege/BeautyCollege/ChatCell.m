//
//  ChatCell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/25.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell
{
    UITextView *_CalculateheightTV;
}
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mark = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _logo = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _image = [UIButton buttonWithType:UIButtonTypeCustom];
        _CalculateheightTV = [[UITextView alloc] init];
        [self addSubview:_CalculateheightTV];
        [self addSubview:_logo];
        [self addSubview:_mark];
        [self addSubview:_bgView];
        [self addSubview:_contentLabel];
        [self addSubview:_image];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mark.frame = CGRectZero;
    _bgView.frame = CGRectZero;
    _logo.frame = CGRectZero;
//    _image.frame = CGRectZero;
    _image.hidden = YES;
    _contentLabel.frame = CGRectZero;
    
    if (_date) {
        _contentLabel.frame = CGRectMake(0, 10, UI_SCREEN_WIDTH, 20);
        _contentLabel.text = _date;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor grayColor];
        return;
    }
    
    CGFloat labelMaxWidth = UI_SCREEN_WIDTH - (75 * 2.0) - 10;
    
//    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    NSMutableAttributedString *string = [MyTool textTransformEmoji:_model.content];
//    
//    CGSize size = [string boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:options  context:nil].size;
//    CGSize size2 = [_model.content boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size;
    
    
    NSMutableAttributedString *string = [MyTool textTransformEmoji:_model.content];
    _CalculateheightTV.attributedText = string;
    _CalculateheightTV.font = [UIFont systemFontOfSize:17];
    CGSize labelSize = [_CalculateheightTV sizeThatFits:CGSizeMake(labelMaxWidth, MAXFLOAT)];

//    if (size.height > size2.height) {
//        labelSize = size;
//    }else {
//        labelSize = size2;
//    }
    
    if (_model.url != nil && _model.url.length > 0) {
        labelSize = CGSizeMake(labelMaxWidth, labelMaxWidth);
    }
    
    if ([_model.status isEqualToString:@"1"]) {
        //自己
        _logo.frame = CGRectMake(UI_SCREEN_WIDTH - 60, 5, 50, 50);
        [MyTool setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:_logo];
        _logo.layer.cornerRadius = _logo.width / 2.0;
        _logo.layer.masksToBounds = YES;
        
        _mark.frame = CGRectMake(_logo.left - 15, _logo.top + 20, 10, 10);
        [_mark setImage:[UIImage imageNamed:@"msg_03_03.png"]];
        
        _bgView.frame = CGRectMake(_mark.left - labelSize.width - 10, _logo.top + 10, labelSize.width + 10, labelSize.height + 10);
        _bgView.backgroundColor = BaseColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        
        if (_model.url != nil && _model.url.length > 0) {
            _image.hidden = NO;
            _image.frame = CGRectMake(_bgView.left + 5, _bgView.top + 5, labelSize.width, labelSize.height);
            [MyTool setBtnImgWithURLStr:_model.url withplaceholderImage:nil withImgView:_image];
//            [MyTool setImgWithURLStr:_model.url withplaceholderImage:nil withImgView:_image];
            _image.imageView.contentMode = UIViewContentModeScaleAspectFill;
            _image.clipsToBounds = YES;
        }else {
            _contentLabel.frame = CGRectMake(_bgView.left + 5, _bgView.top + 5, labelSize.width, labelSize.height);
            _contentLabel.numberOfLines = 0;
            _contentLabel.textColor = [UIColor whiteColor];
            _contentLabel.textAlignment = NSTextAlignmentLeft;
            _contentLabel.font = [UIFont boldSystemFontOfSize:17];
            _contentLabel.attributedText = [MyTool textTransformEmoji:_model.content];
        }
    
    }else {
        //好友
        _logo.frame = CGRectMake(10, 5, 50, 50);
        [MyTool setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:_logo];
        _logo.layer.cornerRadius = _logo.width / 2.0;
        _logo.layer.masksToBounds = YES;
        
        _mark.frame = CGRectMake(_logo.right + 5, _logo.top + 20, 10, 10);
        [_mark setImage:[UIImage imageNamed:@"msg_05_03.png"]];
        
        _bgView.frame = CGRectMake(_mark.right, _logo.top + 10, labelSize.width + 10, labelSize.height + 10);
        _bgView.backgroundColor = BaseColor;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        
        if (_model.url != nil && _model.url.length > 0) {
            _image.hidden = NO;
            _image.frame = CGRectMake(_bgView.left + 5, _bgView.top + 5, labelSize.width, labelSize.height);
            [MyTool setBtnImgWithURLStr:_model.url withplaceholderImage:nil withImgView:_image];
            _image.imageView.contentMode = UIViewContentModeScaleAspectFill;
            _image.clipsToBounds = YES;
            
        }else {
        _contentLabel.frame = CGRectMake(_bgView.left + 5, _bgView.top + 5, labelSize.width, labelSize.height);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:17];
        _contentLabel.attributedText = [MyTool textTransformEmoji:_model.content];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
