//
//  DeviceCell.h
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMode.h"
#import "SceneControl.h"

@protocol DeviceCellDeletage <NSObject>

@required

@optional

- (void)changeSwitch:(int)_switch index : (int) tag;
- (void)changeName:(NSString *)_name index :(int) tag ;
- (void)changeLight:(int)_light index:(int) tag;
- (void)changeMode:(int)mode index:(int) tag;
@end


@interface DeviceCell : UITableViewCell<UITextFieldDelegate,SceneControlDelegate>
{
    UIImageView *_imageClose;
    UIImageView *_imageOpen;
    UIImageView *_expandGlyph;
    
    UITextField *_text;
    //UISwitch *_open;
    UIButton *_go;
    UIImageView *_link;
    UIImage *_linkImage;
    UIImage *_unlinkImage;
    Device *_device;
    
    int _index;
    int _openclose;
    BOOL _isExpanded;
}

@property (nonatomic, strong) id<DeviceCellDeletage> deviceCellDeletage;

-(void) OpenLamp:(int)openclose;
-(void) setDevice:(Device *)device;
-(void) setIndex:(int)index;
-(void) setisExpanded:(BOOL) isExpanded;

@end
