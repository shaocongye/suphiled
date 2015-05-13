//
//  ServerData.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-9.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "ServerData.h"

@implementation MobileUser
@synthesize mid = _mid;
@synthesize uuid = _uuid;
@synthesize os = _os;
@synthesize mobile = _mobile;
@synthesize type = _type;
@synthesize first = _first;
//@synthesize serial = _serial;


-(id)initWithName:(NSString *)m uuid:(NSString *)u os:(NSString *)o mobile:(NSString *)b  type:(int)t first:(int)f
{
    self = [super init];
    if(self)
    {
        _mid = m;
        _os = o;
        _mobile = b;
        
        _type = t;
        _first = f;
        
        _uuid = u;
        //_serial = s;
    }
    
    return self;
}

@end
