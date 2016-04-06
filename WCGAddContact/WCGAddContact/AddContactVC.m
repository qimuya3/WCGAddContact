//
//  AddContactVC.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/25.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import "AddContactVC.h"
#import <Contacts/Contacts.h>

@interface AddContactVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *xingTextField;
@property (weak, nonatomic) IBOutlet UITextField *mingTextField;

@end

@implementation AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)headerButton:(UIButton *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"相簿PhotoLibrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerC = [[UIImagePickerController alloc]init];
        imagePickerC.delegate = self;
        imagePickerC.allowsEditing = YES;
        imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePickerC animated:YES completion:nil];
    }];
    UIAlertAction *alertActi = [UIAlertAction actionWithTitle:@"照片SavedPhotosAlbum" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerC = [[UIImagePickerController alloc]init];
        imagePickerC.delegate = self;
        imagePickerC.allowsEditing = YES;
        imagePickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.navigationController presentViewController:imagePickerC animated:YES completion:nil];
    }];
    UIAlertAction *alertAc = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerC = [[UIImagePickerController alloc]init];
            imagePickerC.delegate = self;
            imagePickerC.allowsEditing = YES;
            imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:imagePickerC animated:YES completion:^{
                
            }];
        }
        else
        {
            NSLog(@"不支持相机");
        }
    }];
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:alertA];
    [alertC addAction:alertAc];
    [alertC addAction:alertAct];
    [alertC addAction:alertActi];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

//这里调用相机是系统自带的，默认为英文，可以修改为中文（cancel-->取消）
//info.plist中设置Localization native development region为China

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _headerImageView.image = image;
}

- (IBAction)addButton:(UIButton *)sender {
    //创建CNMutableContact对象
    CNMutableContact *contact = [[CNMutableContact alloc]init];
    //设置联系人头像
    contact.imageData = UIImagePNGRepresentation(_headerImageView.image);
    //设置联系人姓名
    contact.familyName = _xingTextField.text;
    contact.givenName = _mingTextField.text;
    //设置联系人电话
    contact.phoneNumbers= @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"15565615495"]]];
    
    //创建添加联系人请求CNSaveRequest
    //初始化方法
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc]init];
    //添加联系人
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    
    //进项联系人的写入操作CNContactStore
    CNContactStore *store = [[CNContactStore alloc]init];
    [store executeSaveRequest:saveRequest error:nil];
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
