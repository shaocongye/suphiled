//
//  FlashPanel.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "FlashPanel.h"

@implementation FlashPanel

- (instancetype)initWithDict:(NSDictionary *)dict idx:(NSInteger) index{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.descript = dict[@"descript"];
        self.ntype = dict[@"ntype"];
        self.index = index;
    }
    return self;
}

+ (instancetype)panelWithDict:(NSDictionary *)dict idx:(NSInteger) index{
    
    return [[self alloc] initWithDict:dict idx:index];
}


@end
