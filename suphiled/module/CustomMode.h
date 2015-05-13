//
//  CustomMode.h
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject
{
    int _mid;
    NSString * _name;
    int  _init_type;
    int _type;
    NSString * _uuid;
    NSString * _ssid;
    NSString * _password;
    NSString * _ip;
    NSString * _mac;
    int  _mode;
    int  _delay;
    int  _state;
    int  _segment;
    int  _timeopen;
    int  _timeclose;
    BOOL  _online;
    
    int _scantime;
}

@property int mid;
@property (nonatomic,retain) NSString * name;
@property int init_type;
@property int type;
@property (nonatomic,retain) NSString * uuid;
@property (nonatomic,retain) NSString * ssid;
@property (nonatomic,retain) NSString * password;
@property (nonatomic,retain) NSString * ip;
@property (nonatomic,retain) NSString * mac;
@property int mode;
@property int delay;
@property int state;
@property int segment;
@property int timeopen;
@property int timeclose;
@property (nonatomic) int scantime;
@property BOOL online;

-(id)initWithName:(int)mid name:(NSString *)aName it : (int)inittype type:(int)type seg:(int)segment uuid:(NSString*)uuid sid : (NSString *) ssid pwd : (NSString *)pswd ipaddr : (NSString *) ip maddr : (NSString *)mac md : (int) mode st : (int) state to : (int) timeop tc : (int) timeco;

-(void) setScantime:(int)scantime;

@end

@interface Route : NSObject
{
    NSString * _ssid;
    NSString * _ip;
    NSString * _mac;
    NSString * _password;
    NSString * _uuid;
    int  _type;
    int  _first;
    NSString * _serial;
    
    
}

@property (nonatomic, retain) NSString * ssid;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSString * mac;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * serial;
@property int first;
@property int type;

-(id)initWithName:(NSString *)sid ipaddr:(NSString *)ip pwd:(NSString *)passwd macaddr:(NSString *) mac;

@end


@interface ColorRGBComm : NSObject
{
    //    NSNumber * _cid;
    int _red;
    int _green;
    int _blue;
}


//@property (nonatomic,retain) NSNumber *cid;
@property int red;
@property int green;
@property int blue;

-(id)initWithName:(int)red greenColor :(int)green blueColor:(int) blue;


@end

@interface CustomMode : NSObject
{
    int  _mid;
    NSString  *_name;
    int  _type;
    int  _light;
    int  _speed;
    int  _change_type;
    ColorRGBComm  *_colors[16];
}

@property int  mid;
@property (nonatomic, retain) NSString * name;
@property int  type;
@property int  light;
@property int  speed;
@property int  change_type;
//@property (nonatomic, retain) ColorRGBComm *colors[16];

-(id)initWithName:(int) mid nm : (NSString *)name ty : (int) type lt :(int) light sp : (int) speed ct : (int) change;
-(ColorRGBComm *)getRGBByID:(int) ind;
-(void)setRGBByID : (int)red greencolor:(int) green bluecolor:(int)blue index : (int) ind;

+(CustomMode*)copyWithMode:(CustomMode*)mode;
@end
