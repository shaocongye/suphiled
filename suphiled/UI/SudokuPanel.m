//
//  SudokuPanel.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "SudokuPanel.h"

@implementation SudokuPanel
@synthesize sudoku = _sudoku;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _newlineImage = [UIImage imageNamed:@"D1.png"];

    }
    return self;
}

-(id) initWithAdd:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //整个显示区域 高度是Iphone下 为100 宽度为140
        //上面是标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           10,
                                                           90,
                                                           frame.size.width - 40,
                                                           24)];
        _title.text = @"添加";
        _title.font = [UIFont boldSystemFontOfSize:20];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.alpha = 0.5f;
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        
        //上面是图片
        _newlineImage = [UIImage imageNamed:@"D1.png"];
        _onlineImage = [UIImage imageNamed:@"D1.png"];
        _offlineImage = [UIImage imageNamed:@"D1.png"];

        
        _button = [[UIButton  alloc] initWithFrame:CGRectMake(frame.size.width/2 - 45, 10, 70, 70)];
        [_button setImage:_newlineImage forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_button];
    }
    
    return self;
}

-(id) initWithDevice:(CGRect)frame panel:(Device*)device
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _sudoku = device;
        
        //整个显示区域 高度是Iphone下 为100 宽度为140
        //上面是标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           10,
                                                           90,
                                                           frame.size.width - 40,
                                                           24)];
        _title.text = device.name;
        _title.font = [UIFont boldSystemFontOfSize:20];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.alpha = 0.5f;
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        
        //上面是图片
        _button = [[UIButton  alloc] initWithFrame:CGRectMake(frame.size.width/2 - 45, 10, 70, 70)];
        switch (device.type) {
            case 0:
                _onlineImage = [UIImage imageNamed:@"l3.png"];
                _offlineImage = [UIImage imageNamed:@"D3.png"];
                break;
            case 1:
                _onlineImage = [UIImage imageNamed:@"l2.png"];
                _offlineImage = [UIImage imageNamed:@"D2.png"];
                break;
            case 2:
                _onlineImage = [UIImage imageNamed:@"l4.png"];
                _offlineImage = [UIImage imageNamed:@"D4.png"];
                break;
            case 3:
                _onlineImage = [UIImage imageNamed:@"l1.png"];
                _offlineImage = [UIImage imageNamed:@"D1.png"];
                break;
                
            default:
                break;
        }
        
        [_button setImage:_offlineImage forState:UIControlStateNormal];

//        [_button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    
    return self;
}
- (void)OnButton:(UIButton *)sender
{
    if(self.delegate)
    {
       [self.delegate didSelectButton:(int)self.tag];
    }
}

-(void)Changeonline:(BOOL)online
{
    if(online)
    {
        [_button setImage:_onlineImage forState:UIControlStateNormal];
    } else {
        [_button setImage:_offlineImage forState:UIControlStateNormal];
    }
    
    
}

-(void)setTitle:(NSString*)title
{
    _title.text = title;
}


@end
