//
//  QRCodeViewController.m
//  saleclient
//
//  Created by Frank on 15/12/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "QRCodeViewController.h"
#import "OSNProductManager.h"
#import "OSNMainNavigation.h"
#import "ProductDetailViewController.h"
#import "MasterViewController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIView                     *scanRectView;
@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCamera];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 40, 100, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 4, 6, 4);
    backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    backBtn.layer.borderWidth = 1;
    backBtn.layer.cornerRadius = 5;
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupCamera {
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    
    CGSize scanSize = CGSizeMake(windowSize.height/2, windowSize.height/2);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2,
                                 scanSize.width, scanSize.height);
    //计算rectOfInterest 如果是竖屏x,y交换位置
    scanRect = CGRectMake(scanRect.origin.x/windowSize.width, scanRect.origin.y/windowSize.height,
                          scanRect.size.width/windowSize.width, scanRect.size.height/windowSize.height);
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    self.output.rectOfInterest = scanRect;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    // 设置摄像头取景方向
    self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanRectView.layer.borderWidth = 1;
    [self.scanRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(scanSize.width, scanSize.height));
    }];
    
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.textColor=[UIColor orangeColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内";
    [self.view addSubview:labIntroudction];
    [labIntroudction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scanRectView.mas_bottom).offset(10);
    }];
    
    //开始捕获
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ( (metadataObjects.count == 0) ) {
        return;
    }
    
    if (metadataObjects.count > 0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        NSString *qrCodeUrl = metadataObject.stringValue;
        OSNProductManager *manager = [[OSNProductManager alloc] init];
        NSString *productId = [manager getProductDetailWithQRCodeUrl:qrCodeUrl];
        if (productId && productId.length > 0) {
            [self dismissViewControllerAnimated:NO completion:nil];
            
            MasterViewController *masterVC = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
            masterVC.currentIndex = 2;
            
            ProductDetailViewController *detail = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
            detail.productId = productId;
            
            OSNMainNavigation *nav = (OSNMainNavigation *)self.presentingViewController;
            [nav pushViewController:masterVC animated:NO];
            [nav pushViewController:detail animated:NO];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无效的二维码" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.session startRunning];
}

@end
