//
//  SceneControlView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-6.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneControl.h"
#import "ModelListView.h"
#import "BLENetworkControl.h"
#import "NavigateBarView.h"
#import "DelaylListView.h"
#import "SegmentListView.h"

//#import <Slt/Slt.h>
//@class PocketsphinxController;
//@class FliteController;

#import <OpenEars/OEEventsObserver.h>

//#import <OpenEars/OEEventsObserver.h>
//#import <OpenEars/OEFliteController.h>
//#import <OpenEars/OELanguageModelGenerator.h>

@interface SegmentData : NSObject
{
    int _light;
    int _one;
    int _two;
    int _three;
    int _four;
    int _five;
}

@property int light;
@property int one;
@property int two;
@property int three;
@property int four;
@property int five;

-(id)initWithName:(int) light oneseg :(int) one twoseg :(int) two threeseh :(int) three fourseg :(int) four fiveseg :(int) five;
@end

@interface  SettingData : NSObject
{
    int _type;
    int _light;
    int _color;
    int _seg;
    
}

@property int type;
@property int light;
@property int color;
@property int seg;

-(id)initWithName:(int) type light:(int)light color:(int)color segment:(int) seg;

@end

@protocol SceneControlViewDelegate <NSObject>

-(void) changeLight:(float) value;
-(void) changeSwitch:(BOOL) open;
-(void) changeMode:(int) mode;
-(void) changeDelay:(int) delay;
-(void) changeColor:(float) value;
-(void) readStatus;

-(void) changeSegment:(int)light oneseg:(int)one twoseg:(int)two threeseh:(int)three fourseg:(int)four fiveseg:(int)five;
-(void) saveSetting:(int) type light:(int)light color:(int)color segment:(int) seg;

-(void) retuenMainView;

@end

@interface SceneControlView : UIViewController<SceneControlDelegate,ModelListViewDelegate,SegmentListViewDelegate, DelaylListViewDelegate,NavigateBarViewDelegate,UIAlertViewDelegate,OEEventsObserverDelegate>
{
    ModelListView *_modes;
    SegmentListView *_segments;
    DelaylListView *_delaies;
    SceneControl *_control;
    UILabel *_titleModel;
    UILabel *_titleDelay;
    UILabel *_titleControl;
    BLENetworkControl *_ble;
    
    NavigateBarView *_navigateBar;
    
    Device *_device;
    
    BOOL _closed;
    BOOL _listing;
    BOOL _SaveOK;
    NSOperationQueue *_ResultcheckQuenue;
    
}


@property (retain,nonatomic) id<SceneControlViewDelegate> delegate;

- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble;
- (void)clickReturnButton :(id)sender;
- (void)setCapture:(NSString*)capture;
- (void)SelectDelay:(int)delay;

//- (void) ClickReturn :(UIBarButtonItem *) sender;
- (void)setBLENetwork:(BLENetworkControl*)_ble;
- (void)setDevice:(Device *)device;
- (void)leftButtonClick;
- (void)rightButtonClick;
- (void)editTitle:(NSString *)title;

- (void)dismissLightDevice:(NSNumber *)_light;
- (void)dismissOpenDevice:(NSNumber*)_open;
- (void)dismissModeDevice:(NSNumber *)_mode;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertViewCancel:(UIAlertView *)alertView;

- (void)delayViewClick;
- (void)selectViewClick;

- (void)setStatus:(PResultData) status;
- (void)saveOK;

- (void)disconnectBLE:(NSUUID*)uuid;

- (BOOL)isCurrentViewControllerVisible;

@end
