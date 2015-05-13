//
//  SudokuView.h
//  LED_light_bulbs_for_network_control
//  九宫格
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuPanel.h"

@protocol SudokuViewDelegate <NSObject>

- (void) didSelectPanel:(int) index;
- (void) didEditPanel:(int) index;

@end


@interface SudokuView : UIView<SudokuPanelDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *_buttons;
    NSMutableArray *_device_list;
    
//    NSUInteger _longpress;
}

@property (nonatomic,weak) id<SudokuViewDelegate> delegate;

//- (void)setDeviceList:(NSArray *)devices;
- (Device*)getDeviceByIndex:(int)index;
- (void)setDeviceByIndex:(Device *)device index:(int)index;

- (id)initWithDevice:(NSArray *)devices frame:(CGRect)frame;
- (void)didSelectButton:(int) index;
- (void)Changeonline:(BOOL)online uuid:(NSUUID *) uuid;

- (void)addDevice:(Device *)device;
-(void) removeButtonByIndex:(int)index;
- (void)clearDevice;

@end
