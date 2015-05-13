//
//  DeviceCell.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell
//@synthesize text = _text;
//@synthesize imageClose = _imageClose;
//@synthesize imageOpen = _imageOpen;
//@synthesize open = _open;
//@synthesize go = _go;
@synthesize deviceCellDeletage;
//@synthesize device = _device;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //_open = 0;
        
        //右边的折叠图片
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _expandGlyph = [[UIImageView alloc] init];
    
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _expandGlyph.frame = CGRectMake(280, 15, 15, 10);
        } else {
            _expandGlyph.frame = CGRectMake(570, 15, 15, 10);
        }
        _expandGlyph.image = [UIImage imageNamed:@"expandGlyph.png"];
		_expandGlyph.tag = 7;  //设置指示图片tag
        [self.contentView addSubview:_expandGlyph];
        
        //链接图标
        _link = [[UIImageView alloc] initWithFrame:CGRectZero];
        _linkImage = [UIImage imageNamed:@"link.png"];
        _unlinkImage = [UIImage imageNamed:@"unlink.png"];
        _link.image = _unlinkImage;
        _link.alpha = 1.0;
        [self addSubview:_link];
        
        //灯的图片
        _imageOpen = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageOpen.image=[UIImage imageNamed:@"lamp_close.png"];
        _imageOpen.frame = CGRectZero;
        _imageOpen.alpha = 1.0;
        [self addSubview:_imageOpen];
        
        _imageClose = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageClose.image=[UIImage imageNamed:@"lamp_open.png"];
        _imageClose.alpha = 1.0;
        _imageClose.frame = CGRectZero;
        [self addSubview:_imageClose];
        
        _text = [[UITextField alloc] initWithFrame:CGRectZero];
        _text.font = [UIFont boldSystemFontOfSize:20];
        _text.textColor = [UIColor purpleColor];
        _text.textAlignment = NSTextAlignmentLeft;
        _text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        _text.delegate = self;
        [self addSubview:_text];
        
        _go = [[UIButton alloc] initWithFrame: CGRectZero];
        [self addSubview:_go];
        
//        _open = [[UISwitch alloc] initWithFrame:CGRectZero];
//        [_open setOn:NO];
//        [_open addTarget:self action:@selector(clickOpenCloseButton:) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:_open];
        
//        _scene = [[SceneControl alloc] init];
//        _scene.frame = CGRectZero;
//        [self addSubview:_scene];
        
        self.backgroundColor = [UIColor whiteColor];
        //[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) OpenLamp:(int)openclose
{
    _openclose = openclose;
    
    [self layoutSubviews];
}

-(CGRect)_textFrame
{
    CGRect screen = [ UIScreen mainScreen ].bounds;
    
    int left,w;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        left = 30 + 14.0f;
        w = screen.size.width - left - 130;
        
    } else {
        left = 38 + 30.0f;
        w = screen.size.width - left - 170;
    }
    
    
    CGRect rect = CGRectMake(left,
                             6.0f,
                             w,
                             25.0f);
    
    return rect;
}

-(CGRect)_imageFrame
{
    int left = 18;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        left = 12;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
        CGRect rect = CGRectMake(left, 4.0f,
                                 30,
                                 32);
    
        return rect;
    } else {
        CGRect rect = CGRectMake(left, 5.0f,
                                 38,
                                 42);
        
        return rect;
    }

}


-(CGRect)_openFrame
{
    CGRect screen = [ UIScreen mainScreen ].bounds;
    
    int top = 8;
    int left = screen.size.width - 165;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        left = screen.size.width - 120;
    
    CGRect rect = CGRectMake(left,
                             top,
                             35,
                             22);
    
    return rect;
}

-(CGRect)_sceneFrame
{
    CGRect screen = [ UIScreen mainScreen ].bounds;
    CGRect rect = CGRectMake(5,
                             25,
                             screen.size.width-10,
                             screen.size.height-30);
    
    return rect;

}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(_openclose){
        _imageOpen.frame = [self _imageFrame];
        _imageClose.frame = CGRectZero;
    }else {
        _imageClose.frame = [self _imageFrame];
        _imageOpen.frame = CGRectZero;
    }
    
    //_image.frame = [self _imageFrame];
    _text.frame = [self _textFrame];
    _link.frame = [self _openFrame];
    
//    if(_isExpanded)
//        _scene.frame = [self _sceneFrame];
//    else
//        _scene.frame = CGRectZero;
}

- (void)clickOpenCloseButton:(id)sender{
    
    UISwitch *switchButton = (UISwitch*)sender;
    
    int off;
    if ([switchButton isOn]) {
        off = 1;//[NSNumber numberWithInt:1];
    } else {
        off = 0;//[NSNumber numberWithInt:0];
    }
    
    [self.deviceCellDeletage changeSwitch:off index:(int)self.tag];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_text resignFirstResponder];
    [self.deviceCellDeletage changeName:_text.text index:(int)self.tag];
    return YES;
}

-(void) setDevice:(Device *)device
{
    _device = device;
    _text.text = _device.name;
}
-(void) setIndex:(int)index
{
    _index = index;
}

-(void) setisExpanded:(BOOL) isExpanded
{
    _isExpanded = isExpanded;
    if(!isExpanded)
    {
        //收起来的情况
        //图片正放
		[self.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
        [[self.contentView viewWithTag:10]removeFromSuperview];
    } else {
        //展开来的情况
        //图片反放
		[self.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);

        //动态展示的界面元素,先移除，再添加
        //移除上一次的按钮对象，准备新建按钮
        [[self.contentView viewWithTag:10]removeFromSuperview];
        
        
        SceneControl *scene = [[SceneControl alloc] init];
        scene.frame = [self _sceneFrame];
        scene.tag = 10;
        scene.delegate  = self;
        [self.contentView addSubview:scene];
    }
    
    [self layoutSubviews];
}


-(void) changeLight:(float) value
{
    if(self.deviceCellDeletage)
    {
        [self.deviceCellDeletage changeLight:(int)(value * 100.0f)  index:_index];
    }
}
-(void) changeOpen:(BOOL) open
{
    if(self.deviceCellDeletage)
    {
        [self.deviceCellDeletage changeSwitch:open index:_index];
    }

}
-(void) changeMode:(int) mode
{
    if(self.deviceCellDeletage)
    {
        [self.deviceCellDeletage changeMode:mode index:_index];
    }
}


@end
