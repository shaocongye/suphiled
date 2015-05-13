//
//  ModelListView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-18.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "ModelListView.h"
#import "ModeView.h"
#import "UIDevice+Resolutions.h"

@implementation ModelListView
@synthesize viewDelegate;
@synthesize enable = _enable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lastTag = -1;
        _enable = YES;
        _ModeList = [[NSMutableArray alloc] initWithCapacity:10];

        
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
        
        
        self.backgroundColor = [UIColor colorWithRed:0x1A/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1];
        for(int i = 0; i < 5; i++)
        {
            ModeView *mode = [[ModeView alloc] initWithIndex:CGRectMake(0, i * modeHeight, frame.size.width, modeHeight) index:i];
            [mode addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventTouchUpInside];

            mode.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

            
            switch (i) {
                case 0:
                    [mode setText: NSLocalizedString(@"readmode",nil)];
                    break;
                case 1:
                    [mode setText:NSLocalizedString(@"studymode",nil)];
                    break;
                case 2:
                    [mode setText:NSLocalizedString(@"freemode",nil)];
                    break;
                case 3:
                    [mode setText:NSLocalizedString(@"gamemode",nil)];
                    break;
                case 4:
                    [mode setText:NSLocalizedString(@"nightmode",nil)];
                    break;
                default:
                    break;
            }
            
            
            [_ModeList addObject:mode];
            [self addSubview:mode];
        }
        
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
    
    if(viewDelegate)
       [viewDelegate selectMode:(int)sender.tag];
    
}

-(void) checkMode:(int)modeindex
{
    NSLog(@"checked the mode %d",modeindex);
    for(ModeView *mode in [self subviews])
    {
        if(mode.tag == (NSInteger)modeindex){
            [mode clicked];
        }
        else
            [mode unclicked];
    }
    
    _lastTag = modeindex;
}

-(void) controlMode:(int)modeindex
{
    for(ModeView *mode in [self subviews])
    {
        if(mode.tag == (NSInteger)modeindex)
            [mode clicked];
        else
            [mode unclicked];
        
    }
    
    _lastTag = modeindex;
    
    if(viewDelegate)
        [viewDelegate selectMode:modeindex];
    
}

-(void) clearAllSelectMode
{
    for(ModeView *mode in [self subviews])
    {
        [mode unclicked];
    }
    
    _lastTag = -1;

}

-(void) setModeEnable:(BOOL)enable
{

    _enable = enable;
    
    for(ModeView *view in [self subviews])
    {
        view.enable = _enable;
    }
    
}

-(int)  getMode
{
    int seg = 0;
    
    for(ModeView *mode in [self subviews])
    {
        if([mode getSelect])
        {
            if(mode.tag < 90)
            {
                seg |= 0x01 <<  mode.tag;
            }
        }
    }
    
    return seg;
}

@end
