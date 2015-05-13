//
//  NavigateBarView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-20.
//  Copyright (c) 2014年 mac book. All rights reserved.
//
#import "UIKit/UIkit.h"
#import "NavigateBarView.h"
#import "UIKit/UITapGestureRecognizer.h"

@implementation NavigateBarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0xF1/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1];
    }
    return self;
}

- (id)initWithDevice:(CGRect)frame device:(Device *)dev
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:0x4F/255.0 green:0xFF/255.0 blue:0xFF/255.0 alpha:1];
        
        //增加底色
        _backgrondImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        [_backgrondImage setImage:[UIImage imageNamed:@"title_backgraond.png"]];

        [self addSubview:_backgrondImage];
        
//        self.backgroundColor = [UIColor greenColor];
        // Initialization code
        
        //添加左边按钮
        _leftButton = [[ReturnButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        
        UITapGestureRecognizer* tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick)];
        
        [_leftButton addGestureRecognizer:tapGesturRecognizer ];
        [self addSubview:_leftButton];
        
        //添加右边按钮
//        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 0, 90, frame.size.height)];
//        [_rightButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(frame.size.width-90, 0, 80, frame.size.height);
        [_rightButton setTitle:NSLocalizedString(@"defaultLable", nil) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor clearColor];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_rightButton];
//
        //添加标题栏
        _title = [[UILabel alloc] initWithFrame:CGRectMake(100, frame.size.height/2 - 15, frame.size.width - 200, 30)];
        _title.text = @"调光";
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
//
        //先不显示
        _edit = [[UITextView alloc] initWithFrame:CGRectZero];
        
        //键盘属性
//        _edit.keyboardType = UIKeyboardTypePhonePad; //键盘风格，8种
//        _edit.keyboardAppearance = UIKeyboardAppearanceAlert; //键盘外观，两种：浅灰色或深灰色
//        _edit.returnKeyType = UIReturnKeyGo; //回车键的风格 11种
//        _edit.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大写功能 4种
//        _edit.autocorrectionType = UITextAutocorrectionTypeDefault;  //自动更正
//        _edit.secureTextEntry = YES; //安全文本输入，即输入后会显示＊号
        
        
        _edit.text = @"调光";
        _edit.delegate = self;
        [self addSubview:_edit];
    }
    
    
    return self;
}

- (void) setCaptureText:(NSString *)title
{
    _title.text = title;
    _edit.text = title;
}


-(void)leftButtonClick
{
    if(delegate)
        [delegate leftButtonClick];
    
}
-(void)rightButtonClick:(UIButton* )sender
//-(void)rightButtonClick:(UITapGestureRecognizer *)sender
{
    if(delegate)
        [delegate rightButtonClick];
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
        if(self.delegate){
            _title.text = _edit.text;
            [self.delegate editTitle:_edit.text];
            _title.frame = _edit.frame;
            _edit.frame = CGRectZero;
        }
        return NO;
    }
    return YES;
}


@end
