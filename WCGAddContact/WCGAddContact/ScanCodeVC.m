//
//  ScanCodeVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/30.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#define ScreenHigh [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "ScanCodeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanCodeVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    AVCaptureDevice *device;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *pLayer;
    AVCaptureMetadataOutput *mOutput;
}

@end

@implementation ScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 20);
    [button setTitle:@"回返" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未检测到相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    AVCaptureDeviceInput *dInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    mOutput = [[AVCaptureMetadataOutput alloc]init];
    [mOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围方法一：（默认CGRectMake（0 ，0 ，1 ，1）X，Y调换，宽高调换）（参照是横屏的左上角）
//    [mOutput setRectOfInterest:CGRectMake((124)/ScreenHigh,((ScreenWidth-220)/2)/ScreenWidth,220/ScreenHigh,220/ScreenWidth)];
    //设置扫描范围方法二：（标准坐标系转换为metadataOutput的坐标系）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandle:) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(((ScreenWidth-220)/2),124,220,220)];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    
//    UIView * maskView = [[UIView alloc] init];
//    maskView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
//    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
//    [self.view addSubview:maskView];
//    
//    //创建路径
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(maskView.frame), CGRectGetHeight(maskView.frame))];//绘制和透明黑色遮盖层一样的矩形
//    
//    //路径取反
//    [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, (CGRectGetHeight(self.view.frame)-200)/2.0, 200, 200)] bezierPathByReversingPath]];//绘制中间空白透明的矩形，并且取反路径。这样整个绘制的范围就只剩下中间的矩形和边界之间的部分
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = path.CGPath;//将路径交给layer绘制
//    [maskView.layer setMask:shapeLayer];//设置遮罩层
    
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:dInput]) {
        [session addInput:dInput];
    }
    if ([session canAddOutput:mOutput]) {
        [session addOutput:mOutput];
    }
    
    mOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    pLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    pLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    pLayer.frame = [[UIScreen mainScreen] bounds];
    [self.view.layer insertSublayer:pLayer atIndex:0];
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count]>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        [self.delegate scanCodeStopWithResultString:metadataObject.stringValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)notificationHandle:(NSNotification *)notification
{
    CGRect rect = CGRectMake(((ScreenWidth-220)/2),124,220,220);
    mOutput.rectOfInterest = [pLayer metadataOutputRectOfInterestForRect:rect];
}

- (IBAction)photoButton:(UIButton *)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",[info objectForKey:UIImagePickerControllerMediaType]);
    //选中的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
//    NSData *imageData = UIImagePNGRepresentation(image);
//    CIImage *ciImage = [CIImage imageWithData:imageData];
    //创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    //利用探测器探测数据
    NSArray *array = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    //取出探测到的数据
    if (array.count >= 1) {
        CIQRCodeFeature *result = [array objectAtIndex:0];
        [self.delegate scanCodeStopWithResultString:result.messageString];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",result.messageString);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)lightButton:(UIButton *)sender {
    if ([device hasTorch]&&[device hasFlash]) {
        
        [device lockForConfiguration:nil];
        if (sender.selected == NO) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            sender.selected = YES;
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            sender.selected = NO;
        }
        [device unlockForConfiguration];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
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
