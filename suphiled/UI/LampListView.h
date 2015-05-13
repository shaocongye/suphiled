//
//  LampListView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"
#import "KRLCollectionViewGridLayout.h"
#import "LampCell.h"

@protocol LampViewDelegate <NSObject>
- (void) didSelectLamp:(int) index;
- (void) didEditLamp:(int) index;
@end


@interface LampListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,LampViewDelegate,LampCellDelegate>
{
    NSMutableArray *_device_list;

    UICollectionView *_collectionView;
    KRLCollectionViewGridLayout *_flowLayout;
}

@property (nonatomic, weak) id<LampViewDelegate> delegate;

- (id)initWithDevice:(NSArray *)devices frame:(CGRect)frame;
- (void)addDevice:(Device *)device;
- (void)removeButtonByIndex:(int)index;
- (void)clearDevice;
- (Device*)getDeviceByIndex:(int)index;
- (void)setDeviceByIndex:(Device *)device index:(int)index;
- (void)Changeonline:(BOOL)online uuid:(NSUUID *) uuid;
- (void) didEditButton:(int) index;
- (void)removeLamp:(NSUUID *) uuid;
- (void)removeDevice:(NSString *) uuid;
@end
