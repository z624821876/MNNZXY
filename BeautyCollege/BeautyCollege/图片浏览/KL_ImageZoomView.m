//
//  KL_ImageZoomView.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "KL_ImageZoomView.h"


#define HandDoubleTap 2
#define HandOneTap 1
#define MaxZoomScaleNum 5.0
#define MinZoomScaleNum 1.0
@implementation KL_ImageZoomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
   return   self.bounds.size.width / self.image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    return  self.bounds.size.height / self.image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor];
        float newHeight = oldSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            bs = [self getImgHeightFactor];
            float newWidth = oldSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = oldSize;
    }
    return newSize;
}

- (void)_initView {
    
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [_scrollView addSubview:_containerView];
    
    [self addSubview:_scrollView];

    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_containerView addSubview:_imageView];
    
    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(TapsAction:)];
    [doubleTapGesture setNumberOfTapsRequired:HandDoubleTap];
    [_containerView addGestureRecognizer:doubleTapGesture];
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(TapsAction:)];
    [tapGesture setNumberOfTapsRequired:HandOneTap];
    [_containerView addGestureRecognizer:tapGesture];
    
    //双击失败之后执行单击
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];


    DDProgressView *pro = [[DDProgressView alloc] initWithFrame:CGRectMake(0.0f, (self.bounds.size.height - 2) * 0.5, self.frame.size.width, 3)];
    self.progress = pro;
    self.progress.progress = 0.0;
    self.progress.hidden = YES;
    self.progress.innerColor = [UIColor blueColor];//进度颜色
    self.progress.emptyColor = [UIColor whiteColor];//背景
    [self addSubview:self.progress];
    [pro release];

    
//    CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showSize.width, showSize.height)];
//    imgview.image = self.image;
//     self.imageView = imgview;
//    [imgview release];
    
    self.scrollView.maximumZoomScale = MaxZoomScaleNum;
    self.scrollView.minimumZoomScale = MinZoomScaleNum;
    self.scrollView.zoomScale = MinZoomScaleNum;

}

- (void)resetViewFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
    
    CGSize vsize = self.frame.size;
    self.progress.hidden = NO;
    self.progress.frame = CGRectMake(15, (vsize.height - 2) * 0.5,vsize.width - 30 , 2);
}


#pragma mark- 手势事件
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (HandDoubleTap == tapCount) {
        //双击
        NSLog(@"双击");
        if (self.scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale) {
            [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        }else {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        }
        
    }else if (HandOneTap == tapCount) {
        //单击
        NSLog(@"单击");
                
//        self
        
//        NSLog(@"imgUrl: %@, imgSize:(%f, %f) zoomScale:%f",downImgUrl,self.imageView.frame.size.width,self.imageView.frame.size.height,self.scrollView.zoomScale);
    }
}


#pragma mark- Properties

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    if(self.imageView == nil){
        self.imageView = [UIImageView new];
        self.imageView.clipsToBounds = YES;
    }
    self.imageView.image = image;
}

//本地图片
- (void)updateImage:(NSString *)imgName {
    self.scrollView.scrollEnabled = YES;
    self.image = [UIImage imageNamed:imgName];
    [self setImageViewWithImg:self.image];
}
//网络图片
- (void)uddateImageWithUrl:(NSString *)imgUrl
{
    [MyTool setImgWithURLStr:imgUrl withplaceholderImage:nil withImgView:_imageView];
        self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.backgroundColor = [UIColor redColor];
    self.scrollView.scrollEnabled = YES;
    self.progress.hidden = YES;
//    CGSize showSize = [self newSizeByoriginalSize:img.size maxSize:self.bounds.size];
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
    //    [self resetZoomScale];
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    
//    
//    self.scrollView.scrollEnabled = NO;
//    self.imageView.image = nil;
//    downImgUrl = imgUrl;
//
//    
//    /**
//     * 检查下载队列中是否已经存在此url
//     * 如果存在 则获取已经下载的进度
//     * 如果不存在则开始新的下载
//     **/
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    if ([manager webImageDownoaderWithUrl:[NSURL URLWithString:downImgUrl]]) {
//        float downLoadProgress = [manager getImageDidDownloadProgressWithUrl:[NSURL URLWithString:downImgUrl]];
//        self.progress.hidden = NO;;
//        self.progress.progress = downLoadProgress;
//        NSLog(@"---************************获取下载进度: %f url: %@",downLoadProgress,downImgUrl);
//        if (downLoadProgress >= 1) {
//            self.progress.hidden = YES;
//        }
//        
//    }else {
//        self.progress.hidden = YES;
//    }
//
//    
//    self.progress.progress = 0;
//    [self loadImeWithUrl:downImgUrl];
    
}
- (void)setImageViewWithImg:(UIImage *)img {
    self.scrollView.scrollEnabled = YES;
    self.progress.hidden = YES;
    
    self.imageView.image = img;
    CGSize showSize = [self newSizeByoriginalSize:img.size maxSize:self.bounds.size];
    self.imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
    self.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
//    [self resetZoomScale];
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    
//    [self imageDidChange];
}

//- (void)setImageView:(UIImageView *)imageView {
//    if(imageView != _imageView){
//        [_imageView removeObserver:self forKeyPath:@"image"];
//        [_imageView removeFromSuperview];
//        
//        _imageView = imageView;
//        
//        CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//        _imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
//        
//        [_imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
//        
//        [_containerView addSubview:_imageView];
//        
//        _scrollView.zoomScale = 1;
//        _scrollView.contentOffset = CGPointZero;
//        _containerView.bounds = _imageView.bounds;
//        
//        [self resetZoomScale];
//        _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//        [self scrollViewDidZoom:_scrollView];
//    }
//    
//}

- (BOOL)isViewing {
    return (_scrollView.zoomScale != _scrollView.minimumZoomScale);
}

#pragma mark- observe
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if(object==self.imageView){
//        [self imageDidChange];
//    }
//}

//- (void)imageDidChange {
//    CGSize size = (self.imageView.image) ? self.imageView.image.size : self.bounds.size;
//    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
//    CGFloat W = ratio * size.width;
//    CGFloat H = ratio * size.height;
//    self.imageView.frame = CGRectMake(0, 0, W, H);
//    
//    _scrollView.zoomScale = 1;
//    _scrollView.contentOffset = CGPointZero;
//    _containerView.bounds = _imageView.bounds;
//    
//    [self resetZoomScale];
//    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//    [self scrollViewDidZoom:_scrollView];
//}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    _containerView.frame = rct;
    
}



//- (void)resetZoomScale {
//    CGFloat Rw = _scrollView.frame.size.width / self.imageView.frame.size.width;
//    CGFloat Rh = _scrollView.frame.size.height / self.imageView.frame.size.height;
//    
//    CGFloat scale = 1;
//    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
//    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
//    
//    _scrollView.contentSize = _imageView.frame.size;
//    _scrollView.minimumZoomScale = 1;
//    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
//}

- (void)dealloc {
    [super dealloc];
}

////////////////////////// 下载图片

/*
- (void)loadImeWithUrl:(NSString *)imageUrl
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager cancelForDelegate:self];
    
    if (imageUrl) {
        UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:imageUrl]];
        if (cachedImage) {
            //已经下载
            self.image = cachedImage;
            [self setImageViewWithImg:self.image];
        }else {
            self.progress.hidden = NO;
            //未下载 需要去下载 内部会处理 此图是否下载中
            [manager downloadWithURL:[NSURL URLWithString:imageUrl] delegate:self];
        }
    }else {
        self.progress.hidden = YES;
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    //下载图片成功
    if ([imageManager webImageDownoaderWithUrl:[NSURL URLWithString:downImgUrl]]) {
        self.progress.progress = 1.0;
        self.progress.hidden = YES;
        
        self.image = image;
        [self setImageViewWithImg:self.image];
        
        NSLog(@"当前 -- 下载图片成功");
    }
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
        //下载图片失败
    if ([imageManager webImageDownoaderWithUrl:[NSURL URLWithString:downImgUrl]]) {
        self.progress.hidden = YES;
        self.progress.progress = 0.0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"图片下载失败!\n请检查网络后重试"
                                                       delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

        NSLog(@"当前url 下载失败");
    }
}
- (void)webImageManager:(SDWebImageManager *)downloader totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    //下载中

//    NSLog(@"下载中");
//    float p = expectedTotalBytes /(double) totalBytesWritten;
//    if (p > self.progress.progress) {
//        self.progress.progress = p;
//    }
    
    if ([downloader webImageDownoaderWithUrl:[NSURL URLWithString:downImgUrl]]) {
        float downLoadProgress = [downloader getImageDidDownloadProgressWithUrl:[NSURL URLWithString:downImgUrl]];
        self.progress.progress = downLoadProgress;
        if (downLoadProgress >= 1) {
            self.progress.hidden = YES;
        }
        NSLog(@"是当前url:%@ 下载进度: %f",downImgUrl,downLoadProgress);
    }else {
        NSLog(@"不是 ---- 当前url");
    }
}
*/

@end
