//
//  User.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/24.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "User.h"
#define kUserId         @"userId"
#define kUserName       @"userName"
#define kNickname       @"nickname"
#define kLevel          @"level"
#define kLevelName      @"levelName"
#define kScore          @"score"
#define kLogo           @"logo"
#define kSex            @"sex"
#define kRegLink        @"regLink"
#define kRegLinkImg     @"regLinkImg"
#define ksignature      @"signature"
#define kcityName       @"cityName"

@implementation User

+ (User *)shareUser
{
    static User *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    
    return user;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:kUserId];
    [aCoder encodeObject:self.userName forKey:kUserName];
    [aCoder encodeObject:self.nickname forKey:kNickname];
    [aCoder encodeObject:self.level forKey:kLevel];
    [aCoder encodeObject:self.levelName forKey:kLevelName];
    [aCoder encodeObject:self.score forKey:kScore];
    [aCoder encodeObject:self.logo forKey:kLogo];
    [aCoder encodeObject:self.sex forKey:kSex];
    [aCoder encodeObject:self.regLink forKey:kRegLink];
    [aCoder encodeObject:self.regLinkImg forKey:kRegLinkImg];
    [aCoder encodeObject:self.signature forKey:ksignature];
    [aCoder encodeObject:self.cityName forKey:kcityName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.signature = [aDecoder decodeObjectForKey:ksignature];
        self.userId = [aDecoder decodeObjectForKey:kUserId];
        self.userName = [aDecoder decodeObjectForKey:kUserName];
        self.nickname = [aDecoder decodeObjectForKey:kNickname];
        self.level = [aDecoder decodeObjectForKey:kLevel];
        self.levelName = [aDecoder decodeObjectForKey:kLevelName];
        self.score = [aDecoder decodeObjectForKey:kScore];
        self.logo = [aDecoder decodeObjectForKey:kLogo];
        self.sex = [aDecoder decodeObjectForKey:kSex];
        self.regLink = [aDecoder decodeObjectForKey:kRegLink];
        self.regLinkImg = [aDecoder decodeObjectForKey:kRegLinkImg];
        self.cityName = [aDecoder decodeObjectForKey:kcityName];
    }
    
    return self;

}

@end
