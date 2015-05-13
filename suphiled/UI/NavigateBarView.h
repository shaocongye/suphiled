//
//  NavigateBarView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-20.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"
#import "ReturnButton.h"
@protocol NavigateBarViewDelegate <NSObject>

- (void) leftButtonClick;
- (void) rightButtonClick;
- (void) editTitle:(NSString *)title;

@end


@interface NavigateBarView : UIView<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *_backgrondImage;
    ReturnButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_title;
    UILabel *_save;
    UITextView *_edit;
}

@property (weak, nonatomic) id<NavigateBarViewDelegate> delegate;

- (void) setCaptureText:(NSString *)title;
- (id)initWithDevice:(CGRect)frame device:(Device *)dev;
- (void)leftButtonClick;

@end
