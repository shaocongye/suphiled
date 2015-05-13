//
//  Scene.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "RSCameraRotator.h"
#import "FGThrowSlider.h"
#import "TDRatingView.h"
#import "ColorSlider.h"


@protocol SceneControlDelegate <NSObject>
@optional

-(void) changeLight:(float) value;
-(void) changeOpen:(BOOL) open;
-(void) changeColor:(float) value;
-(void) changeSpeak;

@end

@interface MicButton : UIButton
{
    UIImage *_mic_img;
    UIImage *_micing_img;
    
    BOOL _micing;
}

@property (nonatomic) BOOL micing;
-(void) setMicing:(BOOL)micing;
@end


@interface SceneControl : UIView<TDRatingViewDelegate>
{
    UILabel *_colorLabel;
    ColorSlider *_color;
    
    ASValueTrackingSlider *_light;
    
    UILabel *_lightLabel;
    
    UISwitch *_open;
    UILabel *_openLabel;
    
    UILabel *_delayLabel;
    TDRatingView * _delayTime;
    
    unsigned int _lightcount;
    unsigned int _colorcount;
    UILabel *_speakLabel;
    MicButton *_speakButton;
    
    int _type;
    
}

//@property (assign,  nonatomic) id<DeviceCellDeletage> deviceDeletage;

@property (assign, nonatomic) id<SceneControlDelegate> delegate;

-(void) setLightValue:(float) value;
-(void) setColorValue:(float) value;
-(void) setSwitch:(int) open;
-(BOOL) getSwitch;
-(float) getColor;
-(float) getLight;
-(void) createFrame;
-(id) initWithType:(CGRect)frame type:(int) type;
-(void) setType:(int)type;


//外部操作接口
-(void) subtractionLightValue;
-(void) additionLightValue;
-(void) subtractionColorValue;
-(void) additionColorValue;
-(void) controlSwitch:(int) open;
-(void) controlLight:(float) value;
-(void) controlColor:(float) value;

-(void) setMicing:(BOOL)mic;



@end
