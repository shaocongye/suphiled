//
//  MainNavigateBarView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 15-1-12.
//  Copyright (c) 2015年 mac book. All rights reserved.
//

#import "MainNavigateBarView.h"

@implementation MainNavigateBarView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //增加底色
        //添加左边按钮
        
        //添加右边按钮
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 100, 30)];
        [_rightButton setTitle:NSLocalizedString(@"refreshButton", nil) forState:UIControlStateNormal] ;
        [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize: 24.0];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:_rightButton];
        
        [self addSubview:_rightButton];
        
        //添加标题栏
    }
    return self;
}

- (void) setCaptureText:(NSString *)title
{
    _title.text = title;
}


-(void)leftButtonClick:(UIButton* )sender
{
    if(self.delegate)
        [self.delegate leftButtonClick];

}
-(void)rightButtonClick:(UIButton* )sender
{
    
    if(self.delegate)
        [self.delegate rightButtonClick];
}


/*在 method 方法里可以将 sender 看作是 btn 了
 */
-(void)zoomInAction:(id)sender {

}

@end
