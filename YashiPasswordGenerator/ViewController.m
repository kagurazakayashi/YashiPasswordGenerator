//
//  ViewController.m
//  YashiPasswordGenerator-OSX
//
//  Created by 神楽坂雅詩 on 14/9/6.
//  Copyright (c) 2014年 Kagurazaka Yashi. All rights reserved.
//

#import "ViewController.h"
#import "PasswordPower.h"
#define MAXNUM 2048

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    numtext.delegate = self;
    longtext.delegate = self;
    firstStop = NO;
}

- (IBAction)start:(NSButton *)sender {
    [self startcalc:NO];
}
- (IBAction)test:(NSButton *)sender {
    [self startcalc:YES];
}
- (void)startcalc:(BOOL)istest
{
    time = [NSDate date];
    exitbtn.title = @"中止(Esc)";
    testmode = istest;
    power.intValue = 0;
    output.stringValue = @"";
    pro.doubleValue = 0.0;
    spro.doubleValue = 0.0;
    pro.maxValue = numtext.doubleValue;
    spro.maxValue = longtext.doubleValue;
    leng = longtext.integerValue * numtext.integerValue;
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
            startbtn.enabled = NO;
            testbtn.enabled = NO;
            if (istest) {
                testbtn.title = @"测试中...";
            } else {
                startbtn.title = @"计算中...";
            }
            NSNumber *num = [NSNumber numberWithInteger:numtext.integerValue];
            NSNumber *lengn = [NSNumber numberWithInteger:longtext.integerValue];
            NSNumber *istestNum = [NSNumber numberWithBool:istest];
            NSArray *info = [NSArray arrayWithObjects:num,lengn,allchars,istestNum, nil];
            if (allchars.length > 0) {
                myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadInMainMethod:) object:info];
                [myThread start];
            }
        } else {
            output.stringValue = @"请从字库选择素材字符。";
        }
    } else {
        output.stringValue = [NSString stringWithFormat:@"参数输入错误(包含非整数字符或大于%d)，请检查标记为红色的字段。",MAXNUM];
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
    if (isOK == str.length && str.integerValue <= MAXNUM) {
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
//    NSNumber *istestNum = [info objectAtIndex:3];
//    BOOL istest = istestNum.boolValue;
    NSInteger num = numN.integerValue;
    NSInteger lengn = lengN.integerValue;
    NSMutableString *end = [NSMutableString string];
    for (NSInteger numi = 0; numi < num; numi++) {
        if ([[NSThread currentThread] isCancelled])
        {
            break;
        }
        if (numi > 0) {
            [end insertString:@"\n" atIndex:end.length-1];
        }
        for (NSInteger lengi = 0; lengi < lengn; lengi++) {
            if ([[NSThread currentThread] isCancelled])
            {
                break;
            }
            NSNumber *lengj = [NSNumber numberWithInteger:lengi];
            [self performSelectorOnMainThread:@selector(updatespro:) withObject:lengj waitUntilDone:YES];
            int rand = arc4random() % allchars.length;
            NSString *nowChar = [allchars substringWithRange:NSMakeRange(rand, 1)];
            [end insertString:nowChar atIndex:end.length];
        }
        NSNumber *numj = [NSNumber numberWithInteger:numi];
            [self performSelectorOnMainThread:@selector(updatepro:) withObject:numj waitUntilDone:YES];
    }
    if (num > 1) {
        NSString *endd = [end substringWithRange:NSMakeRange(end.length-1, 1)];
        [end deleteCharactersInRange:NSMakeRange(end.length-1, 1)];
        [end insertString:endd atIndex:0];
    }
    [self performSelectorOnMainThread:@selector(okay:) withObject:end waitUntilDone:NO];
    [NSThread exit];
}

- (void)okay:(NSString *)end {
    [myThread cancel];
    myThread = nil;
    NSMutableString *one = NSMutableString.string;
    for (int i = 0; i < end.length; i++) {
        NSString *nowchar = [end substringWithRange:NSMakeRange(i, 1)];
        if ([nowchar isEqualToString:@"\n"]) {
            break;
        } else {
            [one insertString:nowchar atIndex:one.length];
        }
    }
    power.intValue = [PasswordPower judgePasswordStrength:one];
    if (!testmode) {
        output.stringValue = end;
    } else if (!firstStop) {
        output.stringValue = [NSString stringWithFormat:@"处理进度： %ld / %ld ( 100 %% )\n用时：%@",leng,leng,[self otimestr]];
    }
    if (!firstStop) {
        pro.doubleValue = pro.maxValue;
        spro.doubleValue = spro.maxValue;
    }
    startbtn.enabled = YES;
    testbtn.enabled = YES;
    startbtn.title = @"生成(↩︎)";
    testbtn.title = @"测速(⇧↩︎)";
    exitbtn.title = @"退出(Esc)";
    firstStop = NO;
    
}
- (void)updatepro:(NSNumber *) val
{
    pro.doubleValue = val.doubleValue;
    NSInteger nowp = pro.doubleValue*spro.doubleValue;
    float ppp = (float)nowp / (float)all * 100.0;
    output.stringValue = [NSString stringWithFormat:@"处理进度： %ld / %ld ( %f %% )\n用时：%@",(long)nowp,(long)all,ppp,[self otimestr]];
}
- (IBAction)copybtn:(NSButton *)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]
               owner:self];
    [pb setString:output.stringValue forType:NSStringPboardType];
}

- (NSString *)otimestr
{
    NSDate *nowTime = [NSDate date];
    NSTimeInterval secondsBetweenDates= [time timeIntervalSinceDate:nowTime];
    int secCount = secondsBetweenDates * ( -1 );
    int smalldel = (secondsBetweenDates + secCount) * (-100);
    if (secCount == 0 && smalldel == 0) {
        return @"瞬间完成";
    }
    NSString *tmphh = [NSString stringWithFormat:@"%d",secCount/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(secCount/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",secCount%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    NSString *tmpsm = [NSString stringWithFormat:@"%d",smalldel];
    if ([tmpsm length] == 1)
    {
        tmpsm = [NSString stringWithFormat:@"0%@",tmpsm];
    }
    return [NSString stringWithFormat:@"%@:%@:%@.%@",tmphh,tmpmm,tmpss,tmpsm];
}
- (IBAction)exit:(NSButton *)sender {
    if (myThread && myThread.isExecuting) {
        firstStop = YES;
        [myThread cancel];
        myThread = nil;
        exitbtn.title = @"退出(Esc)";
    } else {
        exit(0);
    }
}

- (void)updatespro:(NSNumber *) val
{
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
