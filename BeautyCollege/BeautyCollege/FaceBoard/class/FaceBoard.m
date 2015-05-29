//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"
#import "MyTextAttachment.h"

#define FACE_COUNT_ALL  72

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE (FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44


@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init {

    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {

            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"_expression_cn"
                                                         ofType:@"plist"]] retain];
        }
        else {

            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                         ofType:@"plist"]] retain];
        }
       
        [[NSUserDefaults standardUserDefaults] setObject:_faceMap forKey:@"FaceMap"];

        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * [UIScreen mainScreen].bounds.size.width, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;

        for (int i = 1; i <= FACE_COUNT_ALL; i++) {

            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * (FACE_ICON_SIZE * width / 320.0) + 6 + ((i - 1) / FACE_COUNT_PAGE * width);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
            faceButton.frame = CGRectMake(x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"f%03d", i - 1]]
                        forState:UIControlStateNormal];
            faceButton.contentMode = UIViewContentModeScaleAspectFit;
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
//        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        CGFloat x = (((7 - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * (FACE_ICON_SIZE * width / 320.0) + 6 + ((7 - 1) / FACE_COUNT_PAGE * width);
        back.frame = CGRectMake(x, 182, 38, 28);
        [self addSubview:back];
    }

    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

    NSInteger i = ((FaceButton*)sender).buttonIndex;
    if (self.inputTextField) {

//        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
//        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03ld", i]]];
//                self.inputTextField.text = faceString;
//        [faceString release];
    }
    
    if (self.inputTextView) {
        
        [self changeTextWithString:[NSString stringWithFormat:@"f%03ld", i - 1]];
        [delegate textViewDidChange:self.inputTextView];
        
        /*
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
        [str enumerateAttributesInRange:NSMakeRange(0, str.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            if ([[attrs objectForKey:@"NSAttachment"] isKindOfClass:[MyTextAttachment class]]) {
                MyTextAttachment *textAttachment = (MyTextAttachment *)[attrs objectForKey:@"NSAttachment"];
//                NSLog(@"%@----",textAttachment.imgName);
                [str replaceCharactersInRange:range withString:textAttachment.imgName];
                NSLog(@"%@--------------",str.string);
            }
        }];
         */
    }
}

- (void)changeTextWithString:(NSString *)str
{
    NSString *imgStr = str;
    NSMutableAttributedString *imgStr1 = [[NSMutableAttributedString alloc] initWithString:imgStr];
    NSString *pattern = @"f0[0-9][0-9]";
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [re matchesInString:imgStr options:0 range:NSMakeRange(0, imgStr.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *imgName = [imgStr substringWithRange:range];
        //新建文字附件来存放我们的图片
        MyTextAttachment *textAttachment = [[MyTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
            //保存图片名字   用来将来还原未文字
        textAttachment.imgName = [NSString stringWithFormat:@"%@",imgName];
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:imageStr forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSDictionary *rangeDic = imageArray[i];
        NSRange range22 = [[rangeDic objectForKey:@"range"] rangeValue];
        //进行替换
        [imgStr1 replaceCharactersInRange:range22 withAttributedString:[rangeDic objectForKey:@"image"]];
    }
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    [attributStr appendAttributedString:imgStr1];
    self.inputTextView.attributedText = attributStr;
    self.inputTextView.font = [UIFont systemFontOfSize:17];
}

- (void)backFace{
    
    if (self.inputTextView.attributedText.length <= 0) {
        return;
    }
    
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    [inputString deleteCharactersInRange:NSMakeRange(inputString.length - 1, 1)];
    self.inputTextView.attributedText = inputString;
    [delegate textViewDidChange:self.inputTextView];
}

- (void)dealloc {
    
    [_faceMap release];
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    
    [super dealloc];
}

@end
