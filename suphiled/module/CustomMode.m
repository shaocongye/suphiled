//
//  CustomMode.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CustomMode.h"

@implementation Device
@synthesize mid = _mid;
@synthesize name = _name;
@synthesize init_type = _init_type;
@synthesize type = _type;
@synthesize segment = _segment;
@synthesize ssid = _ssid;
@synthesize uuid = _uuid;
@synthesize password = _password;
@synthesize ip = _ip;
@synthesize delay = _delay;
@synthesize mac = _mac;
@synthesize mode = _mode;
@synthesize state = _state;
@synthesize timeopen = _timeopen;
@synthesize timeclose = _timeclose;
@synthesize online = _online;
@synthesize scantime = _scantime;

-(id)initWithName:(int)mid name:(NSString *)aName it : (int)inittype type:(int)type seg:(int)segment uuid:(NSString*)uuid sid : (NSString *) ssid pwd : (NSString *)pswd ipaddr : (NSString *) ip maddr : (NSString *)mac md : (int) mode st : (int) state to : (int) timeop tc : (int) timeco
{
    self = [super init];
    if(self)
    {
        _mid = mid;
        _name = [[NSString alloc]init];
        _name = aName;
        _init_type = inittype;//[[NSNumber alloc] initWithInt:inittype];
        _type = type;
        _segment = segment;
        _uuid = [[NSString alloc]init];
        _uuid = uuid;
        _ssid = [[NSString alloc]init];
        _ssid = ssid;
        _password = [[NSString alloc]init];
        _password = pswd;
        _ip = [[NSString alloc]init];
        _ip = ip;
        _mac = [[NSString alloc]init];
        _mac = mac;
        _mode = mode;//[[NSNumber alloc]initWithInt:mode];
        _delay = 4;
        _state = state;//[[NSNumber alloc]initWithInt:state];
        _timeopen = timeop;//[[NSNumber alloc]initWithInt:timeop];
        _timeclose = timeco;//[[NSNumber alloc]initWithInt:timeco];
        _online = NO;
        
        _scantime = -1;
    }
    
    return self;
}

-(void) setScantime:(int)scantime
{
//    if(_scantime<0)
//    {
//        _scantime = 1;
//        return;
//    }
//    
//    if(_scantime>1){
//        _scantime = -1;
//        return;
//    }
    
    _scantime = scantime;
    
}

-(void) dealloc{
//    [_name release];
    //    [_init_type release];
//    [_password release];
//    [_ip release];
//    [_ssid release];
//    [_mac release];
    //    [_mode release];
    //    [_state release];
    //    [_timeclose release];
    //    [_timeopen release];
    
//    [super dealloc];
}

@end

@implementation Route
@synthesize ssid = _ssid;
@synthesize ip = _ip;
@synthesize password = _password;
@synthesize mac = _mac;
@synthesize uuid = _uuid;
@synthesize serial = _serial;
@synthesize first = _first;
@synthesize type = _type;


-(id)initWithName:(NSString *)sid ipaddr:(NSString *)ip pwd:(NSString *)passwd macaddr:(NSString *) mac
{
    self = [super init];
    if(self)
    {
        _ssid = [[NSString alloc]init];
        _ssid = sid;
        _ip = [[NSString alloc]init];
        _ip = ip;
        _password = [[NSString alloc]init];
        _password = passwd;
        _mac = [[NSString alloc]init];
        _mac = mac;
        
        _uuid = [[NSString alloc]init];
        _serial = [[NSString alloc]init];
        _type = 0;
        _first = 0;
    }
    
    return self;
    
}


//-(void) dealloc{
//    [_ssid release];
//    [_ip release];
//    [_password release];
//    [_mac release];
//    [super dealloc];
//}

@end


@implementation ColorRGBComm
@synthesize red = _red;
@synthesize green = _green;
@synthesize blue = _blue;

-(id)initWithName:(int)red greenColor :(int)green blueColor:(int) blue
{
    self = [super init];
    
    _red = red;
    _green = green;
    _blue = blue;
    
    return self;
    
}

//-(void)dealloc{
//    [super dealloc];
//}

@end


@implementation CustomMode
@synthesize mid = _mid;
@synthesize name = _name;
@synthesize type = _type;
@synthesize light = _light;
@synthesize speed = _speed;
@synthesize change_type = _change_type;
//@synthesize colors = _colors;



-(id)initWithName:(int) mid nm : (NSString *)name ty : (int) type lt :(int) light sp : (int) speed ct : (int) change{
    self = [super init ];
    
    _mid = mid;//[[NSNumber alloc] initWithInt:mid];
    _name = [[NSString alloc] init ];
    _name = name;
    _type = type;//[[NSNumber alloc] initWithInt:type];
    _light = light;//[[NSNumber alloc] initWithInt:light];
    _speed = speed;//[[NSNumber alloc] initWithInt:speed];
    _change_type = change;//[[NSNumber alloc] initWithInt:change];
    
    //颜色列表
    //_colors = [[NSMutableArray alloc] initWithCapacity:16];
    for(int i = 0; i < 16; i++)
    {
        _colors[i] = [[ColorRGBComm alloc] initWithName:255 greenColor:255 blueColor:255];
    }
    
    return self;
}

-(void)setRGBByID : (int)red greencolor:(int) green bluecolor:(int)blue index : (int) ind{
    
    ColorRGBComm *rgb = _colors[ind];
    
    rgb.red = red;
    rgb.green = green;
    rgb.blue = blue;
}


-(ColorRGBComm *)getRGBByID:(int) ind{
    return _colors[ind];
}

-(void)removeByID:(int) ind{
    ColorRGBComm *rgb = _colors[ind];// [_colors objectAtIndex:(NSUInteger)ind];
    rgb.red = 255;
    rgb.green = 255;
    rgb.blue = 255;
}

+(CustomMode*)copyWithMode:(CustomMode*)mode
{
    //    CustomMode *cm = [[CustomMode alloc] initWithName:[mode.mid intValue] nm:mode.name ty:[mode.type intValue] lt:[mode.light intValue] sp:[mode.speed intValue] ct:[mode.change_type intValue]];
    
    CustomMode *cm = [[CustomMode alloc] initWithName:mode.mid nm:mode.name ty:mode.type lt:mode.light sp:mode.speed ct:mode.change_type];
    
    for(int i = 0; i < 16; i++)
    {
        ColorRGBComm *rgb = [mode getRGBByID:i];
        [cm setRGBByID:rgb.red greencolor:rgb.green bluecolor:rgb.blue index:i];
    }
    
    return cm;
}

//-(void)dealloc
//{
//    //    [_mid release];
//    [_name release];
//    //    [_type release];
//    //    [_light release];
//    //    [_speed release];
//    //    [_change_type release];
//    
//    for(int i = 0; i < 16; i++)
//    {
//        ColorRGBComm *rgb  = _colors[i];
//        [rgb release];
//    }
//    
//    
//    [super dealloc];
//}

@end
