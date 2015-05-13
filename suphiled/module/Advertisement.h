//
//  Advertisement.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-23.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject
{
    int  _version;
    NSString *_file1;
    NSString *_file2;
    NSString *_file3;
    NSString *_file4;
    NSString *_file5;
}

@property int version;
@property (retain,nonatomic) NSString* file1;
@property (retain,nonatomic) NSString* file2;
@property (retain,nonatomic) NSString* file3;
@property (retain,nonatomic) NSString* file4;


-(id)initWithName:(int)ver;
@end
