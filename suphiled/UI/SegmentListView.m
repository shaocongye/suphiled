//
//  SegmentListView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-3-23.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "SegmentListView.h"
#import "UIDevice+Resolutions.h"
#import "SegmentView.h"
#import "BLENetworkControl.h"
#define VALUE_CELL_HEIGHT 38
#define VALUE_CELL_HEIGHT_320 30


@implementation SegmentListView
@synthesize enable = _enable;
@synthesize viewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        _lastTag = -1;
        _enable = YES;
        _SegList = [[NSMutableArray alloc] initWithCapacity:10];
        int modeHeight = [self getSegmentHeight] + 1;
        
        self.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:0.5];
        
        for(int i = 0; i < 7; i++)
        {
            SegmentView *mode = [[SegmentView alloc] initWithFrame:CGRectMake(0, i * modeHeight, frame.size.width, modeHeight)];
            [mode addTarget:self action:@selector(selectedSeg:) forControlEvents:UIControlEventTouchUpInside];
            
            mode.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            mode.tag = i;
            
            switch (i) {
                case 0:
                    [mode setText: @"A"];
                    break;
                case 1:
                    [mode setText: @"B"];
                    break;
                case 2:
                    [mode setText: @"C"];
                    break;
                case 3:
                    [mode setText: @"D"];
                    break;
                case 4:
                    [mode setText: @"E"];
                    break;
                case 5:
                    [mode setText: NSLocalizedString(@"allmode",nil)];
                    mode.tag = 98;
                    break;
                case 6:
                    [mode setText: NSLocalizedString(@"nightmode",nil)];
                    mode.tag = 99;
                    break;
                default:
                    break;
            }
            
            
            [_SegList addObject:mode];
            [self addSubview:mode];
        }
        

    }
    return self;
}

-(void) setSegment:(int)segment
{
    
    _segment = segment;
    
    if(_segment == 0)
        _segment = 4;
    
    //修改显示界面
    int modeHeight = [self getSegmentHeight] + 1;

    //先控制显示条目
    for(SegmentView *mode in _SegList)
    {
        if(mode.tag < _segment || mode.tag >90)
            mode.hidden = NO;
        else
            mode.hidden = YES;
    }

    //｀挪动后两个控制条目到合适位置
   for(SegmentView *mode in _SegList)
    {
        if(mode.tag == 98)
        {
            [mode setFrame:CGRectMake(0, _segment * modeHeight, self.frame.size.width, modeHeight-2)];
        }
        
        if(mode.tag == 99)
        {
            [mode setFrame:CGRectMake(0, (_segment + 1) * modeHeight -2, self.frame.size.width, modeHeight-2)];
        }
    }
    
}

-(int)getSegmentHeight
{
    return (self.frame.size.height-5)/7;
}


//除了小夜灯和全亮外都是可以多选
- (void) selectedSeg :(SegmentView*) sender
{
    int stat = 0;

    //首先判断是否小夜灯还是全亮
    if(sender.tag > 6)
    {
        for(SegmentView *mode in [self subviews])
        {
            if(mode.tag == sender.tag)
                [mode clicked];
            else
                [mode unclicked];
        }
        
        if(sender.tag == 98)
            stat |= SEGMENT_ALL_FLAG;
        else
            stat |= SEGMENT_NIGHT_FLAG;
        
    } else {
        for(SegmentView *mode in [self subviews])
        {
            if([mode getSelect])
            {
                //删除全亮和小夜灯选择
                if(mode.tag > 3)
                    [mode unclicked];
                
                //反选
                if(mode.tag == sender.tag)
                {
                    [mode unclicked];
                }
            } else {
                if(mode.tag == sender.tag)
                {
                    [mode clicked];
                }
            }
            
            //计算标志位
            if([mode getSelect])
            {
                switch (mode.tag) {
                    case 0:
                        stat |= SEGMENT_ONE_FLAG;
                        break;
                    case 1:
                        stat |= SEGMENT_TWO_FLAG;
                        break;
                    case 2:
                        stat |= SEGMENT_THREE_FLAG;
                        break;
                    case 3:
                        stat |= SEGMENT_FOUR_FLAG;
                        break;
                    case 4:
                        stat |= SEGMENT_FIVE_FLAG;
                        break;
                    default:
                        break;
                }
            }
        }
    }

    _lastTag = (int)sender.tag;
    if(viewDelegate)
        [viewDelegate selectSegment:stat];
    
}

-(void) setSegEnable:(BOOL)enable
{
    _enable = enable;
    
    for(SegmentView *view in [self subviews])
    {
        view.enable = _enable;
    }
}

//控制
-(void) controlSeg:(int)seg
{
    //首先判断是否小夜灯还是全亮
    if(seg > 4)
    {
        
        for(SegmentView *mode in [self subviews])
        {
            if(mode.tag == seg)
                [mode clicked];
            else
                [mode unclicked];
        }
        
    } else {
        for(SegmentView *mode in [self subviews])
        {
            if(mode.tag == seg){
                [mode clicked];
            }
            
            if(mode.tag > 4)
                [mode unclicked];
        }
    }
    
    _lastTag = seg;
    
}

-(int)  getSegment
{
    int seg = 0;
    
    for(SegmentView *mode in [self subviews])
    {
        if([mode getSelect])
        {
            if(mode.tag < 90)
            {
                seg |= 0x01 <<  mode.tag;
            } else {
               if(mode.tag == 98)
//                   seg |= 0x20;//全亮模式
               {
                   switch (_segment) {
                       case 0:
                       case 1:
                           seg = 0x01;
                       case 2:
                           seg = 0x03;
                           break;
                       case 3:
                           seg = 0x07;
                           break;
                       case 4:
                           seg = 0x0f;
                       case 5:
                           seg = 0x1f;
                       default:
                           seg = 0x01;
                           break;
                   }
               }
               else
                   seg |= 0x40;//小夜灯模式
            }
        }
    }
    
    return seg;
}

-(void) clearAllSelectSeg
{
    for(SegmentView *mode in [self subviews])
    {
        [mode unclicked];
    }
}


@end
