//
//  ServerDataPaser.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-9.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerData.h"
#import "Advertisement.h"

//网络服务器数据解析器
@interface ServerDataPaser : NSObject
{
   
    
}



-(MobileUser *)loadMobileUserRegister:(NSMutableDictionary*) dic;

-(Advertisement *)loadAdvertisementVersion:(NSMutableDictionary*) dic;




@end
