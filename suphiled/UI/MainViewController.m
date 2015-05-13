//
//  MainViewController.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-3.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "MainViewController.h"

#import "QRcodeViewController.h"
//#import "Code2DimViewController.h"
#import "AppDelegate.h"
#import "XYAlertViewHeader.h"
//#import "EditAlertPrompt.h"
#import "UIDevice+Resolutions.h"
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <Reachability.h>
#import "MainWindowNavbar.h"
//#define _DEBUGLAMB 1

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        _sceneView = [[SceneControlView alloc] init];
        _sceneView.delegate = self;
        
        int currentResolution = (int)[UIDevice currentResolution];
        
        _GetModeulInfoQuenue = [[NSOperationQueue alloc] init];
        // Custom initialization
        CGRect screen = [ UIScreen mainScreen ].bounds;
        
        int topLine = 0,advertHeight = 200;
        
        //广告导航，广告列表
        switch (currentResolution) {
                // iPhone 1,3,3GS 标准分辨率(320x480px)
            case UIDevice_iPhoneStandardRes:
                break;
                // iPhone 4,4S 高清分辨率(640x960px)
            case UIDevice_iPhoneHiRes:
                break;
                // iPhone 5 高清分辨率(640x1136px)
            case UIDevice_iPhoneTallerHiRes:
                break;
                //iPhone6
            case UIDevice_iPhone6_Res:
                break;
            case UIDevice_iPhonePlus:
                break;
                
                // iPad 1,2 标准分辨率(1024x768px)
            case UIDevice_iPadStandardRes:
                // iPad 3 High Resolution(2048x1536px)
            case UIDevice_iPadHiRes:
                advertHeight = 430;
                break;
                
            default:
                break;
        }
        
        CGRect rect = CGRectMake(0, topLine, screen.size.width, advertHeight);
        _flashs = [[FlashViewController alloc] initWithPlistName:@"FlashPanel" frame:rect];
        [self.view addSubview:_flashs];
        
        //九宫格，设备按钮列表
        topLine += advertHeight;
        int sudokuHeight = screen.size.height - advertHeight - 63;
        CGRect r1 = CGRectMake(0, topLine, screen.size.width, sudokuHeight);
        _lamps = [[LampListView alloc] initWithFrame:r1];
        _lamps.delegate = self;
        
        [self.view addSubview:_lamps];

#ifdef _DEBUGLAMB
        for(int i = 0; i < 20; i++)
        {
            Device *dev = [[Device alloc] initWithName:1 name:NSLocalizedString(@"lampName", nil) it:0 type:2  seg:5 uuid:@"12333" sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:1 tc:1];
            [_lamps addDevice:dev];
        }
#endif
        
        
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [self scanModuleInfoAction:@"scan Operation"];
        }];
        
        [_GetModeulInfoQuenue addOperation:op];

        

    }
    return self;
}


//只有一个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


//加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setNewTitle:@"SuphiLED"];
    [self.navigationItem setRightItemWithTarget:self action:@selector(refresh) title:NSLocalizedString(@"refreshButton", nil)];
}

//设置config，更新数据
-(void) setConfig:(DeviceProperty*) cfg
{
    _config = cfg;
    
}

//打开对话框
-(void) dismissAlertShowMessage:(NSString*)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:text delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil)  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
    
    [alert show];
}


//打开控制窗口
-(void)dismissAlertShowSceneControl:(Device*)dev
{

    
    
//    
//    SceneControlView *sceneView = [[SceneControlView alloc] init];
//    sceneView.delegate = self;
//    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//#ifndef _DEBUGLAMB
//    if( apd && apd.BLENetworkControl.cbConnected)
//    {
//#endif
//        ///有错误
//        if(dev){
//            @try{
//                [sceneView setDevice:dev];
//                [self presentViewController:sceneView animated:FALSE completion:nil];
//            }@catch (NSException * e) {
//                
//                NSLog(@"Exception: %@", e);
//                
//            }
//        }
//    
//#ifndef _DEBUGLAMB
//    } else {
//        NSLog(@"apd.BLENetworkControl.cbConnected FALSE %@",apd.BLENetworkControl);
//
//    }
//#endif



    if(!_sceneView)
    {
        _sceneView = [[SceneControlView alloc] init];
        _sceneView.delegate = self;
    }
    
    
    if(_sceneView){
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
#ifndef _DEBUGLAMB
        if( apd && apd.BLENetworkControl.cbConnected)
        {
#endif
            if(_sceneView == nil)
            {
                NSLog(@"_sceneView 被异常析构了");
                _sceneView = [[SceneControlView alloc] init];
                _sceneView.delegate = self;
            }
            
            if(_sceneView != nil || _sceneView != NULL)
            {
                [_sceneView setBLENetwork:apd.BLENetworkControl];

                ///有错误
                if(dev){
                    @try{
                        [_sceneView setDevice:dev];
                        
                        
                        UINavigationController *theNavController= [apd getCurNavController];
                        
                        
                        [theNavController presentViewController:_sceneView
                                                       animated:NO
                                                     completion:^(void){
                                                         // Code
                                                         
                                                     }];

//                        [self presentViewController:_sceneView animated:FALSE completion:nil];
                    }@catch (NSException * e) {

                        NSLog(@"Exception: %@", e);

                    }
                }
            }
#ifndef _DEBUGLAMB
        } else {
            NSLog(@"apd.BLENetworkControl.cbConnected FALSE %@",apd.BLENetworkControl);
            
        }
#endif
    }
}
-(void) didSelectPanel:(int) index
{
    
}

- (void) didEditPanel:(int) index
{
    
}

-(void) didEditLamp:(int)index
{
    Device *dev = [_lamps getDeviceByIndex:index];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setupDeviceName", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil) otherButtonTitles:NSLocalizedString(@"ModifyButton", nil) ,nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    _nameedit = [alert textFieldAtIndex:0];
    
    if(dev)
    {
        _nameedit.text = dev.name;
    } else
        _nameedit.text = @"";
    
    alert.tag = 88 + index;
    [alert show];
}


-(void) didSelectLamp:(int) index
{
    NSLog(@"panel %d is selected.",index);
    
    if(index == 99)
    {
        //二维码扫描
        QRcodeViewController *qrcode = [[QRcodeViewController alloc] init];
        qrcode.delegate = self;
        [self presentViewController:qrcode animated:FALSE completion:nil];
    } else {
        //判断当前链接是否本设备的链接,是的话进入，不是的话就提示
        
        
        //Device *dev = [_config.getDeviceList objectAtIndex:index];
        Device *dev = [_lamps getDeviceByIndex:index];
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
#ifdef _DEBUGLAMB
        [self dismissAlertShowSceneControl:dev];
        return;
#endif
        
//根据index 获取相应的设备的uuid，根据uuid来判断是否当前设备
//        NSLog(@"device :%d",[apd.BLENetworkControl.nDevices count]);
//        NSLog(@"peripheral :%@",[apd.BLENetworkControl.cbPeripheral.identifier UUIDString]);

        if(dev && apd)
        {
            NSString *uuid = [apd.BLENetworkControl.cbPeripheral.identifier UUIDString];
            
            if([uuid isEqualToString:dev.uuid])
            {//当前链接就是指定链接
                
                if(apd.BLENetworkControl.cbConnected)
                {  //当前链接已经打开了，直接进入控制
                    [apd.BLENetworkControl ReadDataFromPrepharal];
                    
                    [self performSelector:@selector(dismissAlertShowSceneControl:) withObject:dev afterDelay:1];
                } else {
                    //当前链接没有打开，需要先打开链接再等待进入控制
                    [apd.BLENetworkControl ConnectedBLEPrepharal:true];
                    
                    XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait1minuslinkMessage", nil));
                    [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                    
                    //等待1秒时间打开控制界面
                    [self performSelector:@selector(dismissAlertShowSceneControl:) withObject:dev afterDelay:1];
                }
            } else {
                //当前链接不是指定链接,先关闭，然后再打开
                [apd.BLENetworkControl ConnectedBLEPrepharal:false];
                
                //这里需要等待1秒  ...
                [NSThread sleepForTimeInterval:1.0];
                
                if([apd.BLENetworkControl.nDevices count] > 0)
                {
                    
                    BOOL isInDevice = false;
                    for(CBPeripheral *peripheral in apd.BLENetworkControl.nDevices )
                    {
                        if([[peripheral.identifier UUIDString] isEqualToString:dev.uuid])
                        {
                            NSLog(@"link  peripheral %@",dev.uuid);
                            isInDevice = true;
                            //这里是需要链接设备,而不是指定设备已经链接
                            apd.BLENetworkControl.cbPeripheral = peripheral;
                            [apd.BLENetworkControl ConnectedBLEPrepharal:true];
                        
                            XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait1minuslinkMessage", nil) );

                            
                            [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:1];
                            
                            //等待1秒时间打开控制界面
                            [self performSelector:@selector(dismissAlertShowSceneControl:) withObject:dev afterDelay:1];

                        }
                    }
                    
                    if(!isInDevice)
                    {
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil) message:NSLocalizedString(@"freshMessage", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil) otherButtonTitles:NSLocalizedString(@"OKButton", nil), nil];
                        
                        [alert show];
                        
                        [_lamps removeButtonByIndex:index];
                    }
                    
                } else {
                    //弹出提示框，告知周围没有可链接设备，检查设备是否开启或在附近
                    XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait5minuslinkMessage", nil));
                    [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:5];

                    [self performSelector:@selector(dismissAlertShowMessage:) withObject:NSLocalizedString(@"NodeviceMessage", nil) afterDelay:5];
                    
                    
                    
                    [_lamps removeButtonByIndex:index];
                }
            }
        }
        else {
            if(apd)
            {
                [apd.BLENetworkControl ScanBLEPrepharal ];
                [apd.BLENetworkControl ConnectedBLEPrepharal:true];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil) message:NSLocalizedString(@"wait10minusMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil) otherButtonTitles:NSLocalizedString(@"OKButton", nil), nil];
            
    
            [alert show];
            
        }
    }
}

//修改名称以后保存到配置文件中
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag > 87)
    {
        if(buttonIndex > 0)
        {
            Device * dev = [_lamps getDeviceByIndex:(int)alertView.tag - 88];
            
            if(dev){
                dev.name = _nameedit.text;
                
                [_lamps setDeviceByIndex:dev index:(int)alertView.tag - 88];
                [_config addDevice:dev];
                [_config saveConfig];
            }
        }
    }
}

//获取当前设备状态
-(void) readStatus
{
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self queryModuleInfoAction:@"query Block Operation"];
    }];
    
    [_GetModeulInfoQuenue addOperation:op];
    
    
//    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(apd)
//    {
//        [apd.BLENetworkControl ReadDataFromPrepharal];
//    }
}

-(void) changeSwitch:(BOOL) _switch
//- (void)changeSwitch:(int)_switch index : (int) tag
{
//    NSLog(@"改变开关 %d",_switch);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        command->version = 1;
        
        if(!_switch)
            command->command = (char)APP_COMMAND_SWITCH_ON;
        else
            command->command = (char)APP_COMMAND_SWITCH_OFF;
        
        [apd.BLENetworkControl SendDataToPrepharal:(unsigned char *)data];
    }
}

- (void)changeName:(NSString *)_name index :(int) tag
{
//    NSLog(@"改变名称 %@,%d",_name,tag);
}

-(void) changeColor:(float)_value
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        float v = _value * 255 / 100;
        memset(command, (unsigned char)(int)v, sizeof(_Comm));

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_COLOR;
        
//        NSLog(@"改变颜色 %f   %2x",_value,command->red);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

- (void)changeLight:(float)_light
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        
        if(_light == 2.0)
        {//小夜灯模式
            memset(command, (unsigned char)(int)2, sizeof(_Comm));
        } else {
            memset(command, (unsigned char)(int)(_light * 255), sizeof(_Comm));
        }

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_LIGHT;

//        NSLog(@"改变亮度 %f   %2x",_light,command->red);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

- (void)changeMode:(int)mode
{
//    NSLog(@"改变模式 %d",mode);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        memset(command, (unsigned char)mode, sizeof(_Comm));

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_LIGHTCHANGE;
        
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }

}

-(void) changeDelay:(int) delay{
    NSLog(@"设置延时 %d",delay);
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        memset(command, (unsigned char)delay, sizeof(_Comm));
        
        command->version = 1;
        command->command = (char)APP_COMMAND_SET_DELAY_ON;
                
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

/**
 //        Light    亮度  0-255
 //        One     开为1，关为0
 //        Two     开为1，关为0
 //        Three    开为1，关为0
 //        Four     开为1，关为0
 //        FIve     开为1，关为0
 **/
-(void) changeSegment:(int) light oneseg :(int) one twoseg :(int) two threeseh :(int) three fourseg :(int) four fiveseg :(int) five
{
    //    NSLog(@"设置分段开关 %d",delay);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;

        command->version = 0;
        command->command = (char)APP_COMMAND_SET_MUTISEG;
        command->value1 = (unsigned char)light; //        Light    亮度  0-255
        command->value2 = (unsigned char)one; //        One     开为1，关为0
        command->value3 = (unsigned char)two;  //        Two     开为1，关为0
        command->value4 = (unsigned char)three;//        Three    开为1，关为0
        command->value5 = (unsigned char)four; //        Four     开为1，关为0
        command->value6 = (unsigned char)five; //        FIve     开为1，关为0
        
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

/**
 //     type        灯泡、吸顶灯、天花灯 （0,1，2）
 //     亮度         0-255
 //     颜色          0-255
 //     多路选择       0000 0000  （只在天花灯使用）使用低4位表示，如第一路，第三路开为（0000 0101 = 5）
 **/
-(void) saveSetting:(int) type light:(int)light color:(int)color segment:(int) seg
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
    
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
    
    
        command->version = 1;
        command->command = (char)APP_COMMAND_SAVE;
        command->value1 = (unsigned char)type;      //  类型   灯泡、吸顶灯、天花灯 （1,2，3）
        command->value2 = (unsigned char)light;     //	亮度         0-255
        command->value3 = (unsigned char)color;     //	颜色          0-255
        command->value4 = (unsigned char)seg;       //  多路选择       0000 0000  （只在天花灯使用）使用低4位表示，如第一路，第三路开为（0000 0101 = 5）

        NSLog(@"APP_COMMAND_SAVE 1 %d %d %d %d %d", APP_COMMAND_SAVE,type,light,color,seg);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
    
}


//返回模块查询的数据
-(void) ReturnPeriopheralData:(unsigned char*)data slen:(int) len
{
    //以后会很多这种数据
    
    NSLog(@"ReturnPeriopheralData  %d %d %d %d %d %d %d ",data[0],data[1],data[2],data[3],data[4],data[5],data[6]);
    
    
    switch (*(data+1)) {
        case RESULT_TYPE_SAVE: //保存指令返回标志
        {
            [_sceneView saveOK];
            //显示保存好了
        }
            break;
        case RESULT_TYPE_STATUS: //查询状态返回指令
        {
            PResultData result = (PResultData)data;
            
            //将数据传递给控制界面
            [_sceneView setStatus:result];
        }
            
            
            break;
        default:
            break;
    }
    
}




-(void)queryModuleInfoAction:(id)obj
{
    NSLog(@"执行查询%@----obj : %@ ",[NSThread currentThread], obj);
    
//    延迟2秒
    [NSThread sleepForTimeInterval:1.0f];
    

    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ReadDataFromPrepharal ];
    }
    NSLog(@"执行查询结束");

};

-(void)scanModuleInfoAction:(id)obj
{

#ifdef _DEBUG_LOG
    NSLog(@"%@----obj : %@ ",[NSThread currentThread], obj);
#endif
    
    
    //    延迟2秒
    [NSThread sleepForTimeInterval:2.0f];
//    先将计数器清零
    [_config zeroScantime];
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ScanBLEPrepharal ];
    }
    
    //马上就添加扫描程序到队列，等待时间到了就执行
//    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [self freshModuleInfoAction:@"fresh Operation"];
//    }];
//    
//    [_GetModeulInfoQuenue addOperation:op];
    
}

-(void)freshModuleInfoAction:(id)obj
{
    //    延迟30秒
    NSLog(@"执行刷新30秒");
    [NSThread sleepForTimeInterval:30.0f];
    
//    [_lamps clearDevice];
//    Device *dev = [_config checkScantime];
//    if(dev != nil)
//    {
//        //[_lamps removeLamp:[[NSUUID alloc] initWithUUIDString:dev.uuid] ];
//        [_lamps removeDevice:dev.uuid];
//    }
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ScanBLEPrepharal ];
    }

    if([_sceneView isCurrentViewControllerVisible])
    {
        
    } else {
        
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [self freshModuleInfoAction:@"fresh Operation"];
        }];
        
        if(_GetModeulInfoQuenue != nil)
        {
            [_GetModeulInfoQuenue addOperation:op];
        }
    }


    NSLog(@"执行刷新10秒结束");

}

-(void) ConnectedBLEDevice:(NSUUID*) uuid
{
//    连接设备
    NSLog(@"连接设备 uuid： %@",uuid);
    [_lamps Changeonline:YES uuid:uuid];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self queryModuleInfoAction:@"Block Operation"];
    }];
    
    [_GetModeulInfoQuenue addOperation:op];
    
}

 //设备断开链接
-(void) DisconnectedBLEDevice:(NSUUID*) uuid
{
 
//#ifdef _DEBUG_LOG
    NSLog(@"断开设备 uuid:  %@",uuid);
//#endif
    
    //删除对象
//    [_lamps removeLamp:uuid];
    
    [_lamps Changeonline:NO uuid:uuid];
    
    //通知断线了
    if([_sceneView isCurrentViewControllerVisible] )
        [_sceneView disconnectBLE:uuid ];
    
//    [_buttons Changeonline:NO uuid:uuid];
}

//发现设备
-(void) DiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{
    Device *dev = [_config getDeviceFromUUID:[peripheral.identifier UUIDString]];
    
    NSString *title = (NSString*)[advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if(title == nil)
        return;
    
    NSString *name2 = @"ShowLightLED";
    NSRange range2 = [title rangeOfString:name2];
    
    int typeint = 0;
    int segint = 0;
    if(range2.location != NSNotFound)
    {
        NSString *typestr = [title substringFromIndex:(range2.location + range2.length)];
        
        if(typestr != nil)
            typeint = [typestr intValue];
        else
            typeint = 0;
        
        const char *char_title = [title cStringUsingEncoding:NSASCIIStringEncoding];
        
        char segchar = *(char_title+2);
        
        if(segchar == 'o')
        {
            segint = 0;
        } else {
            segint = (int) segchar;
            
            
//            目前到5，以后增加再调整
            if(segint > 5 && segint < 8)
                return;
            
                //segint = 2;
        }
    }
    
    
    NSLog(@"device type : %d,  seg : %d",typeint,segint);
    
    if(dev == nil)
    {
        //添加设备到配置文件中，下次使用
        
        
        dev = [[Device alloc] initWithName:1 name:NSLocalizedString(@"lampName", nil) it:0 type:typeint seg:segint uuid:[peripheral.identifier UUIDString] sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:1 tc:1];
        
        dev.scantime = 1;
        
        [_config addDevice:dev];
        [_config saveConfig];
    
        //新发现的设备，需要刷新界面
        [_lamps addDevice:dev];
    }
    else {
        dev.type = typeint;
        dev.segment = segint;
        
        dev.scantime = 1;
        
        [_config addDevice:dev];
        [_config saveConfig];
//        数据已有了，不要刷新了
        [_lamps addDevice:dev];
    }
}


-(void)disconnectModuleInfoAction:(id)obj
{
    
#ifdef _DEBUG_LOG
    NSLog(@"%@----obj : %@ ",[NSThread currentThread], obj);
#endif
    
    
    //    延迟2秒
//    [NSThread sleepForTimeInterval:2.0f];
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ConnectedBLEPrepharal:FALSE];
    }

}
-(void) retuenMainView
{
//    NSLog(@"关闭控制界面");
    //返回主界面之前先发出一个并发操作，高速设备，我要断开连接
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self disconnectModuleInfoAction:@"disconnect Operation"];
    }];
    
    [_GetModeulInfoQuenue addOperation:op];
}


//二维码扫描结果
-(void)scanQRcodedidFinish:(NSString*)url
{
    NSLog(@"scanQRcodedidFinish : %@",url);
    
    //判断是否正确的二维码，是正确的二维码，就截取设备信息，根据设备信息，判断是否新设备，如果是已有的设备信息，就不做添加，如果是新设备就添加到设备列表，保存到配置文件中，并刷新主界面，令蓝牙链接线程，动态搜索设备
    
    if(url)
    {
        NSArray *suburl = [url componentsSeparatedByString:@":"];
        
        if([suburl count] == 4  && [[suburl objectAtIndex:0] isEqualToString:@"GoldenLightApp"])
        {
        
            NSString *sname = [suburl objectAtIndex:1];
            NSString *suuid = [suburl objectAtIndex:2];
            NSString *stype = [suburl objectAtIndex:3];
            int itype = [stype intValue];
            
            Device *newDev = [[Device alloc] initWithName:0 name:sname it:0 type:itype seg:0 uuid:suuid sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:0 tc:0];
            
            [_config addDevice:newDev];
            [_config saveConfig];
            
            //重新刷新界面
        }
    }
}

//刷新设备信息
//-(void)scanLinkButton:(UIBarButtonItem *)sender
- (void)refresh
{
    
    
    NSLog(@"scanLinkButtonscanLinkButtonscanLinkButtonscanLinkButton");
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ScanBLEPrepharal];
        XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait5minusMessage", nil));
        
        
        
        [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:5];
        
        [_lamps clearDevice];
    }
}


- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}


- (void) leftButtonClick
{
    NSLog(@"- (void) leftButtonClick;- (void) leftButtonClick;- (void) leftButtonClick;- (void) leftButtonClick;");
}

- (void) rightButtonClick
{
    
}

- (void) editTitle:(NSString *)title
{
    
}


@end
