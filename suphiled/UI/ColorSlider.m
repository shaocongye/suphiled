//
//  ColorSlider.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-11-12.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "ColorSlider.h"

@implementation ColorSlider




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _stetchLeftTrack= [UIImage imageNamed:@"colorbar.jpg"];
        _stetchRightTrack = [UIImage imageNamed:@"colorbar.jpg"];
        //滑块图片
        UIImage *thumb = [UIImage imageNamed:@"open_button.png"];

        CGSize reSize = CGSizeMake(32.0, 32.0);
        _thumbImage = [self OriginImage:thumb scaleToSize:reSize];
        
        self.backgroundColor = [UIColor clearColor];
        self.value=1.0;
        self.minimumValue=0.7;
        self.maximumValue=1.0;

        
        [self setMinimumTrackImage:_stetchLeftTrack forState:UIControlStateNormal];
        [self setMaximumTrackImage:_stetchRightTrack forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [self setThumbImage:_thumbImage forState:UIControlStateHighlighted];
        [self setThumbImage:_thumbImage forState:UIControlStateNormal];
        
        //滑块拖动时的事件
//        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        //滑动拖动后的事件
//        [self addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size
{
	// 创建一个bitmap的context
	// 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContext(size);
	
	// 绘制改变大小的图片
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// 从当前context中创建一个改变大小后的图片
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	
	// 返回新的改变大小后的图片
	return scaledImage;
}

-(void)sliderValueChanged
{
    
}


-(void)sliderDragUp
{
    
}


@end
