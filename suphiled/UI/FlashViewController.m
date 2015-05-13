//
//  FlashViewController.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-4.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "FlashViewController.h"
#import "FlashPanel.h"

@interface FlashPanel ()


@end

@interface FlashViewController ()

@end

@implementation FlashViewController



- (id)initWithPlistName:(NSString *)plistName frame:(CGRect)frame {

    if(self = [super initWithFrame:frame])
    {
        _introduction_panel_list = nil;
        //加载配置项,动态生成导航页
        [self loadList:plistName];
        
        //Add panels to an array
        NSMutableArray *panels = [[NSMutableArray alloc] initWithCapacity:10];
        for(FlashPanel *panel in _introduction_panel_list){
            IntroductionPanel *intr = [[IntroductionPanel alloc] initWithFrame:frame title:panel.title description:panel.descript image:panel.image header:nil];
            
            [panels addObject:intr];
        }
        
        
        //创建引导页面控制器 Create the introduction view and set its delegate
        _introductionView = [[BlurIntroductionView alloc] initWithFrame:frame];
        _introductionView.delegate = self;
        _introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
        
        //构造  Build the introduction with desired panels
        [_introductionView buildIntroductionWithPanels:panels];
        
        [self addSubview:_introductionView];
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

- (NSArray *)loadList:(NSString *)plistName
{
    if (_introduction_panel_list == nil) {
        NSMutableArray *mutArray = [NSMutableArray array];
        NSString *configPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];

        NSArray *array = [[NSArray alloc] initWithContentsOfFile:configPath];
        
        int i = 0;
        for (NSDictionary *dict in array) {
            
            FlashPanel *panel = [FlashPanel panelWithDict:dict idx:i++];
            
            [mutArray addObject:panel];//[FlashPanel panelWithDict:dict idx:i++ ]];
        }
        
        _introduction_panel_list = mutArray;
    }
    
    return _introduction_panel_list;
}

-(void)introduction:(BlurIntroductionView *)introductionView didFinishWithType:(FinishType)finishType
{
    
}

-(void)introduction:(BlurIntroductionView *)introductionView didChangeToPanel:(IntroductionPanel *)panel withIndex:(NSInteger)panelIndex
{
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
}


@end
