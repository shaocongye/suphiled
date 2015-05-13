//
//  SudokuPanel.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"

@protocol SudokuPanelDelegate <NSObject>

- (void) didSelectButton:(int) index;

@end

@interface SudokuPanel : UIView
{
    UILabel *_title;
    UIButton *_button;
    Device *_sudoku;
    
    UIImage *_onlineImage;
    UIImage *_offlineImage;
    UIImage *_newlineImage;
    
}

@property (nonatomic, retain) id<SudokuPanelDelegate> delegate;
@property (nonatomic, retain) Device *sudoku;

-(id) initWithAdd:(CGRect)frame;
-(id) initWithDevice:(CGRect)frame panel:(Device*)device;
-(void)OnButton:(UIButton *)sender;
-(void)Changeonline:(BOOL)online;
-(void)setTitle:(NSString*)title;


@end
