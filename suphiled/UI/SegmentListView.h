//
//  SegmentListView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-3-23.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentListViewDelegate <NSObject>

-(void)selectSegment:(int) seg;

@end

@interface SegmentListView : UIView
{
    NSMutableArray *_SegList;
    int _lastTag;
    int _segment;
    BOOL _enable;
}

@property (weak, nonatomic) id<SegmentListViewDelegate> viewDelegate;
@property BOOL enable;

-(void) setSegEnable:(BOOL)enable;
-(void) setSegment:(int)segment;
-(void) controlSeg:(int)mode;
-(void) clearAllSelectSeg;
-(int)  getSegment;

@end
