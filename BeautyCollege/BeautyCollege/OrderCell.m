//
//  OrderCell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
{
    UILabel *label1;
    UIImageView *img;
    UILabel *Label2;
    UILabel *label3;
    UILabel *Label4;
    UIView *lineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//        [img sd_setImageWithURL:[NSURL URLWithString:model.logo]];
        [self addSubview:img];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 5, img.top, frame.size.width - img.right - 15, 40)];
        label1.numberOfLines = 2;
        label1.font = [UIFont systemFontOfSize:15];
//        label1.text = model.title;
        [self addSubview:label1];
        
        Label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom + 10, label1.width, 20)];
        Label2.textColor = [UIColor grayColor];
        Label2.font = [UIFont systemFontOfSize:15];
//        Label2.text = model.name;
        [self addSubview:Label2];
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(Label2.left, Label2.bottom + 10, Label2.width / 2.0, 20)];
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:15];
        [self addSubview:label3];
        
        Label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.right, label3.top, label3.width, label3.height)];
        Label4.font = [UIFont systemFontOfSize:15];
        Label4.textAlignment = NSTextAlignmentRight;
        Label4.textColor = BaseColor;
//        Label4.text = [NSString stringWithFormat:@"￥%@",model.price];
        [self addSubview:Label4];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0 , img.bottom + 9.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)changeDataWithModel:(BaseCellModel *)model
{
    NSString *url ;
    if ([model.logo hasPrefix:@"http"]) {
        url = model.logo;
    }else {
        url = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,model.logo];
    }
            [img sd_setImageWithURL:[NSURL URLWithString:url]];
            label1.text = model.title;
            Label2.text = model.name;
            NSString *str1 = [NSString stringWithFormat:@"%@件",model.count];
            NSString *str = [NSString stringWithFormat:@"数量:%@",str1];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:str1]];
            label3.attributedText = string;
            Label4.text = [NSString stringWithFormat:@"￥%@",model.price];
}

- (instancetype)initWithFrame:(CGRect)frame withModel:(BaseCellModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [img sd_setImageWithURL:[NSURL URLWithString:model.logo]];
        [self addSubview:img];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 5, img.top, frame.size.width - img.right - 15, 40)];
        label1.numberOfLines = 2;
        label1.font = [UIFont systemFontOfSize:15];
        label1.text = model.title;
        [self addSubview:label1];
        
        Label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom + 10, label1.width, 20)];
        Label2.textColor = [UIColor grayColor];
        Label2.font = [UIFont systemFontOfSize:15];
        Label2.text = model.name;
        [self addSubview:Label2];
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(Label2.left, Label2.bottom + 10, Label2.width / 2.0, 20)];
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:15];
        NSString *str1 = [NSString stringWithFormat:@"%@件",model.count];
        NSString *str = [NSString stringWithFormat:@"数量:%@",str1];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
        [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:str1]];
        label3.attributedText = string;
        [self addSubview:label3];

        Label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.right, label3.top, label3.width, label3.height)];
        Label4.font = [UIFont systemFontOfSize:15];
        Label4.textAlignment = NSTextAlignmentRight;
        Label4.textColor = BaseColor;
        Label4.text = [NSString stringWithFormat:@"￥%@",model.price];
        [self addSubview:Label4];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0 , img.bottom + 9.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
