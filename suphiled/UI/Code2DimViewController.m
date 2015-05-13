//
//  Code2DimViewController.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-16.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "Code2DimViewController.h"
//#import "ZBarSDK.h"

@interface Code2DimViewController ()

@end

@implementation Code2DimViewController
//@synthesize scanButton = _scanButton;
@synthesize readerView = _readerView;
@synthesize readerText = _readerText;
@synthesize code2DimDelegate;
//@synthesize ssidstr = _ssidstr;
//@synthesize passwordstr = _passwordstr;
//@synthesize urlstr = _urlstr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect screen = [ UIScreen mainScreen ].bounds;
        
        _ssidstr = nil;
        _passwordstr = nil;
        _urlstr = nil;
        
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 40)];
        
        //创建一个导航栏集合 
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"搜寻设备"];   
        
        //创建一个左边按钮 
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"    
                                                                       style:UIBarButtonItemStyleBordered    
                                                                      target:self    
                                                                      action:@selector(clickReturnButton:)];   
        
        
        navigationItem.leftBarButtonItem = leftButton;
        
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];  
        [self.view addSubview:navigationBar];
        
        
         _readerView = [ZBarReaderView new];
        ZBarImageScanner * scanner = [ZBarImageScanner new];
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [_readerView initWithImageScanner:scanner];
        _readerView.readerDelegate = self;
        //是否显示绿色的追踪框，注意，即当选择yes的时候，这个框仅仅当扫瞄EAN和I2/5的时候才可见。
        _readerView.tracksSymbols = YES;

        _readerView.frame = CGRectMake(20,45,screen.size.width - 40,280);
        
        _readerView.torchMode = 0;

        //_readerView.device = [self frontFacingCameraIfAvailable];
        //开始扫描，一起动就开始扫描
        [_readerView start];
        
        [self.view addSubview: _readerView];
        
        _readerText = [[UILabel alloc]initWithFrame:CGRectMake(screen.size.width/2-25, 335, screen.size.width - 50, 50)];
        [_readerText setText:@""];
        [self.view addSubview:_readerText];
    }
    return self;
}


- (void)clickReturnButton:(id)sender
{
    [_readerView stop];
    
    //调用处理函数
    if(_macstr != nil)
        [self.code2DimDelegate createNewDevice:_macstr ssid:_ssidstr pasword:_passwordstr url:_urlstr];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
        
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.readerView stop];
}

//扫描得到数据的时候进行判断
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image 
{ 
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet); 
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)]; 
    
    //判断是否包含 头'ssid:' 
    NSString *ssid = @"ssid+:[^\\s]*";; 
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid]; 
        
    if([ssidPre evaluateWithObject:symbolStr]){ 
        
        NSArray *arr = [symbolStr componentsSeparatedByString:@";"]; 
        
        
        _macstr = [arr objectAtIndex:0];
        _ssidstr = [arr objectAtIndex:1];
        _passwordstr = [arr objectAtIndex:2];
        _urlstr = [arr objectAtIndex:3];
        
        symbolStr = [NSString stringWithFormat:@"ID: %@ \n 密码:%@ 访问主页:%@", 
                     _ssidstr,
                     _passwordstr,
                     _urlstr]; 
        
        _readerText.text = symbolStr;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
