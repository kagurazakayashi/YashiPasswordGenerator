//
//  ViewController.m
//  YashiPasswordGenerator-OSX
//
//  Created by 神楽坂雅詩 on 14/9/6.
//  Copyright (c) 2014年 Kagurazaka Yashi. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    numtext.delegate = self;
    longtext.delegate = self;
}

- (IBAction)start:(NSButton *)sender {
    output.stringValue = @"";
    pro.doubleValue = 0.0;
    spro.doubleValue = 0.0;
    pro.maxValue = numtext.doubleValue;
    spro.maxValue = longtext.doubleValue;
    if ([self chkok:numtext] && [self chkok:longtext]) {
        all = numtext.integerValue * longtext.integerValue;
        NSMutableString *allchars = [NSMutableString string];
        if (zmo.state > 0) {
            [allchars insertString:chars.stringValue atIndex:0];
        }
        if (zm3.state > 0) {
            [allchars insertString:@"0123456789" atIndex:0];
        }
        if (zm2.state > 0) {
            [allchars insertString:@"abcdefghijklmnopqrstuvwxyz" atIndex:0];
        }
        if (zm1.state > 0) {
            [allchars insertString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" atIndex:0];
        }
        if (allchars.length > 0) {
            sender.enabled = NO;
            sender.title = @"计算中...";
            NSNumber *num = [NSNumber numberWithInteger:numtext.integerValue];
            NSNumber *leng = [NSNumber numberWithInteger:longtext.integerValue];
            NSArray *info = [NSArray arrayWithObjects:num,leng,allchars, nil];
            if (allchars.length > 0) {
                NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadInMainMethod:) object:info];
                [myThread start];
            }
        } else {
            output.stringValue = @"请从字库选择素材字符。";
        }
    } else {
        output.stringValue = @"参数输入错误(包含非整数字符或大于1024)，请检查标记为红色的字段。";
    }
}

//- (NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject {
//    NSString *str = tokenField.stringValue;
//    [self chkok:numtext];
//    [self chkok:longtext];
//    return str;
//}

- (BOOL)chkok:(NSTokenField *)sb
{
    if (sb.stringValue == 0) {
        return NO;
    }
    NSString *str = sb.stringValue;
    int isOK = 0;
    for (int i = 0; i < str.length; i++) {
        NSString *nowStr = [str substringWithRange:NSMakeRange(i, 1)];
        for (int j = 0; j < 10; j++) {
            NSString *nowNum = [NSString stringWithFormat:@"%d",j];
            if ([nowStr isEqualToString:nowNum]) {
                isOK++;
                break;
            }
        }
    }
    if (isOK == str.length && str.integerValue < 1024) {
        sb.textColor = [NSColor blackColor];
//        [startbtn setEnabled:YES];
    } else {
        isOK = NO;
        sb.textColor = [NSColor redColor];
//        [startbtn setEnabled:NO];
    }
    return isOK;
}

- (void)threadInMainMethod:(NSArray *)info
{
    NSString *allchars = [info objectAtIndex:2];
    NSNumber *numN = [info objectAtIndex:0];
    NSNumber *lengN = [info objectAtIndex:1];
    NSInteger num = numN.integerValue;
    NSInteger leng = lengN.integerValue;
    NSMutableString *end = [NSMutableString string];
    for (NSInteger numi = 0; numi < num; numi++) {
        if (numi > 0) {
            [end insertString:@"\n" atIndex:end.length-1];
        }
        for (NSInteger lengi = 0; lengi < leng; lengi++) {
            NSNumber *lengj = [NSNumber numberWithInteger:lengi];
            [self performSelectorOnMainThread:@selector(updatespro:) withObject:lengj waitUntilDone:YES];
            int rand = arc4random() % allchars.length;
            NSString *nowChar = [allchars substringWithRange:NSMakeRange(rand, 1)];
            [end insertString:nowChar atIndex:end.length];
        }
        NSNumber *numj = [NSNumber numberWithInteger:numi];
        [self performSelectorOnMainThread:@selector(updatepro:) withObject:numj waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(okay:) withObject:end waitUntilDone:YES];
}

- (void)okay:(NSString *)end {
    output.stringValue = end;
    pro.doubleValue = pro.maxValue;
    spro.doubleValue = spro.maxValue;
    startbtn.enabled = YES;
    startbtn.title = @"开始生成";
}

- (void)updatepro:(NSNumber *) val{
    pro.doubleValue = val.doubleValue;
    NSInteger nowp = pro.doubleValue*spro.doubleValue;
    float ppp = (float)nowp / (float)all * 100.0;
    output.stringValue = [NSString stringWithFormat:@"处理进度： %ld / %ld ( %f %% )",(long)nowp,(long)all,ppp];
}

- (void)updatespro:(NSNumber *) val{
    spro.doubleValue = val.doubleValue;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
                                    
    // Update the view, if already loaded.
                                
}

- (void)viewDidDisappear {
    exit(0);
}

@end
