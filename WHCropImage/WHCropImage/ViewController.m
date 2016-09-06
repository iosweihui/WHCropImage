//
//  ViewController.m
//  WHCropImage
//
//  Created by 魏辉 on 16/9/5.
//  Copyright © 2016年 Weihui. All rights reserved.
//

#import "ViewController.h"
#import "CropImageViewController.h"
#import "UIImage+FixOrientation.h"

@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cropImageBtn;
@property (nonatomic,strong)UIImagePickerController *Imgpicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cropImageBtn addTarget:self action:@selector(cropImageBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}


- (void)cropImageBtnAction{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"相册选择", nil];
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name: @"CropOK" object: nil];
    if (buttonIndex == 0) {
        [self openCamera];
    }else if(buttonIndex == 1){
        [self openAlbum];
    }
}


#pragma mark cameraOrAlbum
- (void)openCamera{
    
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}
#pragma mark 调取本地相册
- (void)openAlbum{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
    
}

// 选择图像完成之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    CropImageViewController *cropImg = [[CropImageViewController alloc] initWithCropImage:image];
    self.Imgpicker = picker;
    [picker presentViewController:cropImg animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissPickerAction:) name:@"DISSMISSPICKER" object:nil];
    }];
    
    
}

- (void)notificationHandler: (NSNotification *)notification {
    
    [self.cropImageBtn setImage:notification.object forState:(UIControlStateNormal)];
    
}

- (void)dissmissPickerAction:(NSNotification *)notification{
    [self.Imgpicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
