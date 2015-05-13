//
//  UIDevice.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-11-8.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



//屏幕，根据像素  分辨率不同
enum {
    
    // iPhone 1,3,3GS 标准像素(320x480px) @1x  分辨率 320x480px
    UIDevice_iPhoneStandardRes      = 1,
    
    // iPhone 4,4S 高清像素(320x480px)  @2x 分辨率 640x960px
    UIDevice_iPhoneHiRes            = 2,
    
    // iPhone 5,5S 高清像素(320x568px)   @2x 分辨率 640x1136px
    UIDevice_iPhoneTallerHiRes      = 3,
    
    //iPhone 6 高清像素(375x667px)  @2x 分辨率 750x1334px。
    UIDevice_iPhone6_Res            = 4,
    
    //iPhone 6 Plus 高清像素(424x736px)  @3x  分辨率 1242x2208px。
    UIDevice_iPhonePlus             = 5,
    
    // iPad 1,2   标准像素(768*1024px)  @1x  分辨率 320x480px。
    UIDevice_iPadStandardRes        = 6,
    
    // iPad 3  Retina  高清像素(768x1024px)  (@2x 分辨率 1536*2048。
    UIDevice_iPadHiRes              = 7
    
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions){
    
}


/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution;

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5;

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone;


//+ (BOOL)isRunningOniPhone6;

@end
