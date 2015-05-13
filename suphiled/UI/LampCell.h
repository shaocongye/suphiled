//
//  LampCell.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"


@protocol LampCellDelegate <NSObject>

- (void) didSelectButton:(int) index;
- (void) didEditButton:(int) index;

@end



@interface LampCell : UICollectionViewCell<UIGestureRecognizerDelegate>
{
    
    UILabel *_title;
    UIButton *_button;
    Device *_device;
    
    UIImage *_onlineImage;
    UIImage *_offlineImage;
    UIImage *_newlineImage;

}

@property (nonatomic, retain) id<LampCellDelegate> delegate;
@property (nonatomic, retain) Device *device;

-(id)initWithDevice:(Device *)dev;
-(void)createWithDeive:(Device *)dev;
-(void)OnButton:(UIButton *)sender;
-(void)Changeonline:(BOOL)online;
-(void)setTitle:(NSString*)title;
-(void)setDevice:(Device *)device;
-(Device*)getDevice;


@end
