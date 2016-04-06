//
//  CreatCodeVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/29.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import "CreatCodeVC.h"
#import <CoreImage/CoreImage.h>

@interface CreatCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *qRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barCodeLabel;

@end

@implementation CreatCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)creatButtonClick:(UIButton *)sender {
    
    _qRCodeImageView.image = [self generateQRCode:@"上山打老虎" width:304 height:304];
    _barCodeImageView.image = [self generateBarCode:_textField.text width:240 height:70];
    _barCodeLabel.text = _textField.text;
    
}

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height{
    //生成二维码
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    //CIQRCodeGenerator 主流二维码格式
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    /*
     *  设置容错率L：7% M:15% Q：25% H：30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width/qrcodeImage.extent.size.width;
    CGFloat scaleY = height/qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    if ([code isEqualToString:@""]) {
        code = @"123456789012345678";
    }
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding];
    //设置条形码格式
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)creatQRCode:(NSString *)string
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *image = [filter outputImage];
    return [UIImage imageWithCIImage:image];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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


























