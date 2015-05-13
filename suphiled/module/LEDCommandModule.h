//
//  LEDCommandModule.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-2.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct {
    char _red;
    char _green;
    char _blue;
    char _alpha;
}ColorRGB;

typedef struct {
    char _command;
    char _mac[8];
}LEDCommand_init;

typedef struct {
    char _command;
    char _mac[8];
    char _switch;
	char _mode;
	int _open_time;
    int _close_time;
}LEDCommand_state;

typedef struct {
    char _command;
    char _mac[8];
    int _ip;
}LEDCommand_mac;

typedef struct {
    char _command;
    char _mac[8];
	char _ssid[24];
	char _passwd[20];
    int _ip;
}LEDCommand_route;

typedef struct {
    char _command;
    char _mac[8];
    char _switch;
}LEDCommand_switch;

typedef struct {
    char _command;
    char _mac[8];
	int _open_time;
    int _close_time;
}LEDCommand_time;

typedef struct {
    char _command;
    char _mac[8];
    char _mode;
}LEDCommand_getmode;



typedef struct {
    char _command;
    char _mac[8];
    char _mode;
    
    ColorRGB _color[16];
    
    char _speed;
	char _light;
    char _change;
}LEDCommand_mode;



typedef struct{
    char _command;
    char _mac[8];
    char _switch;
	char _mode;
	char _light;
	char _ssid[24];
	char _passwd[20];
    char _change;
	char _speed;
    
	int _open_time;
    int _close_time;
    int ip;
    
    ColorRGB _color[16];
}LEDCommand;




@interface LEDCommandModule : NSObject
{
}

-(NSData*) getInitCommand:(LEDCommand *)cmd;
-(LEDCommand*) setInitCommand:(NSData *)cmd;


-(NSData*) getStateCommand:(LEDCommand *)cmd;
-(LEDCommand*) setStateCommand:(NSData *)cmd;


-(NSData*) getMacCommand:(LEDCommand *)cmd;
-(LEDCommand*) setMacCommand:(NSData *)cmd;


-(NSData*) getRouteCommand:(LEDCommand *)cmd;
-(LEDCommand*) setRouteCommand:(NSData *)cmd;


-(NSData*) getSwitchCommand:(LEDCommand *)cmd;
-(LEDCommand*) setSwitchCommand:(NSData *)cmd;


-(NSData*) getTimeCommand:(LEDCommand *)cmd;
-(LEDCommand*) setTimeCommand:(NSData *)cmd;


-(NSData*) getGetModeCommand:(LEDCommand *)cmd;
-(LEDCommand*) setGetModeCommand:(NSData *)cmd;


-(NSData*) getModeCommand:(LEDCommand *)cmd;
-(LEDCommand*) setModeCommand:(NSData *)cmd;


@end
