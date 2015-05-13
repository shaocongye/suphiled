//
//  Advertisement.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-23.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "Advertisement.h"

@implementation Advertisement


-(id)initWithName:(int)ver
{
    self = [super init];
    if(self)
    {
        _version = 0;
        _file1 = nil;
        _file2 = nil;
        _file3 = nil;
        _file4 = nil;
        _file5 = nil;
    }

    return self;
}


@end
