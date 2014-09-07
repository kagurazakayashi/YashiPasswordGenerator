//
//  PasswordPower.m
//  YashiPasswordGenerator-OSX
//
//  Created by 神楽坂雅詩 on 14/9/7.
//  Copyright (c) 2014年 Kagurazaka Yashi. All rights reserved.
//

#import "PasswordPower.h"

@implementation PasswordPower
+ (BOOL)judgeRange:(NSArray*)_termArray Password:(NSString*)_password
{
    NSRange range;
    
    BOOL result =NO;
    
    for(int i=0; i<[_termArray count]; i++)
        
    {
        
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        
        if(range.location != NSNotFound)
            
        {
            
            result =YES;
            
        }
        
    }
    
    return result;
}

+ (int)judgePasswordStrength:(NSString*)_password
{
    if (_password.length == 0) {
        return 0;
    }
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/", nil];
    
    
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    
    
    int intResult=0;
    
    for (int j=0; j<[resultArray count]; j++)
        
    {
        
        
        
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
            
        {
            
            intResult++;
            
        }
        
    }
    
    int resultString = 0;
    
    if (intResult <2)
        
    {
        
        resultString = 1;
        
    }
    
    else if (intResult == 2&&[_password length]>=6)
    
    {
        
        resultString = 2;
        
    }
    
    if (intResult > 2&&[_password length]>=6)
        
    {
        
        resultString = 3;
        
    }
    
    
    
    return resultString;
}

@end
