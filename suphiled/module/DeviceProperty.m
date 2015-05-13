//
//  ConfigDelegate.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DeviceProperty.h"

@implementation DeviceProperty
@synthesize route = _route;
//@synthesize device_list = _device_list;
@synthesize mode_list = _mode_list;

-(id) initWithConfig : (NSString *)name{
    self = [super init];
    if(self)
    {
        
        _device_list = [[NSMutableArray alloc] initWithCapacity:10];
        _mode_list = [[NSMutableArray alloc ] initWithCapacity:20];
        
        _route = [[Route alloc] initWithName:@"" ipaddr:@"" pwd:@"" macaddr:@""];
        _name = [name copy];
        
        //        name = @"DeviceProperty";
        // Get our document path.

        NSString *configPath = @"DeviceProperty.plist";
        if([self FileisExist:configPath]){
            NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [searchPaths objectAtIndex:0];
            NSString *configPath = [documentPath stringByAppendingPathComponent:@"DeviceProperty.plist"];
            
            _config = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
        }
        else
            _config = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

-(BOOL)FileisExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path  stringByAppendingFormat:@"/%@",fileName ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    
    return result;
}

-(void)loadConfig{
    if (_config) {
        NSMutableArray *roots = [[NSMutableArray alloc] initWithCapacity:100];
        [roots addObjectsFromArray:[_config allKeys]] ;
        
        NSMutableDictionary *route = [_config objectForKey:@"route"];
        [self loadRouteDictionary:route];
        
        
        NSMutableArray *devices = [_config objectForKey:@"devicelist"];
        [self loadDeviceList:devices];
        
        NSMutableArray *modes = [_config objectForKey:@"modelist"];
        [self loadModeList:modes];
    }
    
}

//第一次构建配置文件
-(void)initConfig{
    //初始化设备
    NSMutableArray *devicelist = [[NSMutableArray alloc]init];
    
    Device *device0 = [[Device alloc] initWithName:0 name:@"房间1" it:0 type:1 seg:0 uuid:@"B57B61C8-18F9-C937-C1A9-BB216D15196A" sid:@"22222222" pwd:@"88888888" ipaddr:@"192.168.10.107" maddr:@"3434343434" md:0 st:0 to:23131 tc:3434324324];
    
    NSMutableDictionary *node0 = [self saveDeviceDictionary:device0];
    [devicelist addObject:node0];
    
    Device *device1 = [[Device alloc] initWithName:1 name:@"房间2" it:0 type:1 seg:0 uuid:@"B57B61C8-18F9-C937-C1A9-BB216D15197A" sid:@"1111111111" pwd:@"88888888" ipaddr:@"192.168.10.108" maddr:@"wwwwwwww" md:0 st:0 to:123232121 tc:3432432];
    
    NSMutableDictionary *node1 = [self saveDeviceDictionary:device1];
    [devicelist addObject:node1];
    
    Device *device2 = [[Device alloc] initWithName:2 name:@"房间3" it:0 type:2 seg:0 uuid:@"B57B61C8-18F9-C937-C1A9-BB216D15196B" sid:@"444444444" pwd:@"88888888" ipaddr:@"192.168.10.109" maddr:@"yyyyyyyy" md:0 st:0 to:43423 tc:434346346];
    
    NSMutableDictionary *node2 = [self saveDeviceDictionary:device2];
    [devicelist addObject:node2];
    
    [_config setObject:devicelist forKey:@"devicelist"];
    
    
    NSMutableArray *modelist = [[NSMutableArray alloc]init];
    CustomMode *mode0 = [[CustomMode alloc] initWithName:1 nm:@"白色不变" ty:0 lt:10 sp:10 ct:1];
    
    NSMutableDictionary *nm0 = [self saveModeDictionary:mode0];
    [modelist addObject:nm0];
    
    CustomMode *mode1 = [[CustomMode alloc] initWithName:2 nm:@"红色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm1 = [self saveModeDictionary:mode1];
    [modelist addObject:nm1];
    
    CustomMode *mode2 = [[CustomMode alloc] initWithName:3 nm:@"蓝色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm2 = [self saveModeDictionary:mode2];
    [modelist addObject:nm2];
    
    CustomMode *mode3 = [[CustomMode alloc] initWithName:4 nm:@"绿色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm3 = [self saveModeDictionary:mode3];
    [modelist addObject:nm3];
    
    CustomMode *mode4 = [[CustomMode alloc] initWithName:5 nm:@"黄色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm4 = [self saveModeDictionary:mode4];
    [modelist addObject:nm4];
//    [mode4 release];
    
    CustomMode *mode5 = [[CustomMode alloc] initWithName:6 nm:@"青色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm5 = [self saveModeDictionary:mode5];
    [modelist addObject:nm5];
//    [mode5 release];
    
    CustomMode *mode6 = [[CustomMode alloc] initWithName:7 nm:@"紫色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm6 = [self saveModeDictionary:mode6];
    [modelist addObject:nm6];
//    [mode6 release];
    
    CustomMode *mode7 = [[CustomMode alloc] initWithName:8 nm:@"白色渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm7  = [self saveModeDictionary:mode7];
    [modelist addObject:nm7];
//    [mode7 release];
    
    CustomMode *mode8 = [[CustomMode alloc] initWithName:9 nm:@"红绿渐变" ty:0 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm8  = [self saveModeDictionary:mode8];
    [modelist addObject:nm8];
//    [mode8 release];
    
    CustomMode *mode9 = [[CustomMode alloc] initWithName:10 nm:@"黄昏模式" ty:1 lt:10 sp:10 ct:1];
    
    [mode9 setRGBByID:255 greencolor:242 bluecolor:129 index:0];
    [mode9 setRGBByID:37 greencolor:126 bluecolor:255 index:1];
    [mode9 setRGBByID:255 greencolor:54 bluecolor:40 index:2];
    [mode9 setRGBByID:255 greencolor:6 bluecolor:196 index:3];
    
    NSMutableDictionary *nm9  = [self saveModeDictionary:mode9];
    [modelist addObject:nm9];
//    [mode9 release];
    
    CustomMode *mode10 = [[CustomMode alloc] initWithName:11 nm:@"夜晚模式" ty:1 lt:10 sp:10 ct:1];
    NSMutableDictionary *nm10  = [self saveModeDictionary:mode10];
    [mode10 setRGBByID:255 greencolor: 242 bluecolor: 129 index:0];
    [mode10 setRGBByID:37 greencolor: 126 bluecolor: 255 index:1];
    [mode10 setRGBByID:255 greencolor: 54 bluecolor: 40 index:2];
    [mode10 setRGBByID:255 greencolor: 6 bluecolor: 196 index:3];
    
    [modelist addObject:nm10];
//    [mode10 release];
    
    [_config setObject:modelist forKey:@"modelist"];
    
    
    //定义route
    NSMutableDictionary *route = [[NSMutableDictionary alloc]init];
    [route setObject:@"1111" forKey:@"ssid"];
    [route setObject:@"192.168.1.1" forKey:@"ip"];
    [route setObject:@"88888888" forKey:@"password"];
    [route setObject:@"ddddddddd" forKey:@"mac"];
    [_config setObject:route forKey:@"route"];
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:_name ofType:@"plist"];
    
    [_config writeToFile:configPath atomically:YES];
    //    [configPath release];
}


-(void)loadRouteDictionary:(NSMutableDictionary *)dict
{
    _route.ssid = [dict objectForKey:@"ssid"];
    _route.ip = [dict objectForKey:@"ip"];
    _route.mac = [dict objectForKey:@"mac"];
    _route.password = [dict objectForKey:@"password"];
    
    
    //注册项
    _route.uuid = [dict objectForKey:@"uuid"];
    _route.serial = [dict objectForKey:@"serial"];
    
    
    NSNumber *first = [dict objectForKey:@"first"];
    _route.first = [first intValue];
    
    NSNumber *type = [dict objectForKey:@"type"];
    _route.type = [type intValue];
}

-(void)saveRouteDictionary
{
    NSMutableDictionary *route = [[NSMutableDictionary alloc]init];
    
    if(_route)
    {
        if(_route.ssid)
            [route setObject:_route.ssid forKey:@"ssid"];
        else
            [route setObject:@"" forKey:@"ssid"];
        
        if(_route.ip)
            [route setObject:_route.ip forKey:@"ip"];
        else
            [route setObject:@"" forKey:@"ip"];
        
        if(_route.password)
            [route setObject:_route.password forKey:@"password"];
        else
            [route setObject:@"" forKey:@"password"];
        
        if(_route.mac)
            [route setObject:_route.mac forKey:@"mac"];
        else
            [route setObject:@"" forKey:@"mac"];
        
    }
    
    [_config setObject:route forKey:@"route"];
}



-(void) loadDeviceList:(NSMutableArray *)array{
    for(NSMutableDictionary *dict in array)
    {
        Device *device = [self loadDeviceDictionary:dict];
        
        [_device_list addObject:device];
    }
}

-(Device*) loadDeviceDictionary:(NSMutableDictionary *)dict{
    Device *device = [[Device alloc]init];
    
    device.name = [dict objectForKey:@"name"];
    NSNumber *mid = [dict objectForKey:@"mid"];
    device.mid = [mid intValue];
    NSNumber *init_type = [dict objectForKey:@"init"];
    device.init_type = [init_type intValue];
    NSNumber *type = [dict objectForKey:@"type"];
    device.type = [type intValue];
    
    NSNumber *segment = [dict objectForKey:@"seg"];
    device.segment = [segment intValue];
    
    device.uuid = [dict objectForKey:@"uuid"];
    device.ssid = [dict objectForKey:@"ssid"];
    device.password = [dict objectForKey:@"password"];
    device.ip = [dict objectForKey:@"ip"];
    device.mac = [dict objectForKey:@"mac"];
    NSNumber *mode = [dict objectForKey:@"mode"];
    device.mode = [mode intValue];
    NSNumber *state = [dict objectForKey:@"state"];
    device.state = [state intValue];
    NSNumber *timeopen = [dict objectForKey:@"timeopen"];
    device.timeopen = [timeopen intValue];
    NSNumber *timeclose = [dict objectForKey:@"timeclose"];
    device.timeclose = [timeclose intValue];
    device.delay = 4;
    return device;
}


-(void) saveDeviceList:(NSMutableArray *)array{
    
    NSMutableArray *devicelist = [[NSMutableArray alloc]init];
    
    for(Device *device in array)
    {
        NSMutableDictionary *node = [self saveDeviceDictionary:device];
        [devicelist addObject:node];
    }
    
    [_config setObject:devicelist forKey:@"devicelist"];
}


-(NSMutableDictionary *) saveDeviceDictionary:(Device *)device{
    
    NSMutableDictionary *node = [[NSMutableDictionary alloc]init];
    [node setObject:[NSNumber numberWithInt: device.mid ] forKey:@"mid"];
    [node setObject:[NSNumber numberWithInt: device.init_type ] forKey:@"init"];
    [node setObject:[NSNumber numberWithInt: device.type ] forKey:@"type"];
    [node setObject:[NSNumber numberWithInt: device.segment ] forKey:@"seg"];
    [node setObject:device.uuid forKey:@"uuid"];
    [node setObject:device.ip forKey:@"ip"];
    [node setObject:device.mac forKey:@"mac"];
    [node setObject:[NSNumber numberWithInt: device.mode] forKey:@"mode"];
    [node setObject:device.name forKey:@"name"];
    [node setObject:device.password forKey:@"password"];
    [node setObject:device.ssid forKey:@"ssid"];
    [node setObject:[NSNumber numberWithInt: device.state] forKey:@"state"];
    [node setObject:[NSNumber numberWithInt: device.timeopen] forKey:@"timeopen"];
    [node setObject:[NSNumber numberWithInt: device.timeclose] forKey:@"timeclose"];
    
    return node;
}


-(void) loadModeList:(NSMutableArray *)array{
    for(NSMutableDictionary *dict in array)
    {
        CustomMode *mode = [self loadModeDictionary:dict];
        [_mode_list addObject:mode];
    }
    
}

-(CustomMode *) loadModeDictionary:(NSMutableDictionary *)dict{
    CustomMode *mode = [[CustomMode alloc]init];
    
    NSNumber *mid = [dict objectForKey:@"mid"];
    mode.mid = [mid intValue];
    mode.name = [dict objectForKey:@"name"];
    NSNumber *type = [dict objectForKey:@"type"];
    mode.type = [type intValue];
    
    NSNumber *light = [dict objectForKey:@"light"];
    mode.light = [light intValue];
    NSNumber *speed = [dict objectForKey:@"speed"];
    mode.speed = [speed intValue];
    NSNumber *change_type = [dict objectForKey:@"change_type"];
    mode.change_type = [change_type intValue];
    
    for(int i= 0; i < 16; i++)
    {
        NSString * name = [[NSString alloc]initWithFormat:@"color%d",i];
        
        NSMutableDictionary *color = [dict objectForKey:name];
        
        NSNumber *red = [color objectForKey:@"red"];
        NSNumber *green = [color objectForKey:@"green"];
        NSNumber *blue = [color objectForKey:@"blue"];
        
        [mode  setRGBByID:[red intValue] greencolor:[green intValue] bluecolor:[blue intValue] index:i ];
        
    }
    
    //
    //    NSMutableArray *colors = [dict objectForKey:@"colors"];
    //
    //    int i = 0;
    //    for(NSMutableDictionary *colordict in colors)
    //    {
    //        if(i<16)
    //        {
    //            NSNumber *red = [colordict objectForKey:@"red"];
    //            NSNumber *green = [dict objectForKey:@"green"];
    //            NSNumber *blue = [dict objectForKey:@"blue"];
    //            [mode  setRGBByID:[red intValue] greencolor:[green intValue] bluecolor:[blue intValue] index:i ];
    //        }
    //    }
    
    return mode;
}

-(void) saveModeList:(NSMutableArray *)array{
    
    NSMutableArray *modelist = [[NSMutableArray alloc]init];
    
    for(CustomMode *mode in array)
    {
        NSMutableDictionary *node = [self saveModeDictionary:mode];
        [modelist addObject:node];
    }
    
    [_config setObject:modelist forKey:@"modelist"];
}


-(NSMutableDictionary *) saveModeDictionary:(CustomMode *)mode{
    NSMutableDictionary *node = [[NSMutableDictionary alloc]init];
    [node setObject:[NSNumber numberWithInt: mode.mid ] forKey:@"mid"];
    [node setObject:mode.name forKey:@"name"];
    [node setObject:[NSNumber numberWithInt: mode.type ] forKey:@"type"];
    [node setObject:[NSNumber numberWithInt: mode.light ]  forKey:@"light"];
    [node setObject:[NSNumber numberWithInt: mode.speed ]  forKey:@"speed"];
    [node setObject:[NSNumber numberWithInt: mode.change_type ]  forKey:@"change_type"];
    
    //    NSMutableDictionary *colors = [[NSMutableDictionary alloc]init];
    
    for(int i = 0; i < 16; i++)
    {
        ColorRGBComm* rgb = [mode getRGBByID:i];
        NSMutableDictionary *color = [[NSMutableDictionary alloc]init];
        
        [color setObject:[NSNumber numberWithInt: rgb.red ] forKey:@"red"];
        [color setObject:[NSNumber numberWithInt: rgb.green ] forKey:@"green"];
        [color setObject:[NSNumber numberWithInt: rgb.blue ] forKey:@"blue"];
        
        NSString *name = [[NSString alloc]initWithFormat:@"color%d",i];
        [node setObject:color forKey:name];
//        [name release];
    }
    
    //    [node setObject:colors forKey:@"colors"];
    return node;
}

-(Device *)getDeviceFromUUID:(NSString *)uuid
{
    
    for (Device *device in  _device_list) {
        if([device.uuid isEqualToString:uuid])
            return device;
    }
    
    return nil;
}

//将扫描次数清零
-(void) zeroScantime
{
    for(Device *device in _device_list)
    {
        device.scantime = 0;
    }
}
//检查上次没有扫描到的
-(id) checkScantime
{
    for(Device *device in _device_list)
    {
        if(device.scantime == 0)
            return device;
    }
    return nil;
}


-(void) addDevice:(Device*)dev
{
    BOOL isRepeat = false;
    for(Device *device in _device_list)
    {
        if([device.uuid isEqualToString:dev.uuid])
        {
            isRepeat = true;
            
            device.name = dev.name;
            device.type = dev.type;
            device.segment = dev.segment;
            device.mode = dev.mode;
        }
    }
    
    
    if(!isRepeat)
    {
        [_device_list addObject:dev];
    }
}

-(void)saveConfig{
    [self saveDeviceList:_device_list];
    [self saveModeList:_mode_list];
    [self saveRouteDictionary];
    
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"DeviceProperty.plist"];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:_config
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];  
    }  
    else {  
        NSLog(@"%@",error);
    }
    
}


-(NSMutableArray*)getDeviceList
{
    return _device_list;
}

@end
