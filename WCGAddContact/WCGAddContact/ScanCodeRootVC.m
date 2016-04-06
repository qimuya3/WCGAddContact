//
//  ScanCodeRootVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/30.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import "ScanCodeRootVC.h"
#import "ScanCodeVC.h"

@interface ScanCodeRootVC ()<ScanCodeVCDelegate>

@end

@implementation ScanCodeRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)scanCodeButton:(UIButton *)sender {
    
    ScanCodeVC *vc = [[ScanCodeVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanCodeStopWithResultString:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
