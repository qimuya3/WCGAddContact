//
//  AccelerometerVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/4/1.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#import "AccelerometerVC.h"

@interface AccelerometerVC ()<UIAccelerometerDelegate>
{
    UILabel *_label;
    
    UIAccelerationValue _speedX;
    UIAccelerationValue _speedY;
}

@end

@implementation AccelerometerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, (SCREEN_HEIGHT-50)/2, 20, 20)];
    _label.backgroundColor = [UIColor redColor];
    [self.view addSubview:_label];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //召唤加速度传感器
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1.0/60.0;
    accelerometer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //获得的加速度要考虑到加速度传感器的原点是物理重心，而不是屏幕右上角
    //x轴方向的速度加上x轴方向获得的加速度
    _speedX += acceleration.x;
    //y轴方向的速度加上y轴方向获得的加速度
    _speedY += acceleration.y;
    //小方块将要移动到的x轴坐标
    CGFloat posX = _label.center.x + _speedX;
    //小方块将要移动到的y轴坐标
    CGFloat posY = _label.center.y - _speedY;
    //碰到屏幕边缘反弹
    if (posX < 0.0) {
        posX = 0.0;
        //碰到屏幕左边以0.4倍的速度反弹
        _speedX *= -1;
    }else if(posX > self.view.bounds.size.width){
        posX = self.view.bounds.size.width;
        //碰到屏幕右边以0.4倍的速度反弹
        _speedX *= -1;
    }
    if (posY < 0.0) {
        posY = 0.0;
        //碰到屏幕上边不反弹
        _speedY *= -1;
    }else if (posY > self.view.bounds.size.height){
        posY = self.view.bounds.size.height;
        //碰到屏幕下边以1.5倍的速度反弹
        _speedY *= -1;
    }
    //移动小方块
    _label.center = CGPointMake(_label.center.x, posY);
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
