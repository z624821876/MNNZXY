//
//  BaseCell.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/16.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "BaseCell.h"
#import "CellView.h"
#import "LessonsCellView.h"
#import "HomeworkCellView.h"
@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                [self initGUI];
    }
    return self;
}

- (void)initGUI
{
    self.label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.logoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame = CGRectZero;
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.frame = CGRectZero;
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3.frame = CGRectZero;
    
    self.cellView = [CellView buttonWithType:UIButtonTypeCustom];
    self.cellView2 = [CellView buttonWithType:UIButtonTypeCustom];
    self.cellView3 = [[CateCellView alloc] initWithFrame:CGRectZero];
    self.leftView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView = [[UIImageView alloc] init];
    self.img1 = [[UIImageView alloc] init];
    self.img2 = [[UIImageView alloc] init];
    self.img3 = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.img1];
    [self.contentView addSubview:self.img2];
    [self.contentView addSubview:self.img3];
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.cellView3];
    [self.contentView addSubview:self.logoImg];
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.label3];
    [self.contentView addSubview:self.btn1];
    [self.contentView addSubview:self.btn2];
    [self.contentView addSubview:self.btn3];
    [self.contentView addSubview:self.cellView];
    [self.contentView addSubview:self.cellView2];
    
    [self.label1 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.label2 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.label3 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.btn1 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.btn2 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.btn3 addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIView *view = object;
    view.hidden = NO;
}

- (void)dealloc
{
    [self.label1 removeObserver:self forKeyPath:@"frame"];
    [self.label2 removeObserver:self forKeyPath:@"frame"];
    [self.label3 removeObserver:self forKeyPath:@"frame"];
    [self.btn1 removeObserver:self forKeyPath:@"frame"];
    [self.btn2 removeObserver:self forKeyPath:@"frame"];
    [self.btn3 removeObserver:self forKeyPath:@"frame"];
}

- (void)initData
{
    self.bgView.frame = CGRectZero;
    self.label1.frame = CGRectZero;
    self.label2.frame = CGRectZero;
    self.label3.frame = CGRectZero;
    self.btn1.frame = CGRectZero;
    self.btn2.frame = CGRectZero;
    self.btn3.frame = CGRectZero;
    self.logoImg.frame = CGRectZero;
    self.cellView.frame = CGRectZero;
    self.cellView2.frame = CGRectZero;
    self.cellView3.frame = CGRectZero;
    self.cellView3.hidden = YES;
    self.leftView.frame = CGRectZero;
    self.img1.frame = CGRectZero;
    self.img2.frame = CGRectZero;
    
    
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initData];
    switch (_type - 10) {
        case 0:
        {
            self.logoImg.frame = CGRectMake(15, 10, 60 * 154 / 105, 60);
            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"course_titbg.png"]];
            
            self.btn1.frame = CGRectMake(self.width - 40, 25, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou1.png"] forState:UIControlStateSelected];
            
            self.label1.frame = CGRectMake(_logoImg.right + 5, _logoImg.top, _btn1.left - _logoImg.right - 5, 20);
            self.label1.font = [UIFont systemFontOfSize:14];
            self.label1.text = _model.name;
            
            self.label2.frame = CGRectMake(_logoImg.right + 5, _label1.bottom, _label1.width, 20);
            self.label2.text = _model.title;
            self.label2.font = [UIFont systemFontOfSize:14];
            
            self.label3.frame = CGRectMake(_logoImg.right + 5, _label2.bottom, _label2.width, 20);
            self.label3.text = [[_model.date componentsSeparatedByString:@" "] firstObject];
            self.label3.font = [UIFont systemFontOfSize:12];
        }
            break;
        case 1:
        {
            self.btn1.frame = CGRectMake(self.width - 40, 25, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou1.png"] forState:UIControlStateSelected];
            
            self.label1.frame = CGRectMake(15, 5, 130, 20);
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.text = _model.title;
            
            self.btn2.frame = CGRectMake(self.label1.right + 5, 0, 60, 30);
            [self.btn2 setImage:[UIImage imageNamed:@"ren"] forState:UIControlStateNormal];
            [self.btn2 setTitle:_model.name forState:UIControlStateNormal];
            self.btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.btn3.frame = CGRectMake(self.btn2.right + 10, 0, 60, 30);
            [self.btn3 setImage:[Util teacherImageWithLevel:_model.url] forState:UIControlStateNormal];
            [self.btn3 setTitle:_model.job forState:UIControlStateNormal];
            self.btn3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.label2.frame = CGRectMake(15, 40, 100, 20);
            NSString *str = [NSString stringWithFormat:@"评论：%@",_model.comment];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange range = [str rangeOfString:_model.comment];
            [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
            self.label2.font = [UIFont systemFontOfSize:14];
            self.label2.attributedText = string;
            
            self.label3.frame = CGRectMake(self.label2.right + 5, 40, 100, 20);
            self.label3.font = [UIFont systemFontOfSize:14];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model.date doubleValue] / 1000.0];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString *dateS = [Util dateIntervalStr:dateStr];
            NSString *dateStr2 = [[dateS componentsSeparatedByString:@" "] firstObject];
            NSRange range2 = [dateS rangeOfString:dateStr2];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dateS];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range2];
            self.label3.attributedText = string2;
        
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            self.logoImg.frame = CGRectMake(15, 10, 80, 60);
            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
            self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"course_titbg.png"] withImgView:self.logoImg];
            
            self.label1.frame = CGRectMake(_logoImg.right + 5, _logoImg.top, UI_SCREEN_WIDTH - _logoImg.right - 20,20);
            self.label1.font = [UIFont systemFontOfSize:14];
            self.label1.text = _model.title;
            
            self.label2.frame = CGRectMake(_label1.left, 50, 100, 20);
            self.label2.font = [UIFont systemFontOfSize:14];
            NSString *str1 = [NSString stringWithFormat:@"学生%@",_model.studentCount];
            NSRange range = [str1 rangeOfString:_model.studentCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str1];
    
            [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
            self.label2.attributedText = string;
            
            self.label3.frame = CGRectMake(_label2.right + 10, 50, 100, 20);
            self.label3.font = [UIFont systemFontOfSize:14];
            NSString *str2 = [NSString stringWithFormat:@"今日作业%@",_model.homeworkCount];
            NSRange range2 = [str2 rangeOfString:_model.homeworkCount];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range2];
            self.label3.attributedText = string2;
            
        }
            break;
        case 4:
        {
            CGFloat width = (UI_SCREEN_WIDTH - 30) / 2.0;
            self.cellView.frame = CGRectMake(10, 10, width, 70 + width);
            [self.cellView initGUIWithData:_model];
            self.cellView.tag = 10;
//            self.btn1.frame = self.cellView.frame;
//            [self.btn1 setImage:nil forState:UIControlStateNormal];
//            self.btn1.tag = 10;
//            [self.contentView bringSubviewToFront:self.btn1];
            if (_model2) {
                self.cellView2.frame = CGRectMake(self.cellView.right + 10, 10, width, width + 70);
                [self.cellView2 initGUIWithData:_model2];
                self.cellView2.tag = 11;
//                self.btn2.frame = self.cellView2.frame;
//                [self.btn2 setImage:nil forState:UIControlStateNormal];
//                self.btn2.tag = 11;
//                [self.contentView bringSubviewToFront:self.btn2];
            }
        }
            break;
            
        case 5:
        {
            CGFloat width = (UI_SCREEN_WIDTH - 30) / 2.0;
            self.cellView.frame = CGRectMake(10, 10, width, 70 + width);
            [self.cellView initGUI2WithData:[_modelArray objectAtIndex:0]];
            if ([_modelArray count] == 2) {
                self.cellView2.frame = CGRectMake(self.cellView.right + 10, 10, width, width + 70);
                [self.cellView2 initGUI2WithData:_modelArray[1]];
            }
        }
            break;
        case 6:
        {
            
            self.cellView3.hidden = NO;
            self.leftView.frame = CGRectMake(0, 0, 10, 30);
            self.leftView.backgroundColor = BaseColor;
            self.label1.frame = CGRectMake(self.leftView.right, 0, UI_SCREEN_WIDTH - 10, 30);
            self.label1.text = _model.title;
            CGFloat height = (UI_SCREEN_WIDTH / 3.0 + 20 + 10) * (([_model.cateArray count] + 2) / 3);
            self.cellView3.frame = CGRectMake(0, self.label1.bottom, UI_SCREEN_WIDTH, height);
            [self.cellView3 initWithModelArray:_model.cateArray];
            for (CellView *cell in self.cellView3.subviews) {
                [cell addTarget:self action:@selector(cellView3Click:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case 7:
        {
            self.logoImg.frame = CGRectMake(15, 10, 50, 50);
//            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];

            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"course_titbg.png"] withImgView:self.logoImg];
            self.logoImg.layer.cornerRadius = 5;
            self.logoImg.layer.masksToBounds = YES;
            
            self.label1.frame = CGRectMake(self.logoImg.right + 5, 30, UI_SCREEN_WIDTH - self.logoImg.right - 20, 30);
            self.label1.text = _model.name;
            self.label1.font = [UIFont systemFontOfSize:17];

        }
            break;
        case 8:
        {
            self.logoImg.frame = CGRectMake(15, 7, 30, 30);
//            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
//            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"course_titbg.png"]];
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"course_titbg.png"] withImgView:self.logoImg];
            self.logoImg.layer.cornerRadius = 5;
            self.logoImg.layer.masksToBounds = YES;
            
            self.btn2.frame = CGRectMake(UI_SCREEN_WIDTH - 60, 7, 40, 30);
            self.btn2.backgroundColor = BaseColor;
            self.btn2.titleLabel.font = [UIFont systemFontOfSize:15];
            self.btn2.layer.cornerRadius = 5;
            self.btn2.layer.masksToBounds = YES;
            [self.btn2 setTitle:@"添加" forState:UIControlStateNormal];
            
            self.label1.frame = CGRectMake(self.logoImg.right + 10,2,self.btn2.left - self.logoImg.right - 20,20);
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.text = _model.name;
            
            self.label2.frame = CGRectMake(self.label1.left, self.label1.bottom, self.label1.width, 20);
            self.label2.font = [UIFont systemFontOfSize:12];
        }
            break;
            
        case 9:
        {
            self.logoImg.frame = CGRectMake(15, 7, 30, 30);
//            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
//            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"course_titbg.png"]];
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"course_titbg.png"] withImgView:self.logoImg];
            self.logoImg.layer.cornerRadius = 5;
            self.logoImg.layer.masksToBounds = YES;
            
            self.btn1.frame = CGRectMake(UI_SCREEN_WIDTH - 120, 4, 100, 30);
            self.btn1.backgroundColor = [UIColor clearColor];
            [self.btn1 setImage:[UIImage imageNamed:@"yue_09.png"] forState:UIControlStateNormal];
            self.btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            NSString *cityName;
            if (_model.city) {
                cityName = _model.city;
            }else {
                cityName = @"未知";
            }
            [self.btn1 setTitle:cityName forState:UIControlStateNormal];
            self.btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            self.label1.frame = CGRectMake(self.logoImg.right + 10,7,self.btn1.left - self.logoImg.right - 20,30);
            self.label1.font = [UIFont systemFontOfSize:17];

            self.label1.text = _model.name;
            
        }
            break;

        case 10:
        {
            self.btn1.frame = CGRectMake(self.width - 40, 12, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou1.png"] forState:UIControlStateSelected];
            
            self.label3.frame = CGRectMake(self.btn1.left - 80, 12, 70, 20);
            self.label3.font = [UIFont systemFontOfSize:12];
            self.label3.textColor = [UIColor grayColor];
            self.label3.text = _model.date;
                
            self.label1.frame = CGRectMake(15, 12, self.label3.left - 15, 20);
            self.label1.textAlignment = NSTextAlignmentLeft;
            self.label1.text = _model.title;
            self.label1.textColor = BaseColor;
        }
            break;
        case 11:
        {
            self.btn1.frame = CGRectMake(self.width - 40, 12, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou1.png"] forState:UIControlStateSelected];
        
            self.label1.frame = CGRectMake(15, 12, self.btn1.left - 15, 20);
            self.label1.textColor = [UIColor blackColor];
            self.label1.textAlignment = NSTextAlignmentLeft;
            self.label1.text = _title;
            
        }

            break;
        case 12:
        {
            self.logoImg.frame = CGRectMake(10, 10, 80, 80);
            [self setImgWithURLStr:_model.logo withplaceholderImage:nil withImgView:self.logoImg];
            
            self.label1.frame = CGRectMake(self.logoImg.right + 10, 10, UI_SCREEN_WIDTH - self.logoImg.right - 20, 40);
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.textColor = [UIColor grayColor];
            self.label1.numberOfLines = 2;
            self.label1.text = _model.title;
            
            self.label2.frame = CGRectMake(self.logoImg.right + 10, self.label1.bottom, self.label1.width, 20);
            self.label2.font = [UIFont systemFontOfSize:15];

            self.label2.textColor = [UIColor grayColor];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",[_model.price doubleValue]]];
            [str setAttributes:@{NSForegroundColorAttributeName:BaseColor} range:NSMakeRange(0, 1)];
            self.label2.attributedText = str;
            
            self.label3.frame = CGRectMake(self.logoImg.right + 10, self.label2.bottom, self.label1.width, 20);
            self.label3.font = [UIFont systemFontOfSize:15];

            self.label3.text = @"已售0件";
            self.label3.textColor = [UIColor grayColor];
        }
            
            break;
        case 13:
        {
            self.label1.frame = CGRectMake(15, 12, UI_SCREEN_WIDTH - 30, 20);
            self.label1.textAlignment = NSTextAlignmentLeft;
            self.label1.textColor = [UIColor blackColor];
            self.label1.text = _title;

        }
            break;
        case 14:
        {
            self.label1.frame = CGRectMake(15, 12, 100, 20);
            self.label1.textAlignment = NSTextAlignmentLeft;
            self.label1.textColor = [UIColor blackColor];
            self.label1.text = _title;
            
            self.label2.frame = CGRectMake(UI_SCREEN_WIDTH - 165, 12, 150, 20);
            self.label2.textAlignment = NSTextAlignmentRight;
            self.label2.text = [NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0];
        }
            break;
        case 15:
        {
            self.label1.frame = CGRectMake(15, 25, 100, 30);
            self.label1.textColor = [UIColor grayColor];
            self.label1.text = _title;
            
            self.logoImg.frame = CGRectMake(self.width - 75, 10, 60, 60);
            [self setImgWithURLStr:_name withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:self.logoImg];
        }
            break;
        case 16:
        {
            self.label1.frame = CGRectMake(15, 10, 100, 20);
            self.label1.text = _title;
            self.label1.textColor = [UIColor grayColor];
            
            self.label2.frame = CGRectMake(self.label1.right + 5, 10, self.width - self.label1.right - 5 - 15, 20);
            self.label2.textColor = [UIColor grayColor];
            self.label2.textAlignment = NSTextAlignmentRight;
            self.label2.text = _name;
        }
            break;
        case 17:
        {
            self.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
            self.logoImg.frame = CGRectMake(15, 10, 80, 60);
            NSString *str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,_model.logo];
            self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"course_titbg.png"]];
            
            self.label1.frame = CGRectMake(_logoImg.right + 5, _logoImg.top, UI_SCREEN_WIDTH - _logoImg.right - 20,20);
            self.label1.font = [UIFont systemFontOfSize:14];
            self.label1.text = _model.title;
            
            self.label2.frame = CGRectMake(_label1.left, 50, 100, 20);
            self.label2.font = [UIFont systemFontOfSize:14];
            NSString *str1 = [NSString stringWithFormat:@"学生%@",_model.studentCount];
            NSRange range = [str1 rangeOfString:_model.studentCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str1];
            
            [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
            self.label2.attributedText = string;
            
            self.label3.frame = CGRectMake(_label2.right + 10, 50, 100, 20);
            self.label3.font = [UIFont systemFontOfSize:14];
            NSString *str2 = [NSString stringWithFormat:@"今日作业%@",_model.homeworkCount];
            NSRange range2 = [str2 rangeOfString:_model.homeworkCount];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range2];
            self.label3.attributedText = string2;
            
            self.btn1.frame = CGRectMake(UI_SCREEN_WIDTH - 60, (80 - 25) / 2.0, 40, 25);
            self.btn1.backgroundColor = BaseColor;
            self.btn1.layer.cornerRadius = 5;
            self.btn1.layer.masksToBounds = YES;
            self.btn1.userInteractionEnabled = NO;
            self.btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn1 setTitle:@"举手" forState:UIControlStateNormal];
        }
            break;
        case 18:
        {
            self.bgView.frame = CGRectMake(0, 10, UI_SCREEN_WIDTH, 80);
            self.bgView.image = [UIImage imageNamed:@"coursebg_16.png"];
            
            self.logoImg.frame = CGRectMake(15, 0, 50, 50);
            self.logoImg.layer.cornerRadius = 25;
            self.logoImg.layer.masksToBounds = YES;
            
//            self.logoImg.
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:self.logoImg];
            
            NSString *dateStr = [Util MNdateIntervalStr:_model.date];

            
            NSString *labelStr = [NSString stringWithFormat:@"评论 %@   %@",_model.commentCount,dateStr];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelStr];
            if ([labelStr rangeOfString:@"."].location != NSNotFound) {
                NSLog(@"%lu",(unsigned long)[labelStr rangeOfString:@"."].location);
                NSRange range = NSMakeRange(3, [labelStr rangeOfString:@"."].location - 3);
                [string deleteCharactersInRange:NSMakeRange([labelStr rangeOfString:@"."].location, 1)];
                [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:range];
            }else {
                [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:NSMakeRange(3, string.length - 3)];
            }
            CGFloat width = [labelStr boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.frame = CGRectMake(UI_SCREEN_WIDTH - width - 15, 20, width + 10, 20);
            self.label1.attributedText = string;
            
            self.label2.frame = CGRectMake(self.logoImg.right + 5, 15, self.label1.left - self.logoImg.right - 10, 30);
            
#pragma mark -- 正则匹配  文字改图片
//            NSString *imgStr = _model.title;
            self.label2.attributedText = [MyTool textTransformEmoji:_model.title];

    //            self.label3.frame = CGRectMake(self.logoImg.right + 5, self.label2.bottom + 10, <#CGFloat width#>, <#CGFloat height#>);
            
            
            if ([_model.catId integerValue] == [[User shareUser].userId integerValue]) {
                self.btn3.frame = CGRectMake(UI_SCREEN_WIDTH - 30, self.label2.bottom + 20, 20, 20);
                [self.btn3 setImage:[UIImage imageNamed:@"shopCat-delete.png"] forState:UIControlStateNormal];
                self.btn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                self.img1.frame = CGRectMake(self.btn3.left - 30, self.label2.bottom + 20, 20, 20);
            }else {
                self.img1.frame = CGRectMake(UI_SCREEN_WIDTH - 30, self.label2.bottom + 20, 20, 20);

            }
            if ([_model.collectId isEqualToString:@"0"]) {
                
                [self.img1 setImage:[UIImage imageNamed:@"baobei_b.png"]];

            }else {
                [self.img1 setImage:[UIImage imageNamed:@"work_03.png"]];

            }
            
            CGFloat width2 = [_model.likeCount boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            
            
            self.btn1.frame = CGRectMake(self.img1.left - 20 - width2 - 10, self.img1.top, width2 + 30, 20);
            self.btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btn1 setTitle:_model.likeCount forState:UIControlStateNormal];
            if ([_model.likeId isEqualToString:@"0"]) {
                [self.btn1 setImage:[UIImage imageNamed:@"xin.png"] forState:UIControlStateNormal];
            }else {
                [self.btn1 setImage:[UIImage imageNamed:@"作业-心.png"] forState:UIControlStateNormal];
            }
            self.btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            CGFloat width3 = [_model.name boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            if (width3 > (self.btn1.left - self.logoImg.right - 5 - 20)) {
                self.label3.frame = CGRectMake(self.logoImg.right + 5, self.img1.top, self.btn1.left - self.logoImg.right - 5 - 20, 20);
            }else {
                self.label3.frame = CGRectMake(self.logoImg.right + 5, self.img1.top, width3, 20);
            }
            self.label3.text = _model.name;
            self.label3.textColor = [UIColor grayColor];
            self.label3.font = [UIFont systemFontOfSize:15];
            
            self.btn2.frame = CGRectMake(self.label3.right + 5, self.label3.top, 20, 20);
            [self.btn2 setImage:[Util sexImageWithNSString:_model.sex] forState:UIControlStateNormal];
            self.btn2.contentMode = UIViewContentModeScaleAspectFit;
            
            self.img2.frame = CGRectMake(self.btn2.right + 10, self.label3.top, 20, 20);
            [self.img2 setImage:[Util studentImageWithLevel:_model.level]];
            self.img2.contentMode = UIViewContentModeScaleAspectFit;
        }
            break;
        case 19:
        {
            self.bgView.frame = CGRectMake(0, 10, UI_SCREEN_WIDTH, 80);
            self.bgView.image = [UIImage imageNamed:@"coursebg_16.png"];
            
            self.logoImg.frame = CGRectMake(15, 0, 50, 50);
            self.logoImg.layer.cornerRadius = 25;
            self.logoImg.layer.masksToBounds = YES;
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:self.logoImg];
            
            NSString *dateStr = [Util MNdateIntervalStr:_model.date];
            
            
            NSString *labelStr = [NSString stringWithFormat:@"评论 %@   %@",_model.commentCount,dateStr];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelStr];
            if ([labelStr rangeOfString:@"."].location != NSNotFound) {
                NSLog(@"%lu",(unsigned long)[labelStr rangeOfString:@"."].location);
                NSRange range = NSMakeRange(3, [labelStr rangeOfString:@"."].location - 3);
                [string deleteCharactersInRange:NSMakeRange([labelStr rangeOfString:@"."].location, 1)];
                [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:range];
            }else {
                [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:NSMakeRange(3, string.length - 3)];
            }
            CGFloat width = [labelStr boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.frame = CGRectMake(UI_SCREEN_WIDTH - width - 15, 20, width + 10, 20);
            self.label1.attributedText = string;
            
            self.label2.frame = CGRectMake(self.logoImg.right + 5, 15, self.label1.left - self.logoImg.right - 10, 20);
            
#pragma mark -- 正则匹配  文字改图片
//            NSString *imgStr = _model.title;
//            NSMutableAttributedString *imgStr1 = [[NSMutableAttributedString alloc] initWithString:imgStr];
//            NSString *pattern = @"f0[0-9][0-9]";
//            NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//            NSArray *resultArray = [re matchesInString:imgStr options:0 range:NSMakeRange(0, imgStr.length)];
//            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
//            for(NSTextCheckingResult *match in resultArray) {
//                NSRange range = [match range];
//                NSString *imgName = [imgStr substringWithRange:range];
//                //新建文字附件来存放我们的图片
//                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//                //给附件添加图片
//                textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
//                
//                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
//                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
//                [imageDic setObject:imageStr forKey:@"image"];
//                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
//                //把字典存入数组中
//                [imageArray addObject:imageDic];
//                
//            }
//            
//            for (NSInteger i = imageArray.count -1; i >= 0; i--)
//            {
//                NSDictionary *rangeDic = imageArray[i];
//                NSRange range22 = [[rangeDic objectForKey:@"range"] rangeValue];
//                //进行替换
//                [imgStr1 replaceCharactersInRange:range22 withAttributedString:[rangeDic objectForKey:@"image"]];
//            }
            self.label2.attributedText = [MyTool textTransformEmoji:_model.title];
            //            self.label2.text = _model.title;
            
            
            //            self.label3.frame = CGRectMake(self.logoImg.right + 5, self.label2.bottom + 10, <#CGFloat width#>, <#CGFloat height#>);
            
            if ([_model.catId integerValue] == [[User shareUser].userId integerValue]) {
                self.btn3.frame = CGRectMake(UI_SCREEN_WIDTH - 30, self.label2.bottom + 20, 20, 20);
                [self.btn3 setImage:[UIImage imageNamed:@"shopCat-delete.png"] forState:UIControlStateNormal];
                self.btn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                self.img1.frame = CGRectMake(self.btn3.left - 20, self.label2.bottom + 20, 20, 20);
            }else {
                self.img1.frame = CGRectMake(UI_SCREEN_WIDTH - 30, self.label2.bottom + 20, 20, 20);
            }
            
            [self.img1 setImage:[UIImage imageNamed:@"course_25.png"]];

            self.img2.frame = CGRectMake(self.img1.left - 20, self.img1.top, 20, 20);
            
            
            if ([_model.collectId isEqualToString:@"0"]) {
                
                [self.img2 setImage:[UIImage imageNamed:@"baobei_b.png"]];
            }else {
                [self.img2 setImage:[UIImage imageNamed:@"work_03.png"]];
                
            }
            
            CGFloat width2 = [_model.likeCount boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            self.btn1.frame = CGRectMake(self.img2.left - 20 - width2 - 10, self.img1.top, width2 + 30, 20);
            self.btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btn1 setTitle:_model.likeCount forState:UIControlStateNormal];
            
            if ([_model.likeId isEqualToString:@"0"]) {
                [self.btn1 setImage:[UIImage imageNamed:@"xin.png"] forState:UIControlStateNormal];
                
            }else {
                [self.btn1 setImage:[UIImage imageNamed:@"作业-心.png"] forState:UIControlStateNormal];
            }
            self.btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            CGFloat width3 = [_model.name boundingRectWithSize:CGSizeMake(100000, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            if (width3 > (self.btn1.left - self.logoImg.right - 5 - 20)) {
                self.label3.frame = CGRectMake(self.logoImg.right + 5, self.img1.top, self.btn1.left - self.logoImg.right - 5 - 20, 20);
            }else {
                self.label3.frame = CGRectMake(self.logoImg.right + 5, self.img1.top, width3, 20);
            }
            self.label3.text = _model.name;
            self.label3.textColor = [UIColor grayColor];
            self.label3.font = [UIFont systemFontOfSize:15];
            
            self.btn2.frame = CGRectMake(self.label3.right + 5, self.label3.top, 20, 20);
            [self.btn2 setImage:[Util sexImageWithNSString:_model.sex] forState:UIControlStateNormal];
            self.btn2.contentMode = UIViewContentModeScaleAspectFit;
            
            self.img3.frame = CGRectMake(self.btn2.right + 10, self.label3.top, 20, 20);
            self.img3.contentMode = UIViewContentModeScaleAspectFit;
            [self.img3 setImage:[Util studentImageWithLevel:_model.level]];
        }
            break;
        case 20:
        {
            self.bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, self.height);
            self.bgView.image = [[UIImage imageNamed:@"coursebg_16.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
            
            self.label1.frame = CGRectMake(10, 10, 100, 30);
            self.label1.textAlignment = NSTextAlignmentCenter;
            self.label1.font = [UIFont boldSystemFontOfSize:17];
            self.label1.text = self.title;
            self.label2.frame = CGRectMake(10, self.label1.bottom + 10, 100, 30);
            self.label2.textAlignment = NSTextAlignmentCenter;
            self.label2.font = [UIFont boldSystemFontOfSize:25];
            self.label2.textColor = BaseColor;
            self.label2.text = self.name;
            
            self.btn1.frame = CGRectMake(UI_SCREEN_WIDTH - 40, 5, 30, 15);
            [self.btn1 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
            
            for (NSInteger i = 0; i < [_modelArray count]; i ++) {
                LessonsCellView *view = [[LessonsCellView alloc] initWithFrame:CGRectMake(self.label2.right + 20, 20 + 54 * i, self.width - self.label2.right - 30, 54) Model:_modelArray[i]];
                view.btn.tag = i;
                [view.btn addTarget:self action:@selector(lessonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:view];
            }
        }
            break;
        case 21:
        {
            self.bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, self.height);
            self.bgView.image = [[UIImage imageNamed:@"coursebg_16.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
            
            self.label1.frame = CGRectMake(10, 10, 100, 30);
            self.label1.textAlignment = NSTextAlignmentCenter;
            self.label1.font = [UIFont boldSystemFontOfSize:17];
            self.label1.text = self.title;
            self.label2.frame = CGRectMake(10, self.label1.bottom + 10, 100, 30);
            self.label2.textAlignment = NSTextAlignmentCenter;
            self.label2.font = [UIFont boldSystemFontOfSize:25];
            self.label2.textColor = BaseColor;
            self.label2.text = self.name;
//            _btnArray = [[NSMutableArray alloc] initWithCapacity:[_modelArray count]];
            self.btn1.frame = CGRectMake(UI_SCREEN_WIDTH - 40, 5, 30, 15);
            [self.btn1 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];

            for (NSInteger i = 0; i < [_modelArray count]; i ++) {
                HomeworkCellView *view = [[HomeworkCellView alloc] initWithFrame:CGRectMake(self.label2.right + 20, 20 + 30 * i, self.width - self.label2.right - 30, 30) Model:_modelArray[i]];
                view.btn.tag = i;
                [view.btn addTarget:self action:@selector(lessonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:view];
            }
        }
            break;
            
        case 22:
        {
            self.logoImg.frame = CGRectMake(10, 7, 30, 30);
            self.logoImg.layer.cornerRadius = 5;
            self.logoImg.layer.masksToBounds = YES;
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:self.logoImg];
            
            self.btn1.frame = CGRectMake(self.width - 40, 12, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou.png"] forState:UIControlStateNormal];
            [self.btn1 setImage:[UIImage imageNamed:@"jiantou1.png"] forState:UIControlStateSelected];
            
            self.label1.frame = CGRectMake(self.logoImg.right + 10, 2, self.btn1.left - self.logoImg.right - 20, 20);
            self.label1.textAlignment = NSTextAlignmentLeft;
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.text = _model.name;
            
            self.label3.frame = CGRectMake(self.label1.left, self.label1.bottom, self.label1.width, 20);
            self.label3.font = [UIFont systemFontOfSize:12];
//            self.label3.textColor = [UIColor grayColor];
            self.label3.attributedText = [MyTool textTransformEmoji:_model.lastMessage];
            
            if ([_model.count integerValue] > 0) {
                self.label1.textColor = BaseColor;
                self.label3.textColor = BaseColor;
            }else {
                self.label1.textColor = [UIColor blackColor];
                self.label3.textColor = [UIColor blackColor];
            }
            
        }
            break;
            
        case 23:
        {
            self.logoImg.frame = CGRectMake(10, 10, 100, 100);
            [self setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:self.logoImg];
            
            self.label1.frame = CGRectMake(self.logoImg.right + 5, self.logoImg.top, UI_SCREEN_WIDTH - self.logoImg.right - 15, 40);
            self.label1.numberOfLines = 2;
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.text = _model.title;
            
            self.label2.frame = CGRectMake(_label1.left, _label1.bottom + 10, _label1.width, 20);
            
            _label2.textColor = [UIColor grayColor];
            _label2.font = [UIFont systemFontOfSize:15];
            _label2.text = _model.name;
            
            self.label3.frame = CGRectMake(_label2.left, _label2.bottom + 10, _label2.width / 2.0, 20);
            self.label3.textColor = [UIColor grayColor];
            self.label3.font = [UIFont systemFontOfSize:15];
            NSString *str1 = [NSString stringWithFormat:@"%@件",_model.count];
            NSString *str = [NSString stringWithFormat:@"数量:%@",str1];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:str1]];
            self.label3.attributedText = string;
            
            self.btn1.frame = CGRectMake(_label3.right, _label3.top, _label3.width, _label3.height);
            _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            _btn1.titleLabel.textAlignment = NSTextAlignmentRight;
            [_btn1 setTitle:[NSString stringWithFormat:@"￥%@",_model.price] forState:UIControlStateNormal];
            [_btn1 setTitleColor:BaseColor forState:UIControlStateNormal];
            
            _img1.frame = CGRectMake(0, self.logoImg.bottom + 9.5, UI_SCREEN_WIDTH, 0.5);
            _img1.backgroundColor = [UIColor grayColor];
        }
            break;
        case 24:
        {
            NSMutableAttributedString *string = [MyTool textTransformEmoji:_title];
            self.label1.attributedText = string;
            self.label1.font = [UIFont systemFontOfSize:17];
            self.label1.numberOfLines = 0;
//            self.label1.adjustsFontSizeToFitWidth = YES;
            self.label1.frame = CGRectMake(10, 5, UI_SCREEN_WIDTH - 20, self.height - 10);
        }
            break;
        case 25:
        {
            self.img1.frame = CGRectMake(10, 5, UI_SCREEN_WIDTH - 20, UI_SCREEN_WIDTH - 20);
            self.img1.contentMode = UIViewContentModeScaleAspectFit;
//            self.img1.clipsToBounds = YES;
            [self setImgWithURLStr:_title withplaceholderImage:nil withImgView:self.img1];
        }
            break;
        case 26:
        {
            self.bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 80);
            self.bgView.image = [UIImage imageNamed:@"coursebg_16.png"];
            
            self.btn1.frame = CGRectMake(self.width - 40, 25, 20, 20);
            [self.btn1 setImage:[UIImage imageNamed:@"shopCat-delete.png"] forState:UIControlStateNormal];
            
            self.label1.frame = CGRectMake(15, 5, 150, 20);
            self.label1.font = [UIFont systemFontOfSize:15];
            self.label1.attributedText = [MyTool textTransformEmoji:_model.title];
            
            self.btn2.frame = CGRectMake(self.label1.right + 5, 0, 80, 30);
            [self.btn2 setImage:[UIImage imageNamed:@"ren"] forState:UIControlStateNormal];
            [self.btn2 setTitle:_model.name forState:UIControlStateNormal];
            self.btn2.titleLabel.font = [UIFont systemFontOfSize:12];
            self.btn2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.btn3.frame = CGRectMake(self.btn2.right + 10, 0, 60, 30);
            [self.btn3 setImage:[Util teacherImageWithLevel:_model.level] forState:UIControlStateNormal];
            [self.btn3 setTitle:_model.job forState:UIControlStateNormal];
            self.btn3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.label2.frame = CGRectMake(15, 40, 100, 20);
            NSString *str = [NSString stringWithFormat:@"评论：%@",_model.commentCount];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange range = [str rangeOfString:_model.commentCount];
            [string setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range];
            self.label2.font = [UIFont systemFontOfSize:14];
            self.label2.attributedText = string;
            
            self.label3.frame = CGRectMake(self.label2.right + 5, 40, 100, 20);
            self.label3.font = [UIFont systemFontOfSize:14];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model.date doubleValue] / 1000.0];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString *dateS = [Util dateIntervalStr:dateStr];
            NSString *dateStr2 = [[dateS componentsSeparatedByString:@" "] firstObject];
            NSRange range2 = [dateS rangeOfString:dateStr2];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dateS];
            [string2 setAttributes:@{NSForegroundColorAttributeName:[Util uiColorFromString:@"#e1008c"]} range:range2];
            self.label3.attributedText = string2;
        }
            break;
        case 27:
        {
            CGFloat width = (UI_SCREEN_WIDTH - 30) / 2.0;
            self.cellView.frame = CGRectMake(10, 10, width, 70 + width);
            [self.cellView initGUI3WithData:[_modelArray objectAtIndex:0]];
            if ([_modelArray count] == 2) {
                self.cellView2.frame = CGRectMake(self.cellView.right + 10, 10, width, width + 70);
                [self.cellView2 initGUI3WithData:_modelArray[1]];
            }
        }
            break;
        case 28:
        {
            self.logoImg.frame = CGRectMake(10, 10, 100, 100);
            [MyTool setImgWithURLStr:_model.logo withplaceholderImage:nil withImgView:self.logoImg];
        
            self.label1.frame = CGRectMake(self.logoImg.right + 10, 10, UI_SCREEN_WIDTH - self.logoImg.right - 20, 40);
            self.label1.text = _model.name;
            self.label1.textColor = [UIColor grayColor];
            self.label1.numberOfLines = 0;
            
            self.label2.frame = CGRectMake(self.label1.left, self.label1.bottom + 10, self.label1.width, 20);
            self.label2.textColor = BaseColor;
            self.label2.font = [UIFont systemFontOfSize:15];
            self.label2.text = [NSString stringWithFormat:@"￥%.2f",[_model.price doubleValue]];
            
            self.label3.frame = CGRectMake(self.label1.left, self.label2.bottom + 10, self.label1.width, 20);
            self.label3.textColor = [UIColor grayColor];
            self.label3.text = [NSString stringWithFormat:@"已售%@件",_model.buyedCount];
            
        }
            break;
        case 29:
        {
            self.cellView.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, (UI_SCREEN_WIDTH - 20) + 70);
            [self.cellView initGUI4WithData:_model];
            
        }
            break;
        case 30:
        {
            self.logoImg.frame = CGRectMake(10, 10, 60, 60);
            self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
            [MyTool setImgWithURLStr:_model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:_logoImg];
            
            CGFloat widht = [_model.name boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - self.logoImg.right - 20 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.width;
            
            self.label1.frame = CGRectMake(self.logoImg.right + 10, 10, widht, 30);
            self.label1.textColor = BaseColor;
            self.label1.font = [UIFont systemFontOfSize:18];
            self.label1.text = _model.name;
            
            self.img1.frame = CGRectMake(self.label1.right + 10, 10, 30, 30);
            [self.img1 setImage:[Util studentImageWithLevel:_model.level]];
            self.img1.contentMode = UIViewContentModeScaleAspectFit;
            
            self.label2.frame = CGRectMake(self.label1.left, self.label1.bottom + 10, UI_SCREEN_WIDTH - self.logoImg.right - 20, 20);
            self.label2.textColor = [UIColor grayColor];
            self.label2.font = [UIFont systemFontOfSize:15];
            self.label2.text = _model.date;
        }
            break;
        case 31:
        {
            self.label1.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, 20);
            self.label1.textColor = BaseColor;
            self.label1.text = _model.name;
        
            self.label2.frame = CGRectMake(10, self.label1.bottom + 10, self.label1.width, self.height - 80);
            self.label2.text = _model.content;
            self.label2.textColor = [UIColor grayColor];
            self.label2.font = [UIFont systemFontOfSize:15];
            
            self.label3.frame = CGRectMake(10, self.label2.bottom + 10, self.label1.width, 20);
            self.label3.text = _model.date;
            self.label3.textColor = [UIColor grayColor];
            self.label3.font = [UIFont systemFontOfSize:15];
        }
            break;


        default:
            break;
    }
    
}

- (void)lessonClick:(UIButton *)btn
{
    _block(btn.tag);
}

- (void)cellView3Click:(UIButton *)btn
{
    BaseCellModel *model = _model.cateArray[btn.tag];
    _block2(model);
}

- (void)goodsClick
{
    NSLog(@"1231231");
}

- (void)setImgWithURLStr:(NSString *)str withplaceholderImage:(UIImage *)img withImgView:(UIImageView *)imgView
{
    NSString *url;
    if ([str hasPrefix:@"http"]) {
        url = str;
    }else {
        url = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,str];
    }
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:img];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
