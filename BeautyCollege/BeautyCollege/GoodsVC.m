//
//  GoodsVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "GoodsVC.h"
#import "CellView.h"
#import "CommentVC.h"
#import "MyCustomView.h"
#import "OrderVC.h"
#import "CustomCollectionCell.h"
#import "ShoppingcartVC.h"
#import "CommentListVC.h"

@interface GoodsVC ()
@property (nonatomic, strong) NSMutableArray        *imgArray;
@property (nonatomic, strong) BaseCellModel         *productModel;
@property (nonatomic, strong) UIView                *bgView1;
@property (nonatomic, strong) UIView                *bgView2;
@property (nonatomic, strong) UIView                *bgView3;

@property (nonatomic, strong) UIButton              *likeCountBtn;
@property (nonatomic, strong) UIButton              *collectCountBtn;
@property (nonatomic, strong) UIButton              *likeBtn;
@property (nonatomic, strong) UIButton              *collectBtn;
@property (nonatomic, strong) UILabel               *priceLabel;
@property (nonatomic, strong) UILabel               *discountLabel;
@property (nonatomic, strong) UILabel               *buyCountLabel;
@property (nonatomic, strong) UILabel               *goodsContentLabel;
@property (nonatomic, strong) UILabel               *conmentCountLabel;
@property (nonatomic, strong) UIWebView             *detailWeb;

@property (nonatomic, strong) NSMutableArray        *goodsArray;
@property (nonatomic, strong) NSTimer               *timer;

@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) NSMutableArray        *sizeArray;
@property (nonatomic, strong) NSMutableArray        *attributeArray;

@property (nonatomic, strong) NSIndexPath              *currentAttributeIndex;
@property (nonatomic, strong) NSIndexPath              *currentSizeIndex;

@property (nonatomic, strong) UIButton              *numBtn;
@property (nonatomic, strong) MyCustomView          *topView;
@property (nonatomic, assign) NSInteger             refrenshCount;
@end

@implementation GoodsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"宝贝";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 60);
    [btn setTitle:@"0" forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(toShoppingcart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    
}

//查看购物车
- (void)toShoppingcart
{
    ShoppingcartVC *vc = [[ShoppingcartVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sizeArray = [[NSMutableArray alloc] init];
    _attributeArray = [[NSMutableArray alloc] init];
    _goodsArray = [[NSMutableArray alloc] init];
    _imgArray = [NSMutableArray array];
    _productModel = [[BaseCellModel alloc] init];
    _bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40 * UI_scaleY)];
    _bgScroll.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 15, UI_SCREEN_WIDTH, 20);
    [img setImage:[[UIImage imageNamed:@"bg_class_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 10, 5)]];
    [_bgScroll addSubview:img];
    
    _bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, img.bottom - 1, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH * 436.0 / 640.0 + 95 + 50 + 10)];
    _bgView1.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:_bgView1];
    
    
    _shufflingScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH * 436.0 / 640.0)];
    _shufflingScroll.pagingEnabled = YES;
    _shufflingScroll.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [_bgView1 addSubview:_shufflingScroll];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _shufflingScroll.bottom, UI_SCREEN_WIDTH - 10, 40)];
    _nameLabel.numberOfLines = 2;
    [_bgView1 addSubview:_nameLabel];

    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 60, _nameLabel.bottom + 5, 50, 25);
    [_collectBtn setImage:[UIImage imageNamed:@"btn_store.png"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"btn_store_s.png"] forState:UIControlStateSelected];
    _collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _collectBtn.tag = 11;
    [_collectBtn addTarget:self action:@selector(likeAndCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgView1 addSubview:_collectBtn];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(_collectBtn.left - 60, _nameLabel.bottom + 5, 50, 25);
    [_likeBtn setImage:[UIImage imageNamed:@"btn_like.png"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"btn_like_s.png"] forState:UIControlStateSelected];
    _likeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _likeBtn.tag = 10;
    [_likeBtn addTarget:self action:@selector(likeAndCollect:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview:_likeBtn];
    
    CGFloat width = (_likeBtn.left - 30) / 2.0;
    _likeCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeCountBtn.frame = CGRectMake(10, _likeBtn.top, width, 25);
    [_likeCountBtn setImage:[UIImage imageNamed:@"baobei_a.png"] forState:UIControlStateNormal];
    [_likeCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_likeCountBtn setTitle:@"0人喜欢" forState:UIControlStateNormal];
    _likeCountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _likeCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView1 addSubview:_likeCountBtn];
    
    _collectCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectCountBtn.frame = CGRectMake(_likeCountBtn.right + 10, _likeBtn.top, width, 25);
    [_collectCountBtn setImage:[UIImage imageNamed:@"sadasdhkj.png"] forState:UIControlStateNormal];
    [_collectCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_collectCountBtn setTitle:@"0人收藏" forState:UIControlStateNormal];
    _collectCountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _collectCountBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _collectCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView1 addSubview:_collectCountBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, _likeCountBtn.bottom + 20, 40, 20)];
    label.text = @"价格:";
    label.font = [UIFont systemFontOfSize:15];
    [_bgView1 addSubview:label];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right, label.top, 150, 20)];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.textColor = BaseColor;
    [_bgView1 addSubview:_priceLabel];
    
    _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.right, _priceLabel.top, 10, 20)];
    _discountLabel.font = [UIFont systemFontOfSize:13];
    [_bgView1 addSubview:_discountLabel];
    
    
    _buyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_discountLabel.right + 10, _priceLabel.top, UI_SCREEN_WIDTH - _discountLabel.right - 20, 20)];
    _buyCountLabel.text = @"10000人已购买";
    _buyCountLabel.font = [UIFont systemFontOfSize:14];
    _buyCountLabel.textAlignment = NSTextAlignmentRight;
    [_bgView1 addSubview:_buyCountLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, _priceLabel.bottom + 20, 200, 20)];
    label2.text = @"宝贝介绍:";
    [_bgView1 addSubview:label2];
    
    _goodsContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, label2.bottom + 10, UI_SCREEN_WIDTH - 29, 20)];
    _goodsContentLabel.numberOfLines = 0;
    _goodsContentLabel.font = [UIFont systemFontOfSize:15];
    _goodsContentLabel.text = @"这是宝贝介绍";
    [_bgView1 addSubview:_goodsContentLabel];
    CGRect rect = _bgView1.frame;
    rect.size.height = _goodsContentLabel.bottom + 10;
    _bgView1.frame = rect;
    
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView1.bottom, UI_SCREEN_WIDTH, 100)];
    _bgView2.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:_bgView2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    label3.text = @"图片详情:";
    [_bgView2 addSubview:label3];
    
    _detailWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, label3.bottom + 5, _bgView2.width, 75)];
    _detailWeb.delegate = self;
    _detailWeb.scrollView.scrollEnabled = NO;
    [_bgView2 addSubview:_detailWeb];
    
    _bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView2.bottom + 15, UI_SCREEN_WIDTH, 200)];
    _bgView3.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:_bgView3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
    [_bgView3 addSubview:view];
    
    UIImageView *conmentImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    [conmentImg setImage:[UIImage imageNamed:@"comment.png"]];
    [_bgView3 addSubview:conmentImg];
    
    _conmentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, conmentImg.top + 20, 200, 20)];
    _conmentCountLabel.text = @"用户评价（0）";
    [_bgView3 addSubview:_conmentCountLabel];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 35, _conmentCountLabel.top, 20, 20)];
    [nextImg setImage:[UIImage imageNamed:@"jiantou.png"]];
    [_bgView3 addSubview:nextImg];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 60);
    [nextBtn addTarget:self action:@selector(nextbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView3 addSubview:nextBtn];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, conmentImg.bottom + 35, UI_SCREEN_WIDTH, 20)];
    [img2 setImage:[UIImage imageNamed:@"bg_class_top.png"]];
    [_bgView3 addSubview:img2];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, img2.top - 10, 40, 40)];
    [iconImg setImage:[UIImage imageNamed:@"美娘首页4.png"]];
    [_bgView3 addSubview:iconImg];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right + 5, img2.top + 5, 100, 25)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"推荐商品";
    [_bgView3 addSubview:titleLabel];
    
    [self.view addSubview:_bgScroll];
    _bgScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom + 20);
    [self buildFootView];
}
- (void)stopHUD
{
    if (_refrenshCount >= 3) {
        [[tools shared] HUDHide];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _refrenshCount = 0;
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str0 = [NSString stringWithFormat:@"mobi/pro/getShoppingCartCount?memberId=%@",[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str0 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"baobei_c.png"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 60, 60);
            [btn setTitle:[NSString stringWithFormat:@"%@",[json objectForKey:@"result"]] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [btn addTarget:self action:@selector(toShoppingcart) forControlEvents:UIControlEventTouchUpInside];

            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = item;
            
            _refrenshCount += 1;
            [self stopHUD];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    
    NSString *str = [NSString stringWithFormat:@"mobi/pro/getProductDetail?productId=%@&memberId=%@",self.goodsId,[User shareUser].userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_imgArray removeAllObjects];
            [_sizeArray removeAllObjects];
            [_attributeArray removeAllObjects];
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *productDic = nilOrJSONObjectForKey(resultDic, @"product");
            NSDictionary *productTextDic = nilOrJSONObjectForKey(resultDic, @"productText");
            NSArray *productComments = nilOrJSONObjectForKey(resultDic, @"productComments");
            
            NSMutableArray *commentsArray = [[NSMutableArray alloc] initWithCapacity:[productComments count]];
            for (NSDictionary *dict in productComments) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(dict, @"title");
                model.content = nilOrJSONObjectForKey(dict, @"content");
                model.date = nilOrJSONObjectForKey(dict, @"createTime");
                [commentsArray addObject:model];
            }
            _productModel.cateArray = commentsArray;
            _productModel.name = nilOrJSONObjectForKey(productDic, @"name");
            NSNumber *priceNum = nilOrJSONObjectForKey(productDic, @"price");
            _productModel.discountPrice = [priceNum stringValue];
            NSNumber *priceNum2 = nilOrJSONObjectForKey(productDic, @"marketPrice");
            _productModel.price = [priceNum2 stringValue];
            _productModel.logo = nilOrJSONObjectForKey(productDic, @"detailImage");
            //宝贝介绍
            _productModel.content = nilOrJSONObjectForKey(productDic, @"fied2");
            
            //            购买数buyedCount  评论数commentCount  喜欢数likeCount  是否收藏collectId  是否喜欢likeId 收藏数collectCount
            _productModel.buyedCount = [MyTool getValuesFor:productDic key:@"buyedCount"];
            _productModel.commentCount = [MyTool getValuesFor:productDic key:@"commentCount"];
            _productModel.likeCount = [MyTool getValuesFor:productDic key:@"likeCount"];
            _productModel.collectCount = [MyTool getValuesFor:productDic key:@"collectCount"];
            _productModel.collectId = [MyTool getValuesFor:productDic key:@"collectId"];
            _productModel.likeId = [MyTool getValuesFor:productDic key:@"likeId"];
            _productModel.detail = nilOrJSONObjectForKey(productTextDic, @"text");
            
            _productModel.productStore = [MyTool getValuesFor:productDic key:@"productStore"];
            
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"productImages");
            for (NSDictionary *dic in array) {
                NSString *str = nilOrJSONObjectForKey(dic, @"imgPath");
                [_imgArray addObject:str];
            }
            
            NSArray *paramsarray = nilOrJSONObjectForKey(resultDic, @"params");
            NSArray *attributeArr = nilOrJSONObjectForKey([paramsarray firstObject], @"results") ;
            NSArray *sizeArr = nilOrJSONObjectForKey([paramsarray lastObject], @"results");
            
            for (NSDictionary *dict in attributeArr) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dict, @"configId");
                model.name = nilOrJSONObjectForKey(dict, @"value");
                [_attributeArray addObject:model];
            }
            
            for (NSDictionary *dict in sizeArr) {
                
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dict, @"configId");
                model.name = nilOrJSONObjectForKey(dict, @"value");
                [_sizeArray addObject:model];
            }
            
            
            [self updateGUI];
            
            _refrenshCount += 1;
            [self stopHUD];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    NSString *str2 = @"mobi/pro/getProductList?type=recommend&page=1&rows=2";
    [[HttpManager shareManger] getWithStr:str2 ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [_goodsArray removeAllObjects];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSArray *array = [[json objectForKey:@"result"] objectForKey:@"result"];
            for (NSDictionary *dic in array) {
                if ([_goodsArray count] >= 2) {
                    break;
                }
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                model.catId = nilOrJSONObjectForKey(dic, @"catId");
                model.title = nilOrJSONObjectForKey(dic, @"name");
                model.logo = nilOrJSONObjectForKey(dic, @"detailImage");
                NSNumber *price = nilOrJSONObjectForKey(dic, @"price");
                model.price = price == nil ? @"0" : [price stringValue];
                NSNumber *count = nilOrJSONObjectForKey(dic, @"likeCount");
                model.count = count == nil ? @"0" : [count stringValue];
                [_goodsArray addObject:model];
            }
            [self addRecommendGoods];
            _refrenshCount += 1;
            [self stopHUD];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLog(@"%@",error);
    }];
    
    
}

    //喜欢和收藏
- (void)likeAndCollect:(UIButton *)btn
{
    NSString *urlStr;
    if (btn.tag == 10) {
        //喜欢
        urlStr = [NSString stringWithFormat:@"mobi/pro/addLike?productId=%@&memberId=%@",self.goodsId,[User shareUser].userId];
    }else {
        //收藏
        urlStr = [NSString stringWithFormat:@"mobi/pro/addFavourite?productId=%@&memberId=%@",self.goodsId,[User shareUser].userId];
    }
    
    [[HttpManager shareManger] getWithStr:urlStr ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            btn.selected = !btn.selected;
            
            if (btn.tag == 10) {
                //喜欢
                if (btn.selected) {
                    _productModel.likeCount = [NSString stringWithFormat:@"%ld",[_productModel.likeCount integerValue] + 1];
                }else {
                    _productModel.likeCount = [NSString stringWithFormat:@"%ld",[_productModel.likeCount integerValue] - 1];
                }
                
                NSString *str = [NSString stringWithFormat:@"%@人喜欢",_productModel.likeCount];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
                [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:_productModel.likeCount]];
                [_likeCountBtn setAttributedTitle:string forState:UIControlStateNormal];

            }else {
                //收藏
                if (btn.selected) {
                    _productModel.collectCount = [NSString stringWithFormat:@"%ld",[_productModel.collectCount integerValue] + 1];
                }else {
                    _productModel.collectCount = [NSString stringWithFormat:@"%ld",[_productModel.collectCount integerValue] - 1];
                }
                NSString *str2 = [NSString stringWithFormat:@"%@人收藏",_productModel.collectCount];
                NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2];
                [string2 addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str2 rangeOfString:_productModel.collectCount]];
                [_collectCountBtn setAttributedTitle:string2 forState:UIControlStateNormal];

            }
            
            
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

    //查看用户评论
- (void)nextbtnClick
{
    if ([_productModel.cateArray count] <= 0) {
        [[tools shared] HUDShowHideText:@"暂无评论" delay:1.0];
        return;
    }
    CommentListVC *vc = [[CommentListVC alloc] init];
    vc.dataArray = _productModel.cateArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buildFootView
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, self.view.bottom - 40 * UI_scaleY, UI_SCREEN_WIDTH / 2.0, 40 * UI_scaleY);
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 10;
    [self.view addSubview:leftBtn];
    
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame = CGRectMake(leftBtn.right, leftBtn.top, leftBtn.width, 40 * UI_scaleY);
    rigthBtn.backgroundColor = [UIColor whiteColor];
    [rigthBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [rigthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rigthBtn addTarget:self action:@selector(addtocart:) forControlEvents:UIControlEventTouchUpInside];
    rigthBtn.tag = 11;
    [self.view addSubview:rigthBtn];
    
}

    //购买
- (void)buy:(UIButton *)btn
{
    [self selectNormsWith:btn.tag];
}

    //加入购物车
- (void)addtocart:(UIButton *)btn
{
    [self selectNormsWith:btn.tag];
}

    //选择属性
- (void)selectNormsWith:(NSInteger)type
{
    _currentAttributeIndex = nil;
    _currentSizeIndex = nil;
    _topView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _topView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
    [[AppDelegate shareApp].window addSubview:_topView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH - 20, UI_SCREEN_HEIGHT / 3.0 * 2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:bgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, bgView.height - 40, bgView.width, 40);
    btn.backgroundColor = BaseColor;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.tag = type;
    [btn addTarget:self action:@selector(comfirm:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 70, 70)];
    [logo sd_setImageWithURL:[NSURL URLWithString:_productModel.logo]];
    [bgView addSubview:logo];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(bgView.width - 35, 10, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"errimg.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:closeBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(logo.right + 5, 10, closeBtn.left - logo.right - 10, 40)];
    label.text = _productModel.name;
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom + 10, label.width, 20)];
    NSString *price = [NSString stringWithFormat:@"￥%@",_productModel.discountPrice];
    priceLabel1.text = price;
    priceLabel1.textColor = BaseColor;
    [bgView addSubview:priceLabel1];
    CGFloat width = [price boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;
    UILabel *priceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel1.left + width + 10, priceLabel1.top, priceLabel1.width - width - 10, 20)];
    priceLabel2.textColor = [UIColor grayColor];
    priceLabel2.font = [UIFont systemFontOfSize:15];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:_productModel.price attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    priceLabel2.attributedText = string;
    [bgView addSubview:priceLabel2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, logo.bottom + 9.5, bgView.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [bgView addSubview:lineView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineView.bottom, bgView.width, btn.top - lineView.bottom)];
    [bgView addSubview:scrollView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    label1.text = @"属性:";
    [scrollView addSubview:label1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    UICollectionView *collection1 = [[UICollectionView alloc] initWithFrame:CGRectMake(15, label1.bottom, bgView.width - 30, 90) collectionViewLayout:layout];
    [collection1 registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    collection1.backgroundColor = [UIColor clearColor];
    collection1.delegate = self;
    collection1.dataSource = self;
    collection1.tag = 10;
    [scrollView addSubview:collection1];
    CGSize size1 = layout.collectionViewContentSize;
    CGRect rect1 = collection1.frame;
    rect1.size.height = size1.height;
    collection1.frame = rect1;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, collection1.bottom + 9.5, bgView.width, 0.5)];
    lineView2.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:lineView2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView2.bottom + 10, 100, 20)];
    label2.text = @"规格:";
    [scrollView addSubview:label2];

    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    UICollectionView *collection2 = [[UICollectionView alloc] initWithFrame:CGRectMake(15, label2.bottom, collection1.width, 100) collectionViewLayout:layout2];
    [collection2 registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    collection2.delegate = self;
    collection2.dataSource = self;
    collection2.tag = 11;
    collection2.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:collection2];
    CGSize size2 = layout2.collectionViewContentSize;
    CGRect rect2 = collection2.frame;
    rect2.size.height = size2.height;
    collection2.frame = rect2;
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, collection2.bottom + 9.5, bgView.width, 0.5)];
    lineView3.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:lineView3];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView3.bottom + 15, 50, 20)];
    label3.text = @"数量:";
    [scrollView addSubview:label3];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(scrollView.width - 45, lineView3.bottom + 10, 30, 30);
    [addBtn setImage:[UIImage imageNamed:@"addbtnimg.png"] forState:UIControlStateNormal];
    addBtn.tag = 11;
    [addBtn addTarget:self action:@selector(changeGoodsNum:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addBtn];
    
    _numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _numBtn.userInteractionEnabled = NO;
    _numBtn.frame = CGRectMake(addBtn.left - 50, addBtn.top, 50, addBtn.height);
    _numBtn.layer.borderColor = BaseColor.CGColor;
    _numBtn.layer.borderWidth = 0.5;
    [_numBtn setTitle:@"1" forState:UIControlStateNormal];
    [_numBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [scrollView addSubview:_numBtn];
    
    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(_numBtn.left - 30, _numBtn.top, 30, 30);
    [reduceBtn setImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
    reduceBtn.tag = 10;
    [reduceBtn addTarget:self action:@selector(changeGoodsNum:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:reduceBtn];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.right + 10, reduceBtn.top, reduceBtn.left - label3.right - 20, 30)];
    label4.text = [NSString stringWithFormat:@"库存:%@",_productModel.productStore];
    label4.textColor = [UIColor grayColor];
    label4.textAlignment = NSTextAlignmentRight;
    label4.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:label4];
    scrollView.contentSize = CGSizeMake(scrollView.width, label4.bottom + 20);
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect bgViewRect = bgView.frame;
        bgViewRect.origin.y = UI_SCREEN_HEIGHT / 3.0;
        //    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, UI_SCREEN_HEIGHT / 3.0, UI_SCREEN_WIDTH - 20, UI_SCREEN_HEIGHT / 3.0 * 2)];
        bgView.frame = bgViewRect;
    }];
}

    //提交
- (void)comfirm:(UIButton *)btn
{
    if (nil == _currentAttributeIndex || nil == _currentSizeIndex) {
        [[tools shared] HUDShowHideText:@"请选择规格" delay:1.5];
        return;
    }
    
    if ([[_numBtn currentTitle] isEqualToString:@"0"]) {
        [[tools shared] HUDShowHideText:@"请选择数量" delay:1.5];
        return;
    }
    BaseCellModel *model1 = _attributeArray[_currentAttributeIndex.row];
    BaseCellModel *model2 = _sizeArray[_currentSizeIndex.row];
    NSString *normsStr = [NSString stringWithFormat:@"%@,%@",model1.modelId,model2.modelId];
    if (btn.tag == 10) {
        //购买
        NSString *str = [NSString stringWithFormat:@"mobi/pro/saveBuyNow?memberId=%@&productId=%@&number=%@&paramIds=%@",[User shareUser].userId,self.goodsId,_numBtn.currentTitle,normsStr];
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            [self close];
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                OrderVC *vc = [[OrderVC alloc] init];
                vc.type = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else {
        //加入购物车
        NSString *str = [NSString stringWithFormat:@"mobi/pro/addShoppingCart?memberId=%@&productId=%@&number=%@&paramIds=%@",[User shareUser].userId,self.goodsId,_numBtn.currentTitle,normsStr];
        
        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            [self close];
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                [[tools shared] HUDShowHideText:@"添加成功" delay:1.5];
                ShoppingcartVC *vc = [[ShoppingcartVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [[tools shared] HUDShowHideText:@"添加失败" delay:1.5];
            }
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }
}

- (void)changeGoodsNum:(UIButton *)btn
{
    if ([_numBtn.currentTitle isEqualToString:@"1"] && btn.tag == 10) {
        return;
    }
    
    NSInteger variable = btn.tag == 10 ? -1 : 1;
    NSInteger num = [_numBtn.currentTitle integerValue] + variable;
    [_numBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
}

- (void)close
{
    [_topView removeFromSuperview];
}

    //刷新轮播图
- (void)changeImg
{
    NSInteger i = _shufflingScroll.contentOffset.x / UI_SCREEN_WIDTH;
    i += 1;
    if (i >= [_imgArray count]) {
        i = 0;
    }
    [_shufflingScroll setContentOffset:CGPointMake(i * UI_SCREEN_WIDTH, 0) animated:YES];
}

    //刷新视图
- (void)updateGUI
{
    _nameLabel.text = _productModel.name;
    [_timer invalidate];
    _timer = nil;
    for (UIView *view in _shufflingScroll.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (NSString *str in _imgArray) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake([_imgArray indexOfObject:str] * UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, _shufflingScroll.height)];
        [img sd_setImageWithURL:[NSURL URLWithString:str]];
        [_shufflingScroll addSubview:img];
    }
    _shufflingScroll.contentSize = CGSizeMake(_imgArray.count * UI_SCREEN_WIDTH, _shufflingScroll.height);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeImg) userInfo:nil repeats:YES];
    
    _likeBtn.selected = [_productModel.likeId isEqualToString:@"0"] ? NO : YES;
    _collectBtn.selected = [_productModel.collectId isEqualToString:@"0"] ? NO : YES;
    
    NSString *str = [NSString stringWithFormat:@"%@人喜欢",_productModel.likeCount];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str rangeOfString:_productModel.likeCount]];
    [_likeCountBtn setAttributedTitle:string forState:UIControlStateNormal];
    NSString *str2 = [NSString stringWithFormat:@"%@人收藏",_productModel.collectCount];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2];
    [string2 addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str2 rangeOfString:_productModel.collectCount]];
    [_collectCountBtn setAttributedTitle:string2 forState:UIControlStateNormal];
    
    NSString *str3 = [NSString stringWithFormat:@"￥%.2f",[_productModel.discountPrice doubleValue]];
    
    //    NSString *str3 = [NSString stringWithFormat:@"￥%@ %@",_productModel.price,_productModel.discountPrice];
    //    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:str3];
    //    NSString *str4 = [NSString stringWithFormat:@"￥%@",_productModel.price];
    //    [string3 addAttributes:@{NSForegroundColorAttributeName:BaseColor} range:[str3 rangeOfString:str4]];
    //    NSString *str5 = [NSString stringWithFormat:@" %@",_productModel.discountPrice];
    //    [string3 addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[str3 rangeOfString:str5]];
    _priceLabel.text = str3;
    
    
    CGFloat priceLabelWidth = [str3 boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    CGRect labelRect = _discountLabel.frame;
    labelRect.origin.x = _priceLabel.left + priceLabelWidth + 3;
    labelRect.size.width = 150 - priceLabelWidth - 3;
    _discountLabel.frame = labelRect;
    NSString *str4 = [NSString stringWithFormat:@"%.2f",[_productModel.price doubleValue]];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:str4 attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor]}];
    _discountLabel.textColor = [UIColor grayColor];
    _discountLabel.attributedText = string3;
    
    
    _buyCountLabel.text = [NSString stringWithFormat:@"%@人购买",_productModel.buyedCount];
    
    _goodsContentLabel.text = _productModel.content;
    CGFloat height = [_goodsContentLabel.text boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 1000000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGRect rect = _goodsContentLabel.frame;
    rect.size.height = height;
    _goodsContentLabel.frame = rect;
    
    CGRect rect2 = _bgView1.frame;
    rect2.size.height = _goodsContentLabel.bottom + 10;
    _bgView1.frame = rect2;
    
    CGRect rect3 = _bgView2.frame;
    rect3.origin.y = _bgView1.bottom;
    _bgView2.frame = rect3;
    
    [_detailWeb loadHTMLString:_productModel.detail baseURL:nil];
    
    _conmentCountLabel.text = [NSString stringWithFormat:@"用户评价(%@)",_productModel.commentCount];
    CGRect rect4 = _bgView3.frame;
    rect4.origin.y = _bgView2.bottom + 15;
    _bgView3.frame = rect4;
    
    [_bgScroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom + 20)];
}

    //添加推荐商品
- (void)addRecommendGoods
{
    UIView *view = [_bgView3 viewWithTag:15];
    UIView *view2 = [_bgView3 viewWithTag:16];
    [view2 removeFromSuperview];
    [view removeFromSuperview];
    
    CGFloat width = (UI_SCREEN_WIDTH - 30) / 2.0;
    for (BaseCellModel *model in _goodsArray) {
        CellView *cellView = [CellView buttonWithType:UIButtonTypeCustom];
        cellView.frame = CGRectMake(10 + (width + 10) * [_goodsArray indexOfObject:model], 140, width, width + 70);
        [cellView initGUIWithData:model];
        [cellView addTarget:self action:@selector(recommendGoodClick:) forControlEvents:UIControlEventTouchUpInside];
        cellView.tag = 15 + [_goodsArray indexOfObject:model];
        [_bgView3 addSubview:cellView];
        
        CGRect rect = _bgView3.frame;
        rect.size.height = cellView.bottom + 10;
        _bgView3.frame = rect;
        _bgScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom);
    }
    
}

- (void)recommendGoodClick:(UIButton *)btn
{
    BaseCellModel *model = [_goodsArray objectAtIndex:btn.tag - 15];
    GoodsVC *vc = [[GoodsVC alloc] init];
    vc.goodsId = model.modelId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - webview  代理方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
//    CGFloat webViewHeight = [scrollView contentSize].height;
    
        //JS 方法
    NSString *curHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.height"];
    
    CGRect newFrame = _detailWeb.frame;
    newFrame.size.height = [curHeight floatValue];
    _detailWeb.frame = newFrame;
    
    CGRect rect = _bgView2.frame;
    rect.size.height = _detailWeb.bottom;
    _bgView2.frame = rect;
    
    CGRect rect4 = _bgView3.frame;
    rect4.origin.y = _bgView2.bottom + 15;
    _bgView3.frame = rect4;

    
    [_bgScroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _bgView3.bottom + 20)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView 代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel *model;
    if (collectionView.tag == 10) {
        model = _attributeArray[indexPath.row];
    }else {
        model = _sizeArray[indexPath.row];
    }
    CGFloat width = [model.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    if (width <= collectionView.width) {
        return CGSizeMake(width + 10, 30);
    }else {
        return CGSizeMake(collectionView.width, 30);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 10) {
        return [_attributeArray count];
    }
    return [_sizeArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    cell.titleLabel.frame = cell.bounds;
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.titleLabel.textColor = [UIColor blackColor];
    BaseCellModel *model;
    if (collectionView.tag == 10) {
        model = _attributeArray[indexPath.row];
        if ([_currentAttributeIndex isEqual:indexPath]) {
            cell.backgroundColor = BaseColor;
            cell.titleLabel.textColor = [UIColor whiteColor];

        }
    }else {
        if ([_currentSizeIndex isEqual:indexPath]) {
            cell.backgroundColor = BaseColor;
            cell.titleLabel.textColor = [UIColor whiteColor];

        }
        model = _sizeArray[indexPath.row];
    }
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 10) {
        if ([_currentAttributeIndex isEqual:indexPath]) {
            _currentAttributeIndex = nil;
        }else {
            _currentAttributeIndex = indexPath;
        }
    }else {
        if ([_currentSizeIndex isEqual:indexPath]) {
            _currentSizeIndex = nil;
        }else {
            _currentSizeIndex = indexPath;
        }
    }
    [collectionView reloadData];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
