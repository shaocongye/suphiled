//
//  UIDevice+Resolutions.m
//  Test_common
//
//  Created by wangzhipeng on 13-1-30.
//  Copyright (c) 2013年 com.comsoft. All rights reserved.
//

#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            
            //首先获取像素点，再根据缩放来确定像素大小
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            
            if(result.height <= 960.0f)
                return UIDevice_iPhoneHiRes;
            
            if(result.height <= 1136.0f)
                return UIDevice_iPhoneTallerHiRes;
            
            return
                (result.height > 1334 ? UIDevice_iPhonePlus : UIDevice_iPhone6_Res);
            
            
        } else
            return UIDevice_iPhoneStandardRes;
    } else{
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
        
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            
            if(result.height <= 1024)
                return UIDevice_iPadStandardRes;
            else
                return UIDevice_iPadHiRes;

                
       } else
           return UIDevice_iPadStandardRes;
 
    
//        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
    }
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5{
    if ([self currentResolution] == UIDevice_iPhoneTallerHiRes) {
        return YES;
    }
    return NO;
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone6
 函数描述 : 当前是否运行在iPhone6端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
//+ (BOOL)isRunningOniPhone6{
//    return (UI_USER_INTERFACE_IDIOM() == UIDevice_iPhone6_Res);
//}

@end