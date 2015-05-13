//
//  ReturnButton.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "ReturnButton.h"

@implementation ReturnButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.height - 30) /2, (frame.size.height - 30)/2, 30, 30)];
        _image.image = [UIImage imageNamed:@"return.png"];
        
        [self addSubview:_image];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
