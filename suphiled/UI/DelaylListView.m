//
//  DelaylListView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-11-2.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "DelaylListView.h"
#import "ModeView.h"
#import "UIDevice+Resolutions.h"

@implementation DelaylListView
@synthesize delayDelegate;
@synthesize enable = _enable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lastTag = -1;
        _enable = YES;
        _DelayList = [[NSMutableArray alloc] initWithCapacity:10];
        
        
        int currentResolution = (int)[UIDevice currentResolution];
        int modeHeight = 44;
        switch (currentResolution) {
                // iPhone 1,3,3GS 标准像素(320x480px) @1x  分辨率 320x480px
            case   UIDevice_iPhoneStandardRes:
                // iPhone 4,4S 高清像素(320x480px)  @2x 分辨率 640x960px
            case   UIDevice_iPhoneHiRes:
                break;
                
                // iPhone 5,5S 高清像素(320x568px)   @2x 分辨率 640x1136px
            case   UIDevice_iPhoneTallerHiRes:
                modeHeight = 51;
                break;
                
                //iPhone 6 高清像素(375x667px)  @2x 分辨率 750x1334px。
            case   UIDevice_iPhone6_Res:
                modeHeight = 66;
                break;
                
                //iPhone 6 Plus 高清像素(424x736px)  @3x  分辨率 1242x2208px。
            case  UIDevice_iPhonePlus:
                modeHeight = 76;
                break;
                
                // iPad 1,2   标准像素(768*1024px)  @1x  分辨率 320x480px。
            case  UIDevice_iPadStandardRes:
                // iPad 3  Retina  高清像素(768x1024px)  (@2x 分辨率 1536*2048。
            case  UIDevice_iPadHiRes:
                modeHeight = 126;
                break;
        }

        
        
        self.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:0.5];
        for(int i = 0; i < 5; i++)
        {
            ModeView *mode = [[ModeView alloc] initWithIndex:CGRectMake(0, i * modeHeight, frame.size.width, modeHeight) index:i];

            
            [mode addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventTouchUpInside];
           
            
            switch (i) {
                case 0:
                    [mode setText:NSLocalizedString(@"minute30", nil)];
                    break;
                case 1:
                    [mode setText:NSLocalizedString(@"minute60", nil)];
                    break;
                case 2:
                    [mode setText:NSLocalizedString(@"minute90", nil)];
                    break;
                case 3:
                    [mode setText:NSLocalizedString(@"minute120", nil)];
                    break;
                case 4:
                    [mode setText:NSLocalizedString(@"minute0", nil)];
                    break;
                default:
                    break;
            }
            
            mode.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            
            
            [_DelayList addObject:mode];
            [self addSubview:mode];
        }
        
        [self setDelay:5];
    }
    return self;
}

- (void) selectedMode :(ModeView*) sender
{
    for(ModeView *mode in [self subviews])
    {
        if(mode.tag == sender.tag)
            [mode clicked];
        else
            [mode unclicked];
        
    }
    
    _lastTag = (int)sender.tag;
    
    if(delayDelegate){
        
        int delayMinut = 0;
        switch ((int)sender.tag) {
            case 0:
                delayMinut = 30;
                break;
            case 1:
                delayMinut = 60;
                break;
            case 2:
                delayMinut = 90;
                break;
            case 3:
                delayMinut = 120;
                break;
            case 4:
                delayMinut = 0;
                break;
//            case 5:
//                delayMinut = 0;
//                break;
                
            default:
                break;
        }
        
        [delayDelegate SelectDelay:delayMinut];
    }
    
}

-(void) clearAllSelectMode
{
    for(ModeView *mode in [self subviews])
    {
        [mode unclicked];
    }
    
    _lastTag = -1;
    
}

-(void) setDelayEnable:(BOOL)enable
{
    
    _enable = enable;
    
    for(ModeView *view in [self subviews])
    {
        view.enable = _enable;
    }
    
}

-(void) setDelay:(int)delay
{
    _delay = delay;
    
    
    for(ModeView *mode in [self subviews])
    {
        if(mode.tag == delay)
            [mode clicked];
        else
            [mode unclicked];
        
    }
    
    _lastTag = (int)delay;
}

-(void) controlDelay:(int)delay
{
    
    switch(delay)
    {
        case 0:
            [self setDelay:4];
            break;
        case 30:
            [self setDelay:0];
            break;
        case 60:
            [self setDelay:1];
            break;
        case 90:
            [self setDelay:2];
            break;
        case 120:
            [self setDelay:3];
            break;
            
        default:
            break;
            
    }
    
    [delayDelegate SelectDelay:delay];

}

@end
