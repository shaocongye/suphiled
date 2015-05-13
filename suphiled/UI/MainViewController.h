//
//  MainViewController.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-3.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"
#import "DeviceTableView.h"
#import "SudokuView.h"
#import "DeviceCell.h"
#import "QRcodeViewController.h"
#import "FlashViewController.h"
#import "BLENetworkControl.h"
#import "SceneControlView.h"
#import "LampListView.h"
#import "MainNavigateBarView.h"
#import "SceneControlView.h"

@interface MainViewController : UIViewController<QRcodeViewControllerDelegate,SudokuViewDelegate,BLENetworkControlDelegate,SceneControlViewDelegate,UIAlertViewDelegate,LampViewDelegate,MainNavigateBarViewDelegate>
{
    DeviceProperty *_config;
    FlashViewController *_flashs;
    LampListView *_lamps;
    UITextField *_nameedit;

    SceneControlView *_sceneView;
    NSOperationQueue *_GetModeulInfoQuenue;
}


-(void) setConfig:(DeviceProperty*) cfg;
-(void) didSelectPanel:(int) index;
-(void) scanQRcodedidFinish:(NSString*)url;
-(void) dismissAlertShowSceneControl:(Device*)dev;
-(void) dismissAlertShowMessage:(NSString*)text;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertViewCancel:(UIAlertView *)alertView;


@end
