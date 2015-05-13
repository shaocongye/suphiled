//
//  LampCell.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "LampCell.h"
#import "UIDevice+Resolutions.h"

@implementation LampCell

@synthesize device;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createWithDeive:nil];
    }
    return self;
}

- (id)initWithDevice:(Device *)dev
{
    self = [super init];
    if (self) {
        [self createWithDeive:dev];
    }
    return self;
}

-(void)createWithDeive:(Device *)dev
{
    _device = dev;
    
    //整个显示区域 高度是Iphone下 为100 宽度为140
    //上面是标题
    if(_title)
        return;
    
    
    self.backgroundColor = [UIColor clearColor];
    int currentResolution = (int)[UIDevice currentResolution];

    int title_top = 70, title_left = 0,title_width = self.bounds.size.width;
    int button_top = 5,button_left = 9,button_width = 60,button_height = 60;
    int font_size = 20;
    
    NSLog(@"%f  %f",self.frame.size.width,self.frame.size.height);
    
    if(currentResolution >= UIDevice_iPadStandardRes)
    {
        font_size = 24;
        title_top = 110;
        title_left = 0;
        title_width = self.bounds.size.width;
        
        button_top = 5;
        button_left = 20;
        button_width = 100;
        button_height = 100;
    } else {
        
        
    }
    
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                       title_left,
                                                       title_top,
                                                       title_width,
                                                       24)];
    _title.text = @"添加";
    _title.font = [UIFont boldSystemFontOfSize:20];
    _title.textColor = [UIColor blackColor];
    _title.textAlignment = NSTextAlignmentCenter;//居中
    _title.alpha = 0.5f;
    _title.backgroundColor = [UIColor clearColor];
    [self addSubview:_title];
    
    //上面是图片
    switch(dev.type)
    {
        case 0:
            _newlineImage = [UIImage imageNamed:@"D3.png"];
            _onlineImage = [UIImage imageNamed:@"l3.png"];
            _offlineImage = [UIImage imageNamed:@"D3.png"];
            break;
        case 1:
            _newlineImage = [UIImage imageNamed:@"D2.png"];
            _onlineImage = [UIImage imageNamed:@"l2.png"];
            _offlineImage = [UIImage imageNamed:@"D2.png"];
            break;
        case 2:
            _newlineImage = [UIImage imageNamed:@"D4.png"];
            _onlineImage = [UIImage imageNamed:@"l4.png"];
            _offlineImage = [UIImage imageNamed:@"D4.png"];
            break;
        case 3:
            _newlineImage = [UIImage imageNamed:@"D1.png"];
            _onlineImage = [UIImage imageNamed:@"l1.png"];
            _offlineImage = [UIImage imageNamed:@"D1.png"];
            break;
            
        default:
            _newlineImage = [UIImage imageNamed:@"D3.png"];
            _onlineImage = [UIImage imageNamed:@"l3.png"];
            _offlineImage = [UIImage imageNamed:@"D3.png"];
            break;
    }
    
    _button = [[UIButton  alloc] initWithFrame:CGRectMake(button_left,button_top,button_width,button_height)];
    [_button setImage:_newlineImage forState:UIControlStateNormal];
    
    
    //添加点按处理
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.numberOfTapsRequired = 1;
    
    
    //添加长按处理
    UILongPressGestureRecognizer* singleLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleLongPress:)];
    singleLongPress.delegate = self;
    singleLongPress.cancelsTouchesInView = NO;
    
    [singleTap requireGestureRecognizerToFail:singleLongPress];
    [_button addGestureRecognizer:singleTap];
    [_button addGestureRecognizer:singleLongPress];
    
    [self addSubview:_button];
}

-(Device*)getDevice
{
    return _device;
}

-(void)setDevice:(Device *)dev
{
    if(dev)
    {
        _device = dev;
    
        
        switch(dev.type)
        {
            case 0:
                _newlineImage = [UIImage imageNamed:@"D1.png"];
                _onlineImage = [UIImage imageNamed:@"l1.png"];
                _offlineImage = [UIImage imageNamed:@"D1.png"];
                break;
            case 1:
                _newlineImage = [UIImage imageNamed:@"D2.png"];
                _onlineImage = [UIImage imageNamed:@"l2.png"];
                _offlineImage = [UIImage imageNamed:@"D2.png"];
                break;
            case 2:
                _newlineImage = [UIImage imageNamed:@"D4.png"];
                _onlineImage = [UIImage imageNamed:@"l4.png"];
                _offlineImage = [UIImage imageNamed:@"D4.png"];
                break;
            case 3:
                _newlineImage = [UIImage imageNamed:@"D3.png"];
                _onlineImage = [UIImage imageNamed:@"l3.png"];
                _offlineImage = [UIImage imageNamed:@"D3.png"];
                break;
                
            default:
                _newlineImage = [UIImage imageNamed:@"D3.png"];
                _onlineImage = [UIImage imageNamed:@"l3.png"];
                _offlineImage = [UIImage imageNamed:@"D3.png"];
                break;
        }
        
        
        //根据类型设定图片
        [self setTitle:dev.name];
        [self Changeonline:dev.online];
        
    }
    
}

-(void)OnButton:(UIButton *)sender
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{    
    if(self.delegate){
        [self.delegate didSelectButton:(int)self.tag];
    }
}


-(void)handleSingleLongPress:(UITapGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.delegate){
            [self.delegate didEditButton:(int)self.tag];
        }
    }
}

@end
