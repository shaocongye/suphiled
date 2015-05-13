//
//  SudokuView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "SudokuView.h"
#import "CustomMode.h"
#import "SudokuPanel.h"

@implementation SudokuView

- (id)initWithDevice:(NSArray *)devices frame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setDeviceList:devices];
        
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


//按钮事件
- (void) didSelectButton:(int) index
{
    if(self.delegate)
    {        
        [self.delegate didSelectPanel:index];
    }
}

-(void)Changeonline:(BOOL)online uuid:(NSUUID *) uuid
{
    int index = 0;
    for(Device * dev in _device_list)
    {
        if([dev.uuid isEqualToString:[uuid UUIDString]])
        {
            SudokuPanel *button = [_buttons objectAtIndex:index];
            if(button)
                [button Changeonline:online];
        }

        index++;
    }
}

- (BOOL)hasDevice:(Device*)device
{
    for(Device *dev in _device_list)
    {
        if([dev.uuid isEqualToString:device.uuid])
            return true;
    }

    return false;
}

-(void) removeButtonByIndex:(int)index
{
    [_device_list removeObjectAtIndex:index];
    
    for (UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
    if(_buttons)
        [_buttons removeAllObjects];
    else
        _buttons = [[NSMutableArray alloc] init];

    int count = 0;
    for (Device *dev in _device_list)
    {
        
        
        //控制总列数
        int totalColumns = 2;
        
        CGFloat W = self.frame.size.width / 2 - 20;
        CGFloat H = 100;
        
        CGFloat Y = 10;
        CGFloat X = (self.frame.size.width - totalColumns * W) / (totalColumns + 1);
        
        
        int row = count / totalColumns;
        int col = count % totalColumns;
        CGFloat viewX = X + col * (W + X);
        CGFloat viewY = 20 + row * (H + Y);
        CGRect rect = CGRectMake(viewX, viewY, W, H);
        
        SudokuPanel *panel = [[SudokuPanel alloc] initWithDevice:rect panel:dev];
        
        [_buttons addObject:panel];
        [panel setTag:count];
        panel.delegate = self;
        
        
        //添加点按处理
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        singleTap.numberOfTapsRequired = 1;
        
        
        //添加长按处理
        UILongPressGestureRecognizer* singleLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleLongPress:)];
        singleLongPress.delegate = self;
        singleLongPress.cancelsTouchesInView = NO;
        [singleTap requireGestureRecognizerToFail:singleLongPress];
        
        [panel addGestureRecognizer:singleTap];
        [panel addGestureRecognizer:singleLongPress];
        
        [self addSubview:panel];
        
        count ++;
    }
    
}

- (void)addDevice:(Device *)device
{
    
    if(_buttons == nil)
        _buttons = [[NSMutableArray alloc] init];
    
    if(_device_list == nil)
        _device_list = [[NSMutableArray alloc] init];

    if([self hasDevice:device])
        return;
    
    int count = (int)[_buttons count];
    
    
    //控制总列数
    int totalColumns = 2;
    
    CGFloat W = self.frame.size.width / 2 - 20;
    CGFloat H = 100;
    
    CGFloat Y = 10;
    CGFloat X = (self.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    
    [_device_list addObject:device];
    
    int row = count / totalColumns;
    int col = count % totalColumns;
    CGFloat viewX = X + col * (W + X);
    CGFloat viewY = 20 + row * (H + Y);
    CGRect rect = CGRectMake(viewX, viewY, W, H);
    
    SudokuPanel *panel = [[SudokuPanel alloc] initWithDevice:rect panel:device];

    [_buttons addObject:panel];
    [panel setTag:count];
    panel.delegate = self;
    
    
    //添加点按处理
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.numberOfTapsRequired = 1;
    

    //添加长按处理
    UILongPressGestureRecognizer* singleLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleLongPress:)];
    singleLongPress.delegate = self;
    singleLongPress.cancelsTouchesInView = NO;
    [singleTap requireGestureRecognizerToFail:singleLongPress];
    
    [panel addGestureRecognizer:singleTap];
    [panel addGestureRecognizer:singleLongPress];

    [self addSubview:panel];
    
    count++;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(int)getIndexByPoint:(CGPoint)point
{
    int col = point.x > self.frame.size.width/2 ? 1: 0;
    int row = point.y /100;
    
    return row * 2 + col;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];

    if(self.delegate){
        [self.delegate didSelectPanel:[self getIndexByPoint:point]];
    }
}


-(void)handleSingleLongPress:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self];
        if(self.delegate){
            [self.delegate didEditPanel:[self getIndexByPoint:point]];
        }        
    }
}


- (void)clearDevice
{
    for (UIView *v in self.subviews)
    {
        [v removeFromSuperview];
    }
    if(_buttons)
        [_buttons removeAllObjects];
    else
        _buttons = [[NSMutableArray alloc] init];
    
    
    if(_device_list)
        [_device_list removeAllObjects];
    else
        _device_list = [[NSMutableArray alloc] init];
    
}


- (Device*)getDeviceByIndex:(int)index
{
    if(index < [_device_list count])
        return [_device_list objectAtIndex:index];
    else
        return nil;
}

- (void)setDeviceByIndex:(Device *)device index:(int)index
{
    if(index > ([_device_list count] - 1))
        return;
    
    [_device_list replaceObjectAtIndex:index withObject:device];
    
    SudokuPanel *panel = [_buttons objectAtIndex:index];
    if(panel){
        panel.sudoku = device;
        [panel setTitle:device.name];
    }
    
}


@end
