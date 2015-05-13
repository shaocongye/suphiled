//
//  QRcodeViewController.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-6.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol QRcodeViewControllerDelegate <NSObject>

-(void)scanQRcodedidFinish:(NSString*)url;

@end


@interface QRcodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;


@property (retain,nonatomic) id<QRcodeViewControllerDelegate> delegate;

@end
