//
//  MainNavigateBarView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-12.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainNavigateBarViewDelegate <NSObject>

- (void) leftButtonClick;
- (void) rightButtonClick;
- (void) editTitle:(NSString *)title;

@end

@interface MainNavigateBarView : UIView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_title;
//    UILabel *_rightButton;
}

@property (weak, nonatomic) id<MainNavigateBarViewDelegate> delegate;

- (void) setCaptureText:(NSString *)title;
- (void) leftButtonClick:(UIButton* )sender;
- (void) rightButtonClick:(UIButton* )sender;

@end
