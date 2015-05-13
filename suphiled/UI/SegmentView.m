//
//  SegmentView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-4-30.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "SegmentView.h"
#import "UIDevice+Resolutions.h"

@implementation SegmentView
@synthesize enable;
@synthesize tick=_tick;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commInit:0];
        self.tag = 20;
        
    }
    return self;
}

- (id) initWithIndex:(CGRect)frame index:(int) index;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tag = index;
        
        [self commInit:index];
    }
    
    return self;
}

-(void) commInit:(int) index
{
    _tick = false;
    
    _flag = 1;
    int currentResolution = (int)[UIDevice currentResolution];
    
    
    int modeHeight = self.frame.size.height;
    int titleWidth = self.frame.size.width - 40 - modeHeight * 2;
    int imageWidth = modeHeight - 10;
    int selectWidth = modeHeight - 10;
    int imageLeft = 20;
    int title_left = imageLeft + imageWidth + 10;
    int title_top = 10;
    int title_font_size = 26;
    
    switch (currentResolution) {
        case UIDevice_iPhoneStandardRes:
            // iPhone 4,4S 高清分辨率  像素(320x480px)
        case UIDevice_iPhoneHiRes:
            title_top = modeHeight/2 - 6;
            title_font_size = 16;
            break;
            // iPhone 5 高清分辨率  像素(320x568px)
        case UIDevice_iPhoneTallerHiRes:
            title_left += 10;
            imageWidth = modeHeight - 10;
            title_top = modeHeight/2 - 8;
            title_font_size = 20;
            break;
            //iPhone6  高清分辨率  像素(375x667px)
        case UIDevice_iPhone6_Res:
            //iPhon6+  高清分辨率  像素(424x736px)
        case UIDevice_iPhonePlus:
            title_left += 20;
            imageWidth = modeHeight - 15;
            title_top = modeHeight/2 - 20;
            title_font_size = 22;
            break;
            
            // iPad 1,2 标准分辨率  像素(768x1024px)
        case UIDevice_iPadStandardRes:
            // iPad 3 High Retina  像素(768x1024px)
        case UIDevice_iPadHiRes:
            title_left += 70;
            imageWidth = modeHeight - 20;
            title_top = modeHeight/2 - 35;
            title_font_size = 30;
            selectWidth = modeHeight - 20;
            break;
        default:
            break;
    }
    
    
    //左边编号图片
    NSString *iname = @"0_button.png";
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, (modeHeight-imageWidth)/2, imageWidth, imageWidth)];
    [_leftImage setImage:[UIImage imageNamed:iname]];
    [self addSubview:_leftImage];
    
    //文字
    _title = [[UILabel alloc] initWithFrame:CGRectMake(imageLeft + imageWidth + 10, title_top, titleWidth, (self.frame.size.height-20) )];
    _title.tintColor = [UIColor colorWithRed:0x40/255.0 green:0x40/255.0 blue:0x40/255.0 alpha:1];
    _title.font = [UIFont systemFontOfSize:title_font_size];
    _title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_title];
    
    //打勾图片
    _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - selectWidth - 10, (modeHeight - selectWidth) / 2, selectWidth, selectWidth)];
    [_selectImage setImage:[UIImage imageNamed:@"select.png"]];
    [self addSubview:_selectImage];
    
    _selectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_selectedImage setImage:[UIImage imageNamed:@"selected.png"]];
    [self addSubview:_selectedImage];
    
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0x40/255, 0x40/255, 0x40/255, 0.1);//线条颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextMoveToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height-1);
    CGContextMoveToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height-1);
    CGContextStrokePath(context);
    
}


- (void) unclicked
{
    int currentResolution = (int)[UIDevice currentResolution];
    int modeHeight = self.frame.size.height;
    int selectWidth = modeHeight - 10;
    
    switch (currentResolution) {
        case UIDevice_iPhoneStandardRes:
            // iPhone 4,4S 高清分辨率  像素(320x480px)
        case UIDevice_iPhoneHiRes:
            // iPhone 5 高清分辨率  像素(320x568px)
        case UIDevice_iPhoneTallerHiRes:
            //iPhone6  高清分辨率  像素(375x667px)
        case UIDevice_iPhone6_Res:
            //iPhon6+  高清分辨率  像素(424x736px)
        case UIDevice_iPhonePlus:
            break;
            
            // iPad 1,2 标准分辨率  像素(768x1024px)
        case UIDevice_iPadStandardRes:
            // iPad 3 High Retina  像素(768x1024px)
        case UIDevice_iPadHiRes:
            selectWidth = modeHeight - 20;
            break;
            
            
        default:
            break;
    }
    
    
    _tick = NO;
    [_selectedImage setFrame:CGRectZero];
    
    if(_flag == 1)
        [_selectImage setFrame: CGRectMake(self.frame.size.width - selectWidth - 10, (modeHeight - selectWidth) / 2, selectWidth, selectWidth)];
    else
        [_selectImage setFrame: CGRectMake(self.frame.size.width - selectWidth - 10, (modeHeight - selectWidth) / 2, selectWidth, selectWidth)];
}

- (void) clicked
{
    
    int currentResolution = (int)[UIDevice currentResolution];
    int modeHeight = self.frame.size.height;
    int selectWidth = modeHeight - 10;
    
    switch (currentResolution) {
        case UIDevice_iPhoneStandardRes:
            // iPhone 4,4S 高清分辨率  像素(320x480px)
        case UIDevice_iPhoneHiRes:
            // iPhone 5 高清分辨率  像素(320x568px)
        case UIDevice_iPhoneTallerHiRes:
            //iPhone6  高清分辨率  像素(375x667px)
        case UIDevice_iPhone6_Res:
            //iPhon6+  高清分辨率  像素(424x736px)
        case UIDevice_iPhonePlus:
            break;
            
            // iPad 1,2 标准分辨率  像素(768x1024px)
        case UIDevice_iPadStandardRes:
            // iPad 3 High Retina  像素(768x1024px)
        case UIDevice_iPadHiRes:
            selectWidth = modeHeight - 20;
            break;
            
            
        default:
            break;
    }
    
    
    _tick = YES;
    
    [_selectImage setFrame:CGRectZero];
    if(_flag == 1)
        [_selectedImage setFrame: CGRectMake(self.frame.size.width - selectWidth - 10, (modeHeight - selectWidth) / 2, selectWidth, selectWidth)];
    else
        [_selectedImage setFrame: CGRectMake(self.frame.size.width - selectWidth - 10, (modeHeight - selectWidth) / 2, selectWidth, selectWidth)];
    
}


- (void) setText:(NSString *)text
{
    _title.text = text;
}

- (BOOL) getSelect
{
    return _tick;
}

@end

