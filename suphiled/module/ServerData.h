//
//  ServerData.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-9.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>

//客户端注册信息
@interface MobileUser : NSObject
{
    NSString*  _mid;
    NSString*  _uuid;
    NSString*  _os;
    NSString*  _mobile;
    int  _type;
    int  _first;
}

@property (retain,nonatomic) NSString* mid;
@property (retain,nonatomic) NSString* uuid;
@property (retain,nonatomic) NSString* os;
@property (retain,nonatomic) NSString* mobile;
@property int type;
@property int first;

-(id)initWithName:(NSString *)mid uuid:(NSString *)uuid os:(NSString *)os mobile:(NSString *)mobile  type:(int)type first:(int)first;

//-(id)initWithName:(NSString *)mid uuid:(NSString *)uuid type:(int)type first:(int)first  serial:(NSString *) serial;

@end

//设备注册信息
@interface DeviceInfo : NSObject
{
    int  _mid;
    NSString*  _uuid;
    int  _type;
    NSString *_serial;
}

@property int mid;
@property (retain,nonatomic) NSString* uuid;
@property int type;
@property (retain,nonatomic) NSString *serial;


-(id)initWithName:(int)mid uuid:(NSString *)uuid type:(int)type serial:(NSString *) serial;

@end


