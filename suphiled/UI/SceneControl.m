//
//  Scene.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "SceneControl.h"
#import "UIDevice+Resolutions.h"


@implementation MicButton
@synthesize micing = _micing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _micing = FALSE;
//        self.backgroundColor = [UIColor redColor];
        _mic_img = [UIImage imageNamed:@"mic.png"];
        _micing_img = [UIImage imageNamed:@"micing.png"];

        [self setBackgroundImage:_mic_img forState:UIControlStateNormal];
    }
    
    return self;
}

-(void) setMicing:(BOOL)micing
{
    _micing = micing;
    
    if(_micing)
       [self setBackgroundImage:_micing_img forState:UIControlStateNormal];
    else
        [self setBackgroundImage:_mic_img forState:UIControlStateNormal];
    
}


@end

@implementation SceneControl

+ (UIColor *)colorWithARGBHex:(UInt32)hex
{
    int b = hex & 0x000000FF;
    int g = ((hex & 0x0000FF00) >> 8);
    int r = ((hex & 0x00FF0000) >> 16);
    int a = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.f];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = 0;
        
        [self createFrame];
        [self setType:_type];
    }
    
    return self;
}

- (id)initWithType:(CGRect)frame type:(int) type
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self createFrame];
        [self setType:_type];
    }
    
    return self;
}

-(void) setType:(int)type
{

    //if(_type != type)
    {
        _type = type;

        
        int currentResolution = (int)[UIDevice currentResolution];
        
        int lableLeft  = 10,lableWidth = 60,lableHeight = 25;
        int colorLeft = 70,colorTop = 10,colorWidth = self.frame.size.width - 80;
        int lightLeft = 70,lightTop = colorTop + lableHeight + 5,lightWidth = self.frame.size.width - 80;
        int openLeft = self.frame.size.width - 70,openTop = lightTop + lableHeight + 5;
        
        
        //调色
        if(_type == 1)
        {
            //_color显示，其他下移
            _color.hidden = NO;
            _colorLabel.hidden = NO;
            
            
            switch (currentResolution) {
                case UIDevice_iPhoneStandardRes:// iPhone 1,3,3GS 标准分辨率(320x480px)
                case UIDevice_iPhoneHiRes:// iPhone 4,4S 高清分辨率(640x960px)
                    break;
                case UIDevice_iPhoneTallerHiRes:// iPhone 5 高清分辨率(640x1136px)
                    lightTop =lableHeight + colorTop + 15;
                    openTop = lightTop + lableHeight + 15;
                    break;
                    
                case UIDevice_iPhone6_Res:// iPhone 5 高清分辨率(640x1136px)
                case UIDevice_iPhonePlus:// iPhone 5 高清分辨率(640x1136px)
                    lableLeft  = 15;
                    
                    lightTop =lableHeight + colorTop + 15;
                    openTop = lightTop + lableHeight + 15;
                    
                    break;
                    
                case UIDevice_iPadStandardRes:// iPad 1,2 标准分辨率(1024x768px)
                case UIDevice_iPadHiRes:// iPad 3 High Resolution(2048x1536px)
                    lableLeft = 20;
                    lableWidth = 80;
                    lableHeight = 45;
                    
                    colorLeft = lableLeft+lableWidth + 10;
                    colorWidth = self.frame.size.width - 120;
                    colorTop = 20;
                    
                    lightLeft = lableLeft+lableWidth + 10;
                    lightTop =lableHeight + colorTop + 20;
                    lightWidth = self.frame.size.width - 120;
                    
                    openTop = lightTop + lableHeight + 20;
                    openLeft = self.frame.size.width - 70;
                    break;
                default:
                    break;
            }
            _colorLabel.frame = CGRectMake(lableLeft, colorTop, lableWidth, lableHeight);
            _color.frame = CGRectMake(colorLeft, colorTop, colorWidth, lableHeight);

            

        }
        else {
            //_color不显示，其他上移
            
            _colorLabel.hidden = YES;
            _color.hidden = YES;
            
            
            switch (currentResolution) {
                case UIDevice_iPhoneStandardRes:// iPhone 1,3,3GS 标准分辨率(320x480px)
                case UIDevice_iPhoneHiRes:// iPhone 4,4S 高清分辨率(640x960px)
                    break;
                case UIDevice_iPhoneTallerHiRes:// iPhone 5 高清分辨率(640x1136px)
                    lightTop =15;
                    openTop = lightTop + lableHeight + 15;
                    break;
                    
                case UIDevice_iPhone6_Res:// iPhone 5 高清分辨率(640x1136px)
                case UIDevice_iPhonePlus:// iPhone 5 高清分辨率(640x1136px)
                    lableLeft  = 15;
                    
                    lightTop =15;
                    openTop = lightTop + lableHeight + 15;
                    
                    break;
                    
                case UIDevice_iPadStandardRes:// iPad 1,2 标准分辨率(1024x768px)
                case UIDevice_iPadHiRes:// iPad 3 High Resolution(2048x1536px)
                    lableLeft = 20;
                    lableWidth = 80;
                    lableHeight = 45;
                    
                    lightLeft = lableLeft+lableWidth + 10;
                    lightTop =20;
                    lightWidth = self.frame.size.width - 120;
                    
                    openTop = lightTop + lableHeight + 20;
                    openLeft = self.frame.size.width - 70;
                    break;
                default:
                    break;
            }
            _colorLabel.frame = CGRectZero;
            _color.frame = CGRectZero;

        }
        
        
        _lightLabel.frame = CGRectMake(lableLeft, lightTop, lableWidth, lableHeight);
        _light.frame = CGRectMake(lightLeft, lightTop, lightWidth, lableHeight);
        
        _openLabel.frame = CGRectMake(lableLeft, openTop, lableWidth*2, lableHeight);
        _speakButton.frame = CGRectMake(openLeft, openTop, 40, 40);
        
        _open.frame = CGRectMake(openLeft - 100, openTop, 100, lableHeight);

        
    }
}

-(void)createFrame
{
    
    
    int currentResolution = (int)[UIDevice currentResolution];

    int lableLeft  = 10,lableWidth = 60,lableHeight = 25;
    int colorLeft = 70,colorTop = 10,colorWidth = self.frame.size.width - 80;
    int lightLeft = 70,lightTop = colorTop + lableHeight + 5,lightWidth = self.frame.size.width - 80;
    int openLeft = self.frame.size.width - 70,openTop = lightTop + lableHeight + 5;
    int font_size = 18;
    
    switch (currentResolution) {
        case UIDevice_iPhoneStandardRes:// iPhone 1,3,3GS 标准分辨率(320x480px)
        case UIDevice_iPhoneHiRes:// iPhone 4,4S 高清分辨率(640x960px)
            font_size = 18;
            break;
        case UIDevice_iPhoneTallerHiRes:// iPhone 5 高清分辨率(640x1136px)
            font_size = 20;
            
            lightTop =lableHeight + colorTop + 15;
            openTop = lightTop + lableHeight + 15;
            break;
            
        case UIDevice_iPhone6_Res:// iPhone 5 高清分辨率(640x1136px)
        case UIDevice_iPhonePlus:// iPhone 5 高清分辨率(640x1136px)
            font_size = 22;
            lableLeft  = 15;
            
            lightTop =lableHeight + colorTop + 15;
            openTop = lightTop + lableHeight + 15;

            break;
            
        case UIDevice_iPadStandardRes:// iPad 1,2 标准分辨率(1024x768px)
        case UIDevice_iPadHiRes:// iPad 3 High Resolution(2048x1536px)
            font_size = 30;
            lableLeft = 20;
            lableWidth = 80;
            lableHeight = 45;
            
            colorTop = 20;
            colorLeft = lableLeft+lableWidth + 10;
            colorWidth = self.frame.size.width - 120;
            
            lightLeft = lableLeft+lableWidth + 10;
            lightTop =lableHeight + colorTop + 20;
            lightWidth = self.frame.size.width - 120;
            
            openTop = lightTop + lableHeight + 20;
            openLeft = self.frame.size.width - 70;
            break;
        default:
            break;
    }
    
    
    _lightcount = 0;
    _colorcount = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    //调色
    _colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(lableLeft, colorTop, lableWidth, lableHeight)];
    _colorLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:font_size];
    _colorLabel.text = NSLocalizedString(@"ColorLable", nil);
    
    _color = [[ColorSlider alloc] initWithFrame:CGRectMake(colorLeft, colorTop, colorWidth, lableHeight)];
    _color.minimumValue = 0;
    _color.maximumValue = 100;
    _color.value = 100;
    
    //滑块拖动时的事件
    [_color addTarget:self action:@selector(colorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //滑动拖动后的事件
    [_color addTarget:self action:@selector(colorDragUp:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_colorLabel];
    [self addSubview:_color];

    
    
    // 亮度
    _lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(lableLeft, lightTop, lableWidth, lableHeight)];
    _lightLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:font_size];
    _lightLabel.text = NSLocalizedString(@"BrightnessLable", nil);
    [self addSubview:_lightLabel];
    
    //滑动条
    _light = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(lightLeft, lightTop, lightWidth, lableHeight)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [_light setNumberFormatter:formatter];
    _light.font = [UIFont fontWithName:@"Arial-ItalicMT" size:font_size];
    _light.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
    [_light addTarget:self action:@selector(changeLight:) forControlEvents:UIControlEventValueChanged];

    _light.value = 1.0f;
//    _light.maximumValue = 100.0f;
//    _light.minimumValue = 0.0f;
    
    
    [self addSubview:_light];
    
    
    //开关
    _openLabel = [[UILabel alloc]initWithFrame:CGRectMake(lableLeft, openTop, lableWidth, lableHeight)];
    _openLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:font_size];
    _openLabel.text = NSLocalizedString(@"SwitchLable", nil);
    [self addSubview:_openLabel];
    
    _open = [[UISwitch alloc] initWithFrame:CGRectMake(openLeft - 100, openTop, 100, 60)];
    [_open addTarget:self action:@selector(openClicked:) forControlEvents:UIControlEventValueChanged];
    [_open setOn:YES];
    [self addSubview:_open];
    
    _speakButton = [[MicButton alloc] initWithFrame:CGRectMake(openLeft, openTop, 40, 40)];
//    [_speakButton setBackgroundImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
    [_speakButton addTarget:self action:@selector(speakClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_speakButton];

    
    //UILabel *_speakLabel;

    
}


-(void) colorValueChanged:(ColorSlider*)sender
{
    _lightcount++;
    
    
    if(_lightcount % 15)
        return;
    
    float value = sender.value;
    
    
    if(value < 0.02f)
        value = 0.02f;
    
    if(self.delegate)
        [self.delegate changeColor:value];
}


-(void)colorDragUp:(ColorSlider*)sender
{
    float value = sender.value;
#ifdef _DEBUG_LOG
    NSLog(@"light value %f",value);
#endif
    
    if(self.delegate)
        [self.delegate changeColor:value];
}


- (void)changeLight:(UISlider *)sender {
    _lightcount++;
    
    
    if(_lightcount % 15)
        return;
    
    float value = sender.value;
    
    
    if(value < 0.02f)
        value = 0.02f;
    
    if(self.delegate)
        [self.delegate changeLight:value];
}


-(void) additionLightValue
{
    
    NSLog(@"变亮 %f",_light.value);
    if(_light.value < 1.0)
        _light.value =     _light.value + 0.20;
    else
        _light.value =     1.0;
    
    if(self.delegate)
        [self.delegate changeLight:_light.value];
   
}

-(void) subtractionLightValue
{
    NSLog(@"变暗 %f",_light.value);

    if(_light.value > 0.20)
        _light.value = _light.value - 0.20;
    else
        _light.value = 0.01;
    
    if(self.delegate)
        [self.delegate changeLight:_light.value];

}
-(void) subtractionColorValue
{
    if(_color.value <94)
        _color.value = _color.value + 5;
    if(self.delegate)
        [self.delegate changeColor:_color.value];
}
-(void) additionColorValue
{
    if(_color.value > 6)
        _color.value = _color.value - 5;
    
    if(self.delegate)
        [self.delegate changeColor:_color.value];

}
-(void) controlSwitch:(int) open
{
    [self setSwitch:open];
    
    if(self.delegate)
        [self.delegate changeOpen:open];

    
}

-(void) setSwitch:(int) open
{
    if(open){
        [_open setOn:NO];
        [_light setValue:_light.minimumValue];
        [_light setEnabled:NO];
    }else{
        [_open setOn:YES];
        [_light setValue:_light.maximumValue];
        [_light setEnabled:YES];
    }
}

-(void)speakClicked:(UIButton*)sender{
    
    //如果启动了语音，就退出，否则就启动
    
    _speakButton.micing = !_speakButton.micing;
    if(self.delegate)
        [self.delegate changeSpeak];
}


-(void)openClicked:(UISwitch*)sender{
#ifdef _DEBUG_LOG
    NSLog(@"openClicked  UISwitch");
#endif
    
    BOOL isButtonOn = [sender isOn];
    
    if(isButtonOn)
    {
        [_light setEnabled:YES];
        [_light setValue:_light.maximumValue];
    } else {
        [_light setEnabled:NO];
        [_light setValue:_light.minimumValue];
    }
    
    if(self.delegate)
            [self.delegate changeOpen:!isButtonOn];
}

-(float) getColor
{
    return _color.value;
    
}

-(float) getLight
{
    return _light.value;
}

-(BOOL) getSwitch
{
    return [_open isOn];
}


-(void) setLightValue:(float) value
{
    _light.value = value;
}
-(void) setColorValue:(float) value
{
    _color.value = value;
}

-(void) controlLight:(float) value
{
    [self setLightValue:value];
    if(self.delegate)
        [self.delegate changeLight:value];
    
}

-(void) controlColor:(float) value
{
    [self setColorValue:value];
    if(self.delegate)
        [self.delegate changeColor:value];

}


- (void) selectedRating:(NSString *)scale
{
#ifdef _DEBUG_LOG
    NSLog(@"selectedRating %@",scale);
#endif
}

-(void) setMicing:(BOOL)mic
{
    _speakButton.micing = mic;
}

@end
