//
//  ModeView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-18.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModeView : UIButton
{
    UIImageView *_leftImage;
    UIImageView *_selectImage;
    UIImageView *_selectedImage;
    UILabel *_title;

    int _flag;
    BOOL _selected;
}

@property BOOL enable;

- (id) initWithIndex:(CGRect)frame index:(int) index;
- (void) clicked;
- (void) unclicked;
- (void) setText:(NSString *)text;
- (BOOL) getSelect;


@end
