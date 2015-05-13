//
//  DataModuleDelegate.h
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceProperty.h"
#import "CustomMode.h"
//#import "RouterViewController.h"
//#import "DeviceViewController.h"
//#import "SceneViewController.h"
//#import "ModeViewController.h"
//#import "CommandSendReciver.h"

@interface DataModuleControl : NSObject
{
    DeviceProperty *_config;
//    CommandSendReciver *_socket;
}

@property (strong,nonatomic) DeviceProperty *config;
//@property (strong,nonatomic) CommandSendReciver *socket;

-(id) init;

//模式处理
-(void) createCustomMode:(CustomMode *)_mode;
-(void) dropCustomMode:(CustomMode *)_mode;
-(void) updateCustomMode:(CustomMode *)_mode;

//设备处理接口
-(void) createNewDevice:(Device *) _device;
-(void) dropDevice:(Device *) _device;
-(void) updateDevice:(Device *) _device;

-(void) changeDeviceOpenClose : (NSString *)mac option : (int) open;
-(void) changeDeviceName : (NSString *)mac devname : (NSString *)name;

//场景控制
-(void) changeLightValue : (float) value;
-(void) changeStrobeValue : (float) value;
-(void) changeSwitchValue : (BOOL) open;
-(void) changeTimeValue : (int64_t) open;
-(void) changeColor : (UIColor*) color;
-(void) changeMode : (int) index;


//主路由器接口
-(void) changeRoute:(Route *) _route;

//数据处理接口
-(void)loadConfig;

-(void)saveConfig;

@end
