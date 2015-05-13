//
//  SegmentView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-4-30.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIButton
{
    UIImageView *_leftImage;
    UIImageView *_selectImage;
    UIImageView *_selectedImage;
    UILabel *_title;
    
    int _flag;
    BOOL _tick;
}

@property BOOL enable;
@property BOOL tick;
- (id) initWithIndex:(CGRect)frame index:(int) index;
- (void) clicked;
- (void) unclicked;
- (void) setText:(NSString *)text;
- (BOOL) getSelect;




@end
