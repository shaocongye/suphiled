//
//  DelaylListView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-11-2.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DelaylListViewDelegate <NSObject>

-(void)SelectDelay:(int)delay;


@end
@interface DelaylListView : UIView
{
    NSMutableArray *_DelayList;
    int _lastTag;
    BOOL _enable;
    int _delay;
}


@property (weak, nonatomic) id<DelaylListViewDelegate> delayDelegate;
@property BOOL enable;
-(void) setDelayEnable:(BOOL)enable;

-(void) setDelay:(int)delay;
-(void) controlDelay:(int)delay;


@end
