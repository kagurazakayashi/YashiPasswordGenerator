//
//  PasswordPower.h
//  YashiPasswordGenerator-OSX
//
//  Created by 神楽坂雅詩 on 14/9/7.
//  Copyright (c) 2014年 Kagurazaka Yashi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordPower : NSObject
+ (BOOL)judgeRange:(NSArray*)_termArray Password:(NSString*)_password;
+ (int)judgePasswordStrength:(NSString*)_password;
@end
