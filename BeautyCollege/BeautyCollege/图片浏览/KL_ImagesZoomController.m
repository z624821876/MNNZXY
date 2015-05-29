//
//  KL_ImagesZoomController.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//


#import "KL_ImagesZoomController.h"
#import "ZoomImgItem.h"
@interface KL_ImagesZoomController ()
{
    CGSize v_size;
    UITableView *m_TableView;
    UILabel *progressLabel;
}
@end

@implementation KL_ImagesZoomController

- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        v_size = size;
        [self _initView];
    }
    return self;
}

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index
{
    self.imgs = imageArr;
    [m_TableView reloadData];
    if (index > 0 && index < self.imgs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    progressLabel.text = [NSString stringWithFormat:@"%lu/%lu",index + 1,self.imgs.count];
}

- (void)_initView
{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)
                                               style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_TableView];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20)];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont systemFontOfSize:15];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:progressLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 50, progressLabel.top - 5, 40, 30)];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)close
{
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idty = @"imgshowCell";
    ZoomImgItem *cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (nil == cell) {
        cell = [[ZoomImgItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.size = self.bounds.size;
    NSString *imgStr = [self.imgs objectAtIndex:indexPath.row];
    cell.imgName = imgStr;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"showIndex: %d",indexPath.row);
//    
//    progressLabel.text = [NSString stringWithFormat:@"%d/%d",indexPath.row + 1,self.imgs.count];
//}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    progressLabel.text = [NSString stringWithFormat:@"%lu/%lu",index.row + 1,self.imgs.count];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
     progressLabel.text = [NSString stringWithFormat:@"%lu/%lu",index.row + 1,self.imgs.count];
    NSLog(@"index.row : %lu",index.row);
}

@end
