//
//  LampListView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "LampListView.h"
#import "LampCell.h"
#import "UIDevice+Resolutions.h"

@implementation LampListView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commInit:nil];
    }
    return self;
}

- (id)initWithDevice:(NSArray *)devices frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commInit:devices];
    }
    
    return self;
}

-(void) commInit:(NSArray *)devices
{
    if(_device_list == nil)
        _device_list = [[NSMutableArray alloc] init];
    
    if(devices != nil)
        [_device_list addObjectsFromArray:devices];
    
    int currentResolution = (int)[UIDevice currentResolution];

    // Initialization code
    _device_list = [[NSMutableArray alloc] init];
    
    _flowLayout= [[KRLCollectionViewGridLayout alloc]init];
    
    //iPad是5列  iPhone是3列
    if(currentResolution >= UIDevice_iPadStandardRes)
        _flowLayout.numberOfItemsPerLine = 5;
    else
        _flowLayout.numberOfItemsPerLine = 3;
    
    _flowLayout.aspectRatio = 1;
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 30);
    _flowLayout.interitemSpacing = 7;
    _flowLayout.lineSpacing = 7;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    [self addSubview:_collectionView];
    [_collectionView registerClass:[LampCell class]
        forCellWithReuseIdentifier:@"Cell"];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
}


- (UICollectionViewFlowLayout *)layout
{
    return (id)_collectionView.collectionViewLayout;
}

         
//只有一种可能
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _device_list.count;
}

//构建每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LampCell *lamp = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  
    Device *dev = [_device_list objectAtIndex:indexPath.row];
    
    
    if(lamp.device == nil)
        [lamp setDevice:dev];
    lamp.tag = indexPath.row;
    
    lamp.delegate = self;
    
    return lamp;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LampCell * cell = (LampCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell)
    {
        
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



//添加一个设备到列表中
- (void)addDevice:(Device *)device
{
    
    if(_device_list == nil)
        _device_list = [[NSMutableArray alloc] init];
    
    if(_device_list)
    {
        BOOL has = FALSE;
        
        for(Device *dev in _device_list)
        {
            if([dev.uuid isEqualToString: device.uuid]){
                has = TRUE;
                
                break;
            }
        }
        
        if(!has)
            [_device_list addObject:device];
    }
    
    //刷新界面
    NSLog(@"刷新界面");
    [_collectionView reloadData];
}

- (void)removeButtonByIndex:(int)index
{
    [_device_list removeObjectAtIndex:index];
    [_collectionView reloadData];
}

- (void)clearDevice
{
    NSLog(@"删除所有的设备");
    
    [_device_list removeAllObjects];
    [_collectionView reloadData];
}

//连接设备
-(void)didSelectButton:(int)index
{
    if(self.delegate)
    {
        [self.delegate didSelectLamp:index];
    }
}

//编辑设备名
-(void)didEditButton:(int)index
{
    if(self.delegate)
    {
        [self.delegate didEditLamp:index];
    }
}

- (Device*)getDeviceByIndex:(int)index
{
    return [_device_list objectAtIndex:index];
}



- (void)setDeviceByIndex:(Device *)device index:(int)index
{
    if(index > ([_device_list count] - 1))
        return;
    
    [_device_list replaceObjectAtIndex:index withObject:device];
    
    [_collectionView reloadData];
}

- (void)Changeonline:(BOOL)online uuid:(NSUUID *) uuid
{
    int index = 0;
    
    for(Device * dev in _device_list)
    {
        if([dev.uuid isEqualToString:[uuid UUIDString]])
        {
            
            dev.online = online;
            
            [_collectionView reloadData];
        }
        
        index++;
    }
}

- (void)removeDevice:(NSString *) uuid
{
    
    for(Device * dev in _device_list)
    {
        if([dev.uuid isEqualToString:uuid ])
        {
            [_device_list removeObject:dev];
            [_collectionView reloadData];
            
            return;
        }
    }
}


- (void)removeLamp:(NSUUID *) uuid
{
    int index = 0;
    
    for(Device * dev in _device_list)
    {
        if([dev.uuid isEqualToString:[uuid UUIDString]])
        {
            [_device_list removeObject:dev];
            
            [_collectionView reloadData];
        }
        
        index++;
    }
}

-(void)didSelectLamp :(int) index
{
    
}

-(void)didEditLamp : (int)index
{

}

@end
