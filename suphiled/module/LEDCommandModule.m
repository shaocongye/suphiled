//
//  LEDCommandModule.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-2.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "LEDCommandModule.h"

@implementation LEDCommandModule


-(NSData*) getInitCommand:(LEDCommand *)cmd
{
    LEDCommand_init init_cmd;
    init_cmd._command = cmd->_command;
    memcpy(init_cmd._mac, cmd->_mac, sizeof(init_cmd._mac));
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&init_cmd length:sizeof(init_cmd)];
    
    
    return data;
}

-(LEDCommand*) setInitCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_init init_cmd;
    [data getBytes:&init_cmd length:sizeof(init_cmd)];
    
    cmd->_command = init_cmd._command;
    memcpy(cmd->_mac,init_cmd._mac,sizeof(cmd->_mac));
    
    
    return cmd;
}

-(NSData*) getStateCommand:(LEDCommand *)cmd
{
    LEDCommand_state state_cmd;
    state_cmd._command = cmd->_command;
    memcpy(state_cmd._mac, cmd->_mac, sizeof(state_cmd._mac));
    state_cmd._switch = cmd->_switch;
	state_cmd._mode = cmd->_mode;
	state_cmd._open_time = cmd->_open_time;
    state_cmd._close_time = cmd->_close_time;
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&state_cmd length:sizeof(state_cmd)];
    
    
    return data;
}
-(LEDCommand*) setStateCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_state state_cmd;
    [data getBytes:&state_cmd length:sizeof(state_cmd)];
    
    cmd->_command = state_cmd._command;
    memcpy(cmd->_mac, state_cmd._mac, sizeof(state_cmd._mac));
    cmd->_switch = state_cmd._switch;
	cmd->_mode = state_cmd._mode;
	cmd->_open_time = state_cmd._open_time;
    cmd->_close_time = state_cmd._close_time;
    
    return cmd;
}


-(NSData*) getMacCommand:(LEDCommand *)cmd
{
    LEDCommand_mac mac_cmd;
    mac_cmd._command = cmd->_command;
    memcpy(mac_cmd._mac,cmd->_mac,sizeof(mac_cmd._mac));
    mac_cmd._ip = cmd->ip;
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&mac_cmd length:sizeof(mac_cmd)];
    
    
    return data;
}

-(LEDCommand*) setMacCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_mac mac_cmd;
    [data getBytes:&mac_cmd length:sizeof(mac_cmd)];
    
    cmd->_command = mac_cmd._command;
    cmd->ip  = mac_cmd._ip;
    memcpy(cmd->_mac,mac_cmd._mac,sizeof(mac_cmd._mac));
    return cmd;
}


-(NSData*) getRouteCommand:(LEDCommand *)cmd
{
    LEDCommand_route route_cmd;
    
    route_cmd._command = cmd->_command;
    route_cmd._ip = cmd->ip;
    memcpy(route_cmd._mac,cmd->_mac,sizeof(route_cmd._mac));
    memcpy(route_cmd._ssid,cmd->_ssid,sizeof(route_cmd._ssid));
    memcpy(route_cmd._passwd,cmd->_passwd,sizeof(route_cmd._passwd));
    
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&route_cmd length:sizeof(route_cmd)];
    
    
    return data;
}
-(LEDCommand*) setRouteCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_route route_cmd;
    [data getBytes:&route_cmd length:sizeof(route_cmd)];
    
    cmd->_command = route_cmd._command;
    cmd->ip = route_cmd._ip;
    memcpy(cmd->_mac,route_cmd._mac,sizeof(route_cmd._mac));
    memcpy(cmd->_ssid,route_cmd._ssid,sizeof(route_cmd._ssid));
    memcpy(cmd->_passwd,route_cmd._passwd,sizeof(route_cmd._passwd));
    
    return cmd;
}


-(NSData*) getSwitchCommand:(LEDCommand *)cmd
{
    LEDCommand_switch switch_cmd;
    
    switch_cmd._command = cmd->_command;
    memcpy(switch_cmd._mac,cmd->_mac,sizeof(switch_cmd._mac));
    switch_cmd._switch = cmd->_switch;
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&switch_cmd length:sizeof(switch_cmd)];
    
    
    return data;
}

-(LEDCommand*) setSwitchCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_switch switch_cmd;
    [data getBytes:&switch_cmd length:sizeof(switch_cmd)];
    
    
    cmd->_command = switch_cmd._command;
    cmd->_switch  = switch_cmd._switch;
    memcpy(cmd->_mac,switch_cmd._mac,sizeof(switch_cmd._mac));
    
    return cmd;
}


-(NSData*) getTimeCommand:(LEDCommand *)cmd
{
    LEDCommand_time time_cmd;
    
    time_cmd._command = cmd->_command;
    memcpy(time_cmd._mac,cmd->_mac,sizeof(time_cmd._mac));
    time_cmd._close_time = cmd->_close_time;
    time_cmd._open_time = cmd->_open_time;
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&time_cmd length:sizeof(time_cmd)];
    
    
    return data;
}

-(LEDCommand*) setTimeCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_time time_cmd;
    [data getBytes:&time_cmd length:sizeof(time_cmd)];
    
    
    cmd->_command = time_cmd._command;
    cmd->_close_time  = time_cmd._close_time;
    cmd->_open_time  = time_cmd._open_time;
    memcpy(cmd->_mac,time_cmd._mac,sizeof(time_cmd._mac));
    
    
    return cmd;
}


-(NSData*) getGetModeCommand:(LEDCommand *)cmd
{
    LEDCommand_getmode mode_cmd;
    
    mode_cmd._command = cmd->_command;
    memcpy(mode_cmd._mac,cmd->_mac,sizeof(mode_cmd._mac));
    mode_cmd._mode = cmd->_mode;
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&mode_cmd length:sizeof(mode_cmd)];
    
    
    return data;
}

-(LEDCommand*) setGetModeCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_getmode mode_cmd;
    [data getBytes:&mode_cmd length:sizeof(mode_cmd)];
    
    cmd->_command = mode_cmd._command;
    cmd->_mode = mode_cmd._mode;
    memcpy(cmd->_mac,mode_cmd._mac,sizeof(mode_cmd._mac));
    
    
    return cmd;
}


-(NSData*) getModeCommand:(LEDCommand *)cmd
{
    LEDCommand_mode mode_cmd;
    
    mode_cmd._command = cmd->_command;
    memcpy(mode_cmd._mac,cmd->_mac,sizeof(mode_cmd._mac));
    mode_cmd._mode = cmd->_mode;
    mode_cmd._speed = cmd->_speed;
	mode_cmd._light = cmd->_light;
    mode_cmd._change = cmd->_change;
    memcpy(mode_cmd._color,cmd->_color,sizeof(mode_cmd._color));
    
    NSData *data = [[NSData alloc]initWithBytes:(const char*)&mode_cmd length:sizeof(mode_cmd)];
    
    
    return data;
}

-(LEDCommand*) setModeCommand:(NSData *)data
{
    LEDCommand *cmd = malloc(sizeof(LEDCommand));
    
    LEDCommand_mode mode_cmd;
    [data getBytes:&mode_cmd length:sizeof(mode_cmd)];
    
    cmd->_command = mode_cmd._command;
    cmd->_mode = mode_cmd._mode;
    memcpy(cmd->_mac,mode_cmd._mac,sizeof(mode_cmd._mac));
    cmd->_speed = mode_cmd._speed;
	cmd->_light = mode_cmd._light;
    cmd->_change = mode_cmd._change;
    memcpy(cmd->_color,mode_cmd._color,sizeof(cmd->_color));
    
    
    return cmd;
}


@end
