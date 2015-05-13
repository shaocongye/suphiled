//
//  ModelListView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-18.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModelListViewDelegate <NSObject>

-(void)selectMode:(int) mode;


@end

@interface ModelListView : UIView
{
    NSMutableArray *_ModeList;
    int _lastTag;
    BOOL _enable;
}

@property (weak, nonatomic) id<ModelListViewDelegate> viewDelegate;
@property BOOL enable;

-(void) setModeEnable:(BOOL)enable;
-(void) checkMode:(int)mode;
-(void) controlMode:(int)mode;
-(void) clearAllSelectMode;
-(int)  getMode;

@end
