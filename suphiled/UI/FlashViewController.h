//
//  FlashViewController.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-4.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroductionPanel.h"
#import "BlurIntroductionView.h"



@interface FlashViewController : UIView<IntroductionDelegate>
{
    NSMutableArray *_introduction_panel_list;
    BlurIntroductionView *_introductionView;
}

- (NSArray *)loadList:(NSString *)plistName;
- (id)initWithPlistName:(NSString *)plistName frame:(CGRect)frame;


@end
