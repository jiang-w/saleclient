//
//  QRCodeScanViewController.h
//  saleclient
//
//  Created by Frank on 15/12/14.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property(strong,nonatomic) AVCaptureDevice *device;
@property(strong,nonatomic) AVCaptureDeviceInput *input;
@property(strong,nonatomic) AVCaptureMetadataOutput *output;
@property(strong,nonatomic) AVCaptureSession *session;
@property(strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@end
