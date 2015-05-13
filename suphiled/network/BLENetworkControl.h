//
//  BLENetworkControl.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-9.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


//分段标志位
#define SEGMENT_ONE_FLAG    0x01
#define SEGMENT_TWO_FLAG    0x02
#define SEGMENT_THREE_FLAG  0x04
#define SEGMENT_FOUR_FLAG   0x08
#define SEGMENT_FIVE_FLAG   0x010
#define SEGMENT_ALL_FLAG    0x020
#define SEGMENT_NIGHT_FLAG  0x040



@protocol BLENetworkControlDelegate <NSObject>

-(void) ConnectedBLEDevice:(NSUUID*) uuid;
-(void) DisconnectedBLEDevice:(NSUUID*) uuid;
-(void) DiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData;
-(void) ReturnPeriopheralData:(unsigned char*)data slen:(int) len;

@end


typedef struct Comm{
    unsigned char version;
    unsigned char command;
    unsigned char value1;
    unsigned char value2;
    unsigned char value3;
    unsigned char value4;
    unsigned char value5;
    unsigned char value6;
}_Comm,*PComm;

typedef struct ResultData{
    unsigned char   version;    //TO_APP_VERSION 0x88
    unsigned char   type;       //101
    unsigned char   len;        //接下来几个字节
    unsigned char   Switch;     //0 关闭，1开
    unsigned char   light;      //亮度
    unsigned char   color;      //颜色
//    unsigned char   segment;    //多路开关
    unsigned char   segtype;    //多路开关状态
}_ResultData,*PResultData;

enum CommandType{
    APP_COMMAND_SWITCH_ON       = 0,
    APP_COMMAND_SWITCH_OFF      = 1,
    APP_COMMAND_READDATA        = 2,        //返回当前状态信息
    APP_COMMAND_SET_LIGHTCHANGE = 3,    //设置呼吸灯
    APP_COMMAND_SET_LIGHT       = 4,        // 设置亮度
    APP_COMMAND_SET_DELAY_ON    = 5,        //延时关机
    APP_COMMAND_SET_DELAY_OFF   = 6,    //取消延时
    APP_COMMAND_SET_COLOR       = 7,        //修改颜色
    APP_COMMAND_SET_MUTISEG     = 8,        //设置模式
    APP_COMMAND_SAVE            = 9,        //保存设置
    APP_COMMAND_SET_MODE        = 10        //
};


enum ResultType{
    RESULT_TYPE_NONE = 0,
    RESULT_TYPE_SAVE = 100,         //保存返回标志
    RESULT_TYPE_STATUS = 101,       //查询状态返回数据
    RESULT_TYPE_DELAY = 102         //延时关灯返回

};


enum LampType{
    BALL_LAMP = 0,      //球泡
    CEILING_LAMP = 1,   //吸顶灯
    SEGMENT_LAMP = 2    //分段开关
};

@interface BLENetworkControl : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCharacteristic *_writeCharacteristic;
    float _batteryValue;
    int _status;
}
//@property bool cbReady;
@property BOOL cbConnected;
@property (nonatomic,strong) CBCentralManager *cbCM;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;

@property (strong,nonatomic) CBPeripheral *cbPeripheral;
@property (strong,nonatomic) CBService *cbServices;
@property (strong,nonatomic) CBCharacteristic *cbCharacteristcs;

@property (retain,nonatomic) id<BLENetworkControlDelegate> delegate;

-(id) initWithUUID:(NSString*)uuid;

-(void) SendDataToPrepharal:(unsigned char *)data;
-(void) ReadDataFromPrepharal;

-(void) ScanBLEPrepharal;
-(void) ConnectedBLEPrepharal:(BOOL) online;
-(int) getStatus;

@end
