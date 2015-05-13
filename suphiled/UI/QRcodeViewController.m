//
//  QRcodeViewController.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-6.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "QRcodeViewController.h"

@interface QRcodeViewController ()

@end

@implementation QRcodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"SuphiLED" image:[UIImage imageNamed:@"icon.png"] tag:0];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    CGRect screen = [ UIScreen mainScreen ].bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //iPhone
        [navigationBar setFrame:CGRectMake(0, 20, screen.size.width, 30)];
    } else {  //iPad
        [navigationBar setFrame:CGRectMake(0, 40, screen.size.width, 60)];
        
    }
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"SuphiLED"];
    
    
    //创建一个右边按钮
    UIBarButtonItem *linkButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickReturnButton:)];
    
    
    navigationItem.leftBarButtonItem = linkButton;
    
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

    
    
    [self setupCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =CGRectMake(20,60,self.view.frame.size.width - 40,self.view.frame.size.height - 120);
    [self.view.layer addSublayer:self.preview];
    
    // Start
    [self.session startRunning];
}



#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    
    if(self.delegate){
        NSLog(@"%@",stringValue);

        [self.delegate scanQRcodedidFinish:stringValue];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)clickReturnButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
