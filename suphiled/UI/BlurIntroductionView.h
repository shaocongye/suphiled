//
//  MYBlurIntroductionView.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AMBlurView.h"
#import "IntroductionPanel.h"

static UIColor *kBlurTintColor = nil;
static const CGFloat kPageControlWidth = 148;
static const CGFloat kLeftRightSkipPadding = 10;
static UIFont *kSkipButtonFont = nil;

//Enum to define types of introduction finishes
typedef enum {
    FinishTypeSwipeOut = 0,
    FinishTypeSkipButton
}FinishType;

//Enum to define language direction
typedef enum {
    LanguageDirectionLeftToRight = 0,
    LanguageDirectionRightToLeft
}LanguageDirection;

@class BlurIntroductionView;

/******************************/
//Delegate Method Declarations
/******************************/
@protocol IntroductionDelegate
@optional
-(void)introduction:(BlurIntroductionView *)introductionView didFinishWithType:(FinishType)finishType;
-(void)introduction:(BlurIntroductionView *)introductionView didChangeToPanel:(IntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end

/******************************/
//MYBlurIntroductionView
/******************************/
@interface BlurIntroductionView : UIView <UIScrollViewDelegate>{
    NSArray *Panels;
    
    NSInteger LastPanelIndex;
}

/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <IntroductionDelegate> delegate;

@property (nonatomic, retain) AMBlurView *BlurView;
@property (nonatomic, retain) UIView *BackgroundColorView;
@property (retain, nonatomic) UIImageView *BackgroundImageView;
@property (retain, nonatomic) UIScrollView *MasterScrollView;
@property (retain, nonatomic) UIPageControl *PageControl;
@property (retain, nonatomic) UIButton *RightSkipButton;
@property (retain, nonatomic) UIButton *LeftSkipButton;
@property (nonatomic, assign) NSInteger CurrentPanelIndex;
@property (nonatomic, assign) LanguageDirection LanguageDirection;

//Construction Methods
-(void)buildIntroductionWithPanels:(NSArray *)panels;

//Interaction Methods
- (IBAction)didPressSkipButton;
-(void)changeToPanelAtIndex:(NSInteger)index;

//Enables or disables use of the introductionView. Use this if you want to hold someone on a panel until they have completed some task
-(void)setEnabled:(BOOL)enabled;

//Customization Methods
-(void)setBlurTintColor:(UIColor *)blurTintColor;
@end
