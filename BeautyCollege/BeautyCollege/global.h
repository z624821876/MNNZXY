//
//  global.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"
#import "DateUtil.h"
#import "UIView+Sizes.h"
#import "BaseCell.h"
#import "HttpManager.h"
#import "tools.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyTool.h"
#import "LoginVC.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "User.h"

#ifdef DEBUG
#define DDLog(...) NSLog(__VA_ARGS__)
#define DDMethod() NSLog(@"%s", __func__)
#else
#define DDLog(...)
#define DDMethod()
#endif

#ifndef global_h
#define global_h

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_SCREEN_WIDTH                 [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height

#define UI_scaleX                       UI_SCREEN_WIDTH / 320.0
#define UI_scaleY                       UI_SCREEN_HEIGHT / 480.0


#define LOAD_MORE_TEXT_HEIGHT 77
// 显示文字阈值
#define LOAD_MORE_THRESHOLD (UI_SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - LOAD_MORE_TEXT_HEIGHT)
// 刷新阈值
#define LOAD_MORE_MAX       (LOAD_MORE_THRESHOLD + 10.0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#define ColorWithRGBA(r,g,b,a)  [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]


/****************显示坐标位置*****************************/
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO)

#define CGRectMake_Nav_Status(x,y,width,hight) iOS7?CGrectMake(x,y,y + UI_STATUS_BAR_HEIGHT + UI_NAVIGATION_BAR_HEIGHT,hight):CGRectMake(x,y,width,hight)

#define CGRectMake_Status(x,y,width,higth) iOS7?CGRectMake(x,y + UI_STATUS_BAR_HEIGHT,width,higth)

/**********************************************/

#define PATH_OF_APPITEMIMAGE [NSString stringWithFormat:@"%@/appitemimage", PATH_OF_DOCUMENT]

#define nilOrJSONObjectForKey(JSON_, KEY_) [[JSON_ objectForKey:KEY_] isKindOfClass:[NSNull class]] ? nil : [JSON_ objectForKey:KEY_];

//static NSString * const sBaseJsonURLStr = @"http://cm.o2o2m.com:8083";

static NSString * const sBaseUrlStr = @"http://nzxyadmin.53xsd.com/";
static NSString * const sBaseImgUrlStr = @"http://nzxyimage.53xsd.com/meiniang";

static NSString * const sBaseJsonURLStr = @"http://beauty.o2o2m.com";
//http://gaoxinquan.xasd.com.cn/
static NSString * const sBaseJsonURLStrWeb = @"http://admin.o2o2m.com/";

//static NSString * const sBaseUploadUrlStr = @"http://admin.sunday-mobi.com/";
static NSString * const sBaseUploadUrlStr = @"http://cmadmin.o2o2m.com";

//static NSString * const sVersionDownloadURL = @"itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/j3qyypwp0hds8xp/zdtc.plist";
//static NSString * const sVersionDownloadURL = @"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/sunwen812645842/sunday/master/mein2.plist";
//static NSString *const sVersionRequestURL = @"https://raw.githubusercontent.com/sunwen812645842/sunday/master/mein2.plist";

static NSString * const sVersionDownloadURL = @"itms-services://?action=download-manifest&url=https://app.hdtht.com/ios/sunday/mnxy.plist";

static NSString * const sVersionURL = @"http://vipstatic.sunday-mobi.com/download/mnxy/ios/versions.plist";

// 项目名称
static NSString * const sAppName = @"NZXY";
static NSString * const sProjectId = @"0";

#define dbPath [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"thedb.sqlite"]

#define APP_LOGIN_KEY @"www.ZDTC.com/loginKey"
#define KEY_USERNAME_PASSWORD @"com.ZDTC.usernamepassword"
#define KEY_USERNAME @"com.ZDTC.username"
#define KEY_PASSWORD @"com.ZDTC.password"
#define KEY_USERMODEL @"com.ZDTC.userModel"
#define KEY_USERID @"userID"
#define KEY_Phone @"mobile"//用户账号

#define KEY_NICKNAME @"nickname"//用户账号
#define KEY_LOGOIMG  @"logoimgae"//用户头像
#define KEY_device  @"jiance"//用户头像




#pragma mark 记录是否查看设备列表
#define KEY_Select1 @"select1"

#define KEY_Select2 @"select2"
#define KEY_Select3  @"select3"


#define infoTypeNone    @"0" //HtmlDetailVC不显示toolbar
#define infoTypeInfo    @"1"
#define infoTypeActivity @"2"
#define infoTypeProduct @"3"
#define infoTypeVote    @"4"


#define kUserDefaultsEverLaunch @"kEverLaunch"
#define kUserDefaultsAppHasDownload @"kAppHasDownload"


#define kUserDefaultsLastVersionCheckDate @"kAppVersionCheckDate"

static NSString * const jsonErrLogSave = @"errlog_save?1=1";
static NSString * const jsonAppStartNumber = @"startnumber?1=1";  //启动数
static NSString * const jsonAppDownload = @"writedownload?1=1";   //下载量
static NSString * const jsonLogin = @"shandi/expertLogin?1=1";   //登录
static NSString * const jsonFavorite = @"collect?1=1";
static NSString * const jsonPinglun =@"review?1=1";
static NSString * const jsonCustomerList = @"customer/list_customer?1=1";
static NSString * const jsonCustomerAdd = @"customer/add_customer?1=1";
static NSString * const jsonLinkmanList = @"customer/list_contact?1=1";
static NSString * const jsonLinkmanAdd = @"customer/add_contact?1=1";
static NSString * const jsonVisitList = @"customer/list_visit?1=1";
static NSString * const jsonVisitAdd = @"customer/add_visit?1=1";
static NSString * const jsonPostAdd = @"mdm/addBlog?1=1";                   // 留言保存
static NSString * const jsonPostReplyAdd = @"shandi/saveReplay?1=1";                 // 留言回复   
//static NSString * const jsonPostReplyAdd = @"/shandi/saveAskReplay?1=1";           
static NSString * const jsonPersonInfoAdd = @"/member/editInfo?1=1";         // 修改资料
//static NSString * const jsonPersonPasswordAdd = @"upppwd/?1=1";
static NSString * const jsonPersonPasswordAdd = @"/member/modifyPwd?1=1"; // 修改密码
static NSString * const jsonBookDetial = @"book/detail?1=1";

static NSString * const jsonLoginin = @"/mobi/account/log?1=1";        // 登陆
static NSString * const jsonZhuce = @"/member/regist?1=1";         // 注册
static NSString * const jsonDongTai = @"/teach/trend?1=1";         // 动态
static NSString * const jsonTeachInfo = @"/teach/infos?1=1";       //教学信息
static NSString * const jsonTeachItem = @"/teach/items?1=1";       //教学分类
static NSString * const jsonHuoDong = @"/club/active/getAll?1=1";   //获取全部活动
static NSString * const jsonCYLM = @"/indu/search?1=1";            //获取产业联盟列表
static NSString * const jsonCYLM2 = @"/company/search?1=1";            //获取公司列表
static NSString * const jsonSPList = @"/video/search?1=1";            //获取视频课堂列表

static NSString * const jsonGetCode= @"/member/getCode?1=1";         // 获取验证码
static NSString * const jsonCodeSure= @"/member/code/check?1=1";         // 检查验证码是否正确
static NSString * const jsonFavoriteSave= @"/member/favorite/save?1=1";    // 收藏
static NSString * const jsonFavoriteSaveDelete= @"/member/favorite/remove?1=1";    // 取消收藏
static NSString * const jsonCommentSave= @"/mobi/class/addReply?1=1";    // 评论
static NSString * const jsonPortalList= @"/info/getPortalList?itemId=194";  //项目资金连接
static NSString * const jsonActiveSigned= @"/club/active/signed?1=1";    //活动报名
static NSString * const jsonGetFriend= @"/contact/friend?1=1";     // 获取好友列表
static NSString * const jsonGetClass= @"/class/list?1=1";          // 获取我的班级列表
static NSString * const jsonGetGroup= @"/group/list?1=1";          // 获取我的群组
static NSString * const jsonClassFriend= @"/contact/class?1=1";    // 获取我的班级好友
static NSString * const jsonRules= @"/info/getPortalList?itemId=199";    // 获取规章制度
static NSString * const jsonDCWZ= @"/info/getPortalList?itemId=201";    // 获取地产文章
static NSString * const jsonJDYD = @"/company/search?itemId=188";   // 获取酒店预定
static NSString * const jsonFavoriteList = @"/member/favorite/list?1=1";   // 我的收藏
static NSString * const jsonVideoList = @"/video/search?1=1";   // 我的收藏
static NSString * const jsonGetCityList = @"/city/list?1=1";   // 我的城市列表
static NSString * const jsonSearchFriend = @"/class/student/search?1=1";   // 查找同学
static NSString * const jsonSearchGroup = @"/group/search?1=1";   // 查找群组
static NSString * const jsonInviteGroup = @"/group/invite?1=1";   // 邀请好友入群组
static NSString * const jsonPermissionSet = @"/friend/permission/update?1=1";   // 修改用户权限
static NSString * const jsonCompanyAdvice = @"/member/editCompanyInfo?1=1";   // 企业资料修改
static NSString * const jsonMateMeeting = @"/item/getitem?itemId=216"; // 同学会
static NSString * const jsonMateMeeting_1 = @"/info/getPortalList?1=1"; // 同学会列表
static NSString * const jsonMessageList = @"/message/list?1=1"; // 系统消息
static NSString * const jsonFriendAudit = @"/friend/audit?1=1"; // 好友审核
static NSString * const jsonClassAll = @"/class/getAll?1=1"; // 获取全部班级
static NSString * const jsonMemberInfo = @"/member/getById?1=1"; // 根据用户编号获取用户信息
// 面对面
static NSString * const jsonUserInfo = @"personalCenter/userInfo?1=1"; //面对面用户信息
static NSString * const jsonPostDetail = @"mdm/getDetail?1=1"; //面对面详细页面
static NSString * const sBaseUploadImagePrefix = @"http://image2.o2o2m.com/tongchuang";  //图片前缀（拼接在数据库中的/2013/8/d88c4e43-f537-4cf9-bf40-deaafe826b1c.jpg）

static NSString * const jsonReplyDelete = @"mdm/deleteReply?1=1"; //删除回帖
static NSString * const jsonPostList = @"mdm/getBlogList?1=1";     //面对面帖子列表

static NSString * const jsonCommentList = @"/info/comment/list?1=1";     //评论列表
static NSString * const jsonFriendAdd = @"/friend/add?1=1";     // 添加好友
static NSString * const jsonGetPortalListAdd = @"/info/getPortalList?1=1";     // 地产文章
static NSString * const jsonGetDCWZTypeAdd = @"/item/getitem?itemId=242";     // 获取地产文章分类
static NSString * const jsonKeFuAdd = @"/contact/kefu?1=1";     // 客服列表
static NSString * const jsonJQKTBMAdd = @"/teach/courseSignUp?1=1";     // 客服列表

static NSString * const jsonContactGroups = @"/contact/group?1=1";// 群组列表哦.
static NSString * const jsonRemoveGoodFriend = @"/friend/remove?1=1";//   解除好友.
static NSString * const jsonBlogDelete = @"/blog/delete?1=1";// 面对面删除帖子
static NSString * const jsonItemInfos = @"/item/infos?1=1";// 找资金找项目

//关于聚智/
static NSString * const JZOpenfireServerHost = @"openfire1.o2o2m.com";
static NSString * const JZOpenfireServerPort = @"5224";
static NSString * const jsonJZAdList = @"/item/infos?1=1";// 聚智项目拿资讯图.
static NSString * const jsonJZGongGaoList = @"/news/list?1=1";// 新闻.

static NSString * const jsonDeviceJZList = @"/device/list?1=1";// 设备.机主
static NSString * const jsonDeviceGCYZList = @"/device/getDeviceByMaster?1=1";// 设备.工程业主
static NSString * const jsonDeviceYWXGList = @"/device/getDeviceRelateMe?1=1";// 设备.与我相关
static NSString * const jsonDevicePerson = @"/device/member?1=1";// 设备.与我相关
static NSString *  jsonSave = @"/device/save?1=1";//添加设备
static NSString *const jsonUpdate=@"/device/updateDeviceInfoByKey?1=1";//更新设备
static NSString * const jsonMyQuzen = @"/community/getMyblog?1=1";// 我的帖子
static NSString * const jsonMessage= @"/device/getAllMessages?1=1";// 我的消息
static NSString * const jsonAddPerson = @"/device/givePermission?1=1";     //添加成员

static NSString * const jsonJZSheQuList = @"/community/list?1=1";// 社区.

static NSString * const jsonJZActivityList = @"/active/list?1=1";// 聚智活动列表
static NSString * const jsonJZCompanyPersonsList = @"http://beauty.o2o2m.com/mobi/user/getUserList??1=1";// 聚智公司成员列表
static NSString * const jsonJZComapngZhongBangList = @"/blog/help/list?1=1";// 聚智 众帮 列表.
static NSString * const jsonJZComapngRegister = @"/member/regist?1=1";// 聚智 企业申请 列表.
static NSString * const jsonJZComapanyBlogList = @"/blog/list?1=1";// 聚智 圈子信息 列表.///blog/list
static NSString * const jsonJZComapanyAbout = @"/contact/about/gyjz?1=1";// 聚智 关于页面.
static NSString * const jsonJZComapanyBlogAdd = @"/community/saveBlog?1=1";// 聚智 加帖子.
static NSString * const jsonJZCompanyBlogReply = @"/blog/reply?1=1"; //圈子（或众帮）回复
static NSString * const jsonJZCompanyBlogDetailInfo = @"/blog/help/info?1=1";//获取众帮信息详情
static NSString * const jsonJZCompanyFavoriteSave = @"/member/favorite/save?1=1";// 聚智 的收藏 可以通过类型来做.
static NSString * const jsonJZComapanyBlogDelete = @"/blog/delete?1=1";// 面对面删除帖子///blog/list

static NSString * const jsonJZComapyActiveSigned = @"/active/signed?1=1";// 聚智 活动 报名.
static NSString * const jsonJZComapyFeedback = @"/returnYJ?1=1";// 聚智 反馈
static NSString * const jsonJZComapyForgetPwd = @"/member/forgetPwd?1=1";// 聚智 忘记密码.
static NSString * const jsonJZComapyXGPwd = @"/member/editPwd?1=1";// 聚智 修改密码
static NSString * const jsonJZCompanyBlogLike = @"/blog/blog/laud?1=1";// 聚智 点赞哦.
static NSString * const jsonCreatCourse = @"/mobi/class/addLesson?1=1";// 聚智 点赞哦.
static NSString * const jsonCourse = @"/mobi/class/getClass?1=1";// 推荐课堂和学生 课程作业的接口.
static NSString * const jsonAllCourse = @"/mobi/class/getLessons?1=1";// 全部课堂.
static NSString * const jsonAttCourse = @"/mobi/class/getMyLesson?1=1";// 创建课堂和参加课堂.
static NSString * const jsonAddHomeWork = @"/mobi/class/addHomework?1=1";// 聚智 点赞哦.
static NSString * const jsonHomeWork = @"/mobi/class/getHomework?1=1";//获取作业列表.
static NSString * const jsonHomeWorkDetal = @"/mobi/class/getHomeworkDetail?1=1";//获取作业列表.

typedef enum{   //4种状态, 可用于各种情况，比如异步变同步时作标志位
    FlagWait,
    FlagNoWait,
    FlagSuccess,
    FlagFailure,
}WaitFlag;

//个推
#define kGTAppId           @"zPayDHslMA9rE4MJavgI26"
#define kGTAppKey          @"1uaQKV5DM3AECHjnSwMo8"
#define kGTAppSecret       @"pdNd8d47AV8Wsmq34ZqFr"

//友盟
#define kUMkey          @"54c7576ffd98c5acfd0007ce"
//微信
#define kWXid           @"wxe76f86152b5841f0"
#define kWXSecret       @"1453160f0fbddb202e2f27b2fbc5f4fc"
//qq
#define kqqid           @"1104151303"
#define kqqkey          @"k4ZqjkcwuvPknK4k"

#define BaseColor       [Util uiColorFromString:@"#e1008c"]

#define HUDShowErrorServerOrNetwork [[tools shared] HUDShowHideText:@"服务器或网络异常" delay:2];

#endif
