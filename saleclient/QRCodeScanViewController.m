//
//  QRCodeScanViewController.m
//  saleclient
//
//  Created by Frank on 15/12/14.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "QRCodeScanViewController.h"

@interface QRCodeScanViewController ()

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(252, 237, 226);
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    labIntroudction.textColor=[UIColor blackColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内";
    [self.view addSubview:labIntroudction];
    [labIntroudction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-180);
    }];
    
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
    
    [self setupCamera];
}

- (void)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupCamera {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = 360;
    CGFloat hight = 360;
    CGFloat xOffset = (screenSize.width - width)/2;
    CGFloat yOffset = (screenSize.height - hight)/2;
    _preview.frame = CGRectMake(xOffset, yOffset, width, hight);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // 添加边框
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset - 10, yOffset - 10, width + 20, hight + 20)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];

    // Start
    [_session startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (!IS_EMPTY_STRING(stringValue)) {
            NSLog(@"%@",stringValue);
        }
    }];
}

@end
