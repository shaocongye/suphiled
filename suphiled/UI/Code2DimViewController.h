//
//  Code2DimViewController.h
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-16.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol Code2DimDelegate <NSObject>

@optional 
-(void)createNewDevice:(NSString *)mac ssid:(NSString *)ssid pasword:(NSString *)pwd url:(NSString *)url;

@end

@interface Code2DimViewController : UIViewController<ZBarReaderDelegate,ZBarReaderViewDelegate>
{
//    UIButton *_scanButton;
    ZBarReaderView *_readerView;
    UILabel *_readerText;
    NSString *_macstr;
    NSString *_ssidstr;
    NSString *_passwordstr;
    NSString *_urlstr;

}

@property (strong, nonatomic)  ZBarReaderView *readerView;
//@property (nonatomic, retain)  UIButton *scanButton;
@property (nonatomic, retain) UILabel *readerText;
@property (nonatomic,strong) id<Code2DimDelegate> code2DimDelegate;

//@property (nonatomic,strong) NSString *ssidstr;
//@property (nonatomic,strong) NSString *passwordstr;
//@property (nonatomic,strong) NSString *urlstr;


@end
