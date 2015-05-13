//
//  DataModuleDelegate.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DataModuleControl.h"
#import "AppDelegate.h"

#define DEFAULT_PORT 8001

@implementation DataModuleControl
@synthesize config = _config;
//@synthesize socket = _socket;

-(id) init {
    self = [super init];
    
    _config = [[DeviceProperty alloc] initWithConfig:@"DeviceProperty"];
    [self loadConfig];
    
    
    return self;
}
//创建了一个新的自定义模式
-(void) createCustomMode:(CustomMode *)mode
{
    [_config.mode_list addObject:mode];
    [self saveConfig];
    
}

//删除了一个自定义模式
-(void) dropCustomMode:(CustomMode *)mode
{
    NSUInteger index = (NSUInteger)mode.mid;
    [_config.mode_list removeObjectAtIndex:index];
    [self saveConfig];
    
}

//更新了一个自定义模式
-(void) updateCustomMode:(CustomMode *)mode
{
    NSUInteger index = (NSUInteger)mode.mid;
    [_config.mode_list replaceObjectAtIndex:index withObject:mode];
    [self saveConfig];
    
}

//创建一个新的设备
-(void) createNewDevice:(Device *) _device
{
    //[_config.device_list addObject:_device];
    [self saveConfig];
    
}
//删除一个设备
-(void) dropDevice:(Device *) _device
{
    //[_config.device_list  removeObjectAtIndex:_device.mid];
    [self saveConfig];
}
//更新修改了一个设备
-(void) updateDevice:(Device *) _device
{
    //[_config.device_list replaceObjectAtIndex:_device.mid withObject:_device];
    [self saveConfig];
    
}

//打开关闭设备
-(void) changeDeviceOpenClose : (NSString *)mac option : (int) open
{
    [self saveConfig];
}

//设备改名
-(void) changeDeviceName : (NSString *)mac devname : (NSString *)name
{
    [self saveConfig];
}
//更改亮度
-(void) changeLightValue : (float) value
{
    [self saveConfig];
    
}

//更改闪动频率
-(void) changeStrobeValue : (float) value
{
    [self saveConfig];
    
}

//开关设备
-(void) changeSwitchValue : (BOOL) open
{
    if (open) {
        NSLog(@"Device is opned.");
    }else {
        NSLog(@"Device is closed.");
    }
    
}

-(void) changeTimeValue : (int64_t) open
{
    
}

//变幻当前颜色
-(void) changeColor : (UIColor*) color
{
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    [self saveConfig];
}

//变幻当前模式
-(void) changeMode : (int) index{
#ifdef _DEBUF_LOG
    NSLog(@"Select mode index %d",index);
#endif
}

//修改主路由设置
-(void) changeRoute:(Route *) _route
{
    [self saveConfig];
}


-(void)loadConfig
{
    if(_config)
        [_config loadConfig];
}

-(void)saveConfig
{
    if(_config)
        [_config saveConfig];
    
}

@end
