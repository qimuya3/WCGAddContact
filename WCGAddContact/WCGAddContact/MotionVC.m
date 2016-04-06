//
//  MotionVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/31.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import "MotionVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MotionVC ()

@end

@implementation MotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

#pragma mark- 摇动手机协议
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSLog(@"摇动开始****");
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"摇动开始++++");
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
    NSLog(@"摇动取消");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇动结束****");
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"摇动结束++++");
    }
}

- (IBAction)soundButtonClick:(UIButton *)sender {
    SystemSoundID soundIDTest = 0;
    
    CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:@"sound.wav" withExtension:nil];
    AudioServicesCreateSystemSoundID(url, &soundIDTest);
    
//    NSString *soundFilePath = [[NSBundle mainBundle]pathForResource:@"music" ofType:@"mp3"];
//    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundIDTest);
    AudioServicesPlaySystemSound(soundIDTest);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
