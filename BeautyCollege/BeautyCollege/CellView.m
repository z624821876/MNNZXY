//
//  CellView.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/17.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CellView.h"

@implementation CellView

+ (id)buttonWithType:(UIButtonType)buttonType
{
    CellView *cellview = [super buttonWithType:buttonType];
    cellview.backgroundColor = [UIColor whiteColor];
    [cellview setBackgroundImage:[Util createImageWithColor:ColorWithRGBA(232.0, 120.0, 128.0, 1)] forState:UIControlStateHighlighted];
//    [cellview setBackgroundImage:[Util createImageWithColor:ColorWithRGBA(232.0, 120.0, 128.0, 1)] forState:UIControlStateSelected];
    cellview.layer.borderColor = [UIColor grayColor].CGColor;
    cellview.layer.borderWidth = 0.5;
    cellview.layer.masksToBounds = YES;
    [cellview initGUI];
    return cellview;
}

- (void)initGUI
{
    _logoImg = [[UIImageView alloc] init];
    [self addSubview:_logoImg];
    _titleLabel2 = [[UILabel alloc] init];
    _titleLabel2.font = [UIFont systemFontOfSize:13];
    _titleLabel2.numberOfLines = 2;
    _titleLabel2.tintColor = [UIColor grayColor];
    [self addSubview:_titleLabel2];
    
    _lineimg1 = [[UIImageView alloc] init];
    [_lineimg1 setImage:[UIImage imageNamed:@"虚线.png"]];
    [self addSubview:_lineimg1];

    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = BaseColor;
    [self addSubview:_priceLabel];
    _discountPrice = [[UILabel alloc] init];
    [self addSubview:_discountPrice];

    _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_countBtn];
    
}

- (void)initGUIWithData:(BaseCellModel *)model
{
    _logoImg.frame = CGRectMake(0, 0, self.width, self.width);
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    _titleLabel2.frame = CGRectMake(5, _logoImg.bottom, self.width - 10, 40);
    _titleLabel2.text = model.title;
    _lineimg1.frame = CGRectMake(0, _titleLabel2.bottom - 1, self.width, 1);
    
    _priceLabel.frame = CGRectMake(5, _titleLabel2.bottom, (self.width - 15) / 2.0, 30);
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    
    _countBtn.frame = CGRectMake(_priceLabel.right + 5, _titleLabel2.bottom, (self.width - 15) / 2.0, 30);
    NSString *str = [NSString stringWithFormat:@"%@人喜欢",model.count];
    NSRange range = [str rangeOfString:model.count];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
    [_countBtn setImage:[UIImage imageNamed:@"baobei_a.png"] forState:UIControlStateNormal];
    [_countBtn setAttributedTitle:string forState:UIControlStateNormal];

    
//    _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
//    [_logoImg sd_setImageWithURL:[NSURL URLWithString:model.logo]];
//    [self addSubview:_logoImg];
//    
//    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, _logoImg.bottom, self.width - 10, 40)];
//    _titleLabel2.font = [UIFont systemFontOfSize:13];
//    _titleLabel2.numberOfLines = 2;
//    _titleLabel2.tintColor = [UIColor grayColor];
//    _titleLabel2.text = model.title;
//    [self addSubview:_titleLabel2];
//    
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, _titleLabel2.bottom - 1, self.width, 1)];
//    [img setImage:[UIImage imageNamed:@"虚线.png"]];
//    [self addSubview:img];
//    
//    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _titleLabel2.bottom, (self.width - 15) / 2.0, 30)];
//    _priceLabel.textColor = [UIColor redColor];
//    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
//    [self addSubview:_priceLabel];
//    
//    _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _countBtn.frame = CGRectMake(_priceLabel.right + 5, _titleLabel2.bottom, (self.width - 15) / 2.0, 30);
//    _countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    NSString *str = [NSString stringWithFormat:@"%@人喜欢",model.count];
//    NSRange range = [str rangeOfString:model.count];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
//    [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
//    [_countBtn setImage:[UIImage imageNamed:@"baobei_a.png"] forState:UIControlStateNormal];
//    [_countBtn setAttributedTitle:string forState:UIControlStateNormal];
//    [self addSubview:_countBtn];
//    
//    self.backgroundColor = [UIColor whiteColor];
//    
//    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.topBtn.frame = self.bounds;
//    [self addSubview:self.topBtn];
//    
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 0.5;
//    self.layer.masksToBounds = YES;
}

- (void)initGUI2WithData:(BaseCellModel *)model
{
    
    _logoImg.frame = CGRectMake(0, 0, self.width, self.width);
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    _titleLabel2.frame = CGRectMake(5, _logoImg.bottom, self.width - 10, 40);
    _titleLabel2.text = model.title;
    _lineimg1.frame = CGRectMake(0, _titleLabel2.bottom - 1, self.width, 1);
        _countBtn.frame = CGRectMake(self.width - 30, _titleLabel2.bottom + 5, 20, 20);
        _countBtn.backgroundColor = BaseColor;
        _countBtn.layer.cornerRadius = 5;
        _countBtn.layer.masksToBounds = YES;
        [_countBtn setTitle:@"买买买" forState:UIControlStateNormal];

        _discountPrice.frame = CGRectMake(5, _titleLabel2.bottom, (_countBtn.left - 10) / 2.0, 30);
        _discountPrice.textColor = [UIColor redColor];
        _discountPrice.text = [NSString stringWithFormat:@"￥%@",model.discountPrice];
    
        _priceLabel.frame = CGRectMake(_discountPrice.right, _titleLabel2.bottom, _discountPrice.width, 30);
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = [UIColor grayColor];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:model.price attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor]}];
        _priceLabel.attributedText = string;
}
- (void)initGUI3WithData:(BaseCellModel *)model
{
    _logoImg.frame = CGRectMake(0, 0, self.width, self.width);
    [MyTool setImgWithURLStr:model.logo withplaceholderImage:nil withImgView:_logoImg];
    _titleLabel2.frame = CGRectMake(5, _logoImg.bottom, self.width - 10, 40);
    _titleLabel2.text = model.name;
    _lineimg1.frame = CGRectMake(0, _titleLabel2.bottom - 1, self.width, 1);
    _countBtn.frame = CGRectMake(self.width - 45, _titleLabel2.bottom + 5, 40, 20);
//    _countBtn.backgroundColor = BaseColor;
//    _countBtn.layer.cornerRadius = 5;
//    _countBtn.layer.masksToBounds = YES;
    _countBtn.tag = model.type;
    [_countBtn setImage:[UIImage imageNamed:@"shopCat-delete.png"] forState:UIControlStateNormal];
    
    _discountPrice.frame = CGRectMake(5, _titleLabel2.bottom, (_countBtn.left - 10) / 2.0, 30);
    _discountPrice.textColor = [UIColor redColor];
    _discountPrice.text = [NSString stringWithFormat:@"￥%@",model.discountPrice];
    
    _priceLabel.frame = CGRectMake(_discountPrice.right, _titleLabel2.bottom, _discountPrice.width, 30);
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor grayColor];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:model.price attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor]}];
    _priceLabel.attributedText = string;
}

- (instancetype)initWithFrame:(CGRect)frame WithData:(BaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        [_logoImg sd_setImageWithURL:[NSURL URLWithString:model.logo]];
        [self addSubview:_logoImg];
        
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, _logoImg.bottom, self.width - 10, 20)];
        _titleLabel2.font = [UIFont systemFontOfSize:13];
        _titleLabel2.tintColor = [UIColor grayColor];
        _titleLabel2.text = model.title;
        [self addSubview:_titleLabel2];

        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        
    }
    return self;
}

@end
