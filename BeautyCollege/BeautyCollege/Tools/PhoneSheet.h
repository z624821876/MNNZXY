//
//  PhoneSheet.h
//  mlh
//
//  Created by qd on 13-5-14.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneSheet : UIActionSheet <UIActionSheetDelegate>

- (id)initWithPhoneNumber:(NSString *)phoneNumber;

@end
