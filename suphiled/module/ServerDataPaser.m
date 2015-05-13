//
//  ServerDataPaser.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-9.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "ServerDataPaser.h"

@implementation ServerDataPaser


-(MobileUser *)loadMobileUserRegister:(NSMutableDictionary*) dic
{
    MobileUser *user = [[MobileUser alloc]init];
    NSMutableDictionary *userArray = [dic objectForKey:@"MobileUser"];
    if(userArray != nil)
    {
        user.mid = [userArray objectForKey:@"mid"];
        user.uuid = [userArray objectForKey:@"uuid"];
        user.os = [userArray objectForKey:@"os"];
        user.mobile = [userArray objectForKey:@"mobile"];
        
        NSNumber *type = [userArray objectForKey:@"type"];
        user.type = [type intValue];
        NSNumber *first = [userArray objectForKey:@"first"];
        user.first = [first intValue];
        
        //user.serial = [userArray objectForKey:@"serial"];
    }
    
    return user;
}

-(Advertisement *)loadAdvertisementVersion:(NSMutableDictionary*) dic
{
  
    Advertisement *advert = [[Advertisement alloc] initWithName:0];
    
    
    return advert;
}


@end
