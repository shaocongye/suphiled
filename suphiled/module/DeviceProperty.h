//
//  ConfigDelegate.h
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomMode.h"

@interface DeviceProperty : NSObject
{
    NSMutableArray *_device_list;
    NSMutableArray *_mode_list;
    Route   *_route;
    //    NSString *_configPath;
    NSString *_name;
    NSMutableDictionary *_config;
}

@property (nonatomic, retain) Route *route;
//@property (nonatomic, retain) NSMutableArray *device_list;
@property (nonatomic, retain) NSMutableArray *mode_list;

-(id) initWithConfig : (NSString *)name;
-(void)initConfig;
-(void)loadConfig;
-(void)saveConfig;
-(Device *)getDeviceFromUUID:(NSString *)uuid;


-(NSMutableArray*)getDeviceList;
-(BOOL)FileisExist:(NSString *)fileName;

-(void) addDevice:(Device*)dev;
-(id) checkScantime;
-(void) zeroScantime;
@end
