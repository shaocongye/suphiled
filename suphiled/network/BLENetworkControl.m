//
//  BLENetworkControl.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-9.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "BLENetworkControl.h"
#import "BLEUtility.h"

#define _DEBUG_LOG 1

@implementation BLENetworkControl
//@synthesize cbReady;
@synthesize cbConnected;
@synthesize cbCM;
@synthesize cbPeripheral;
@synthesize cbServices;
@synthesize cbCharacteristcs;
@synthesize nDevices;
@synthesize nServices;
@synthesize nCharacteristics;

-(id) initWithUUID:(NSString*)uuid
{
    self = [super init];
    
#ifdef _DEBUG_LOG
    NSLog(@"Initializing BLE");
#endif
    if(self){
        cbCM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        cbServices =[[CBService alloc]init];
        cbCharacteristcs =[[CBCharacteristic alloc]init];
    
        //列表初始化
        nDevices = [[NSMutableArray alloc]init];
        nServices = [[NSMutableArray alloc]init];
        nCharacteristics = [[NSMutableArray alloc]init];
        cbPeripheral = nil;
        cbConnected = NO;
        _status = 0;
    }
    
    return self;
}


//输出数据到蓝牙设备
-(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    
#ifdef _DEBUG_LOG
    NSLog(@"service : %lu",(unsigned long)[peripheral.services count]);

    for ( CBService *service in peripheral.services ) {
        
        NSLog(@"service:  %@",service);
    }
#endif
    
    
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
                    
                }
            }
        }
    }
}




//扫描事件
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    cbReady = false;
    cbConnected = NO;
    _status = 0;
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            //设备关闭
            NSLog(@"蓝牙BLE已设备关闭");
            break;
        case CBCentralManagerStatePoweredOn:
            // 设备开启 -- 可用状态
            NSLog(@"蓝牙BLE设备开启");
            //cbReady = true;
        case CBCentralManagerStateResetting:
            //正在重置
            NSLog(@"蓝牙BLE正在重置");
            break;
        case CBCentralManagerStateUnauthorized:
            // 设备未授权
            NSLog(@"蓝牙BLE设备未授权");
            break;
        case CBCentralManagerStateUnknown:
            // 初始的时候未知（刚刚创建的时候）
            NSLog(@"蓝牙BLE初始的时候未知状态");
            break;
        case CBCentralManagerStateUnsupported:
            //设备不支持
            NSLog(@"蓝牙设备不支持BLE");
            break;
        default:
            break;
    }
    
}

//已发现从机设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
#ifdef _DEBUG_LOG
    NSLog(@" 发现从机  peripheral: %@ \nadvertisement: %@",peripheral,advertisementData);
#endif
    NSString * title = [advertisementData  objectForKey:@"kCBAdvDataLocalName"];
    
    NSString *name = @"ShowLightLED";
    NSRange range = [title rangeOfString:name];
    
    if(range.location != NSNotFound)
    {
        BOOL replace = NO;
        
        //如果是已有的设备，就替换   Match if we have this device from befor
        for (int ii=0; ii < nDevices.count; ii++) {
            CBPeripheral *p = [nDevices objectAtIndex:ii];
            if ([p isEqual:peripheral]) {
                
                [nDevices replaceObjectAtIndex:ii withObject:peripheral];
                replace = YES;
            }
        }
        
        //没有在就添加到列表中
        if (!replace) {
            [nDevices addObject:peripheral];
            cbPeripheral = peripheral;   //当前的链接
            NSLog(@"找到设备%@",peripheral.name);
        }
        
        if(self.delegate)
        {
            [self.delegate DiscoverPeripheral:peripheral advertisementData:advertisementData];
        }
    }
}


//已链接到从机
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //发现services
    //设置peripheral的delegate未self非常重要，否则，didDiscoverServices无法回调
    [self.cbPeripheral setDelegate:self];
    [self.cbPeripheral discoverServices:nil];
    
    NSLog(@"扫描服务  Connection successfull to peripheral with UUID: %@",peripheral.identifier);

    cbConnected = YES;
    [self ReadDataFromPrepharal];
    
    if(self.delegate)
    {
        [self.delegate ConnectedBLEDevice:peripheral.identifier];
    }
}

//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    int i=0;
    for (CBService *s in peripheral.services) {
        [self.nServices addObject:s];
    }
    
    for (CBService *s in peripheral.services) {
#ifdef _DEBUG_LOG
        NSLog(@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID);
#endif
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}



//已断开从机的链接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
#ifdef _DEBUG_LOG
    NSLog(@"断开从机  %@",peripheral);
#endif

    //设备断开了
    cbConnected = NO;
    if(self.delegate)
        [self.delegate DisconnectedBLEDevice:peripheral.identifier];

}

//
- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    
    
    
}

//
- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    
    NSLog(@"Currently known peripherals :");
    int i = 0;
    for(CBPeripheral *peripheral in peripherals) {
        
        NSLog(@"从机  [%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.identifier);
        //Do something on each known peripheral.
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"发现服务%@的特征: (%@)",service.UUID.data ,service.UUID);
    
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"特征 UUID: %@ (%@)  %@",c.UUID.data,c.UUID,c);
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"fff1"]]) {
            [cbPeripheral readRSSI];
        }
        
        [nCharacteristics addObject:c];
        if( [c.UUID isEqual:[CBUUID UUIDWithString:@"fff4"]])
            [cbPeripheral setNotifyValue:YES forCharacteristic:c];

    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error==nil) {
        //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        [peripheral readValueForCharacteristic:characteristic];
    }
}

//监听设备
-(void)startSubscribe
{
    [cbPeripheral setNotifyValue:YES forCharacteristic:cbCharacteristcs];
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fff4"]]) {
        
        NSData *value = characteristic.value;
        if(value == nil)
            return;
        if([value length] > 1)
        {
            unsigned char data[10] = {0};
            memcpy(data, [value bytes], [value length]);
            
            _status = (int)data[0];
            
            
            if(self.delegate)
            {
                [self.delegate ReturnPeriopheralData:data slen:(int)[value length]];
            }
        }
    }
    else
        NSLog(@"didUpdateValueForCharacteristic%@",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}


-(void) SendDataToPrepharal:(unsigned char *)data
{
    [BLEUtility writeCharacteristic:cbPeripheral sUUID:@"FFF0" cUUID:@"FFF1" data:[NSData dataWithBytes:data length:8]];
    
}

//扫描蓝牙设备
-(void) ScanBLEPrepharal
{
    [self.nDevices removeAllObjects];
    [self.nServices removeAllObjects];
    
    self.cbConnected = NO ;
    
    self.cbPeripheral = nil;
    self.cbServices = nil;
    self.cbCharacteristcs = nil;

    
    [cbCM scanForPeripheralsWithServices:nil options:nil];
}

//连接关闭设备
-(void) ConnectedBLEPrepharal:(BOOL) online;
{
    if(cbPeripheral)
    {
        if(online)
        {
            if (cbConnected == NO) {
                [self.cbCM connectPeripheral:cbPeripheral options:nil];
            }
        } else {
            if (cbConnected == YES) {
                [self.cbCM cancelPeripheralConnection:cbPeripheral];
            }
        }
        
    }
}


-(void) ReadDataFromPrepharal
{
    
    
    unsigned char data[20] = {0};
    _Comm *command = (_Comm *)data;
    command->version = 1;
    command->command = (char)APP_COMMAND_READDATA;
    command->value1 = (unsigned char)(int)(255);
    command->value2 = (unsigned char)(int)(255);
    command->value3 = (unsigned char)(int)(255);
    command->value4 = (unsigned char)(int)(255);
    command->value5 = (unsigned char)(int)(255);
    command->value6 = (unsigned char)(int)(255);
    
    [BLEUtility writeCharacteristic:cbPeripheral sUUID:@"FFF0" cUUID:@"FFF1" data:[NSData dataWithBytes:data length:2]];

}

-(int) getStatus
{
    if(cbConnected)
        if(_status == 0)
            return 0;
    
    return 1;
}

@end
