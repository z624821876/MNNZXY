//
//  NSString+LLStringCategory.h
//  wallet2
//
//  Created by ZC on 13-12-11.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SSStringCategory)
- (NSString *)getImageName;
- (NSString *)getImageType;
-(NSString *) stringByStrippingHTML;
- (NSString *)clearWhiteSpaceAndNewLine;
- (NSString *)trimString;
- (BOOL)isValidRechargeMoney;
- (BOOL)isPureNumber;
- (BOOL)isValidMobile;
@end
