//
//  MYBlurIntroductionView.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "BlurIntroductionView.h"

@implementation BlurIntroductionView
@synthesize delegate;


-(id)initWithFrame:(CGRect)frame{
    //self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    if (self = [super initWithFrame:frame]) {
        self.MasterScrollView.delegate = self;
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

-(void)initializeViewComponents{
    //背景图片   Background Image View
    self.BackgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.BackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.BackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.BackgroundImageView];
    
    //滚动窗 Master Scroll View
    self.MasterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.MasterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    self.MasterScrollView.pagingEnabled = YES;
    self.MasterScrollView.delegate = self;
    self.MasterScrollView.showsHorizontalScrollIndicator = NO;
    self.MasterScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.MasterScrollView];
    
    //Page Control 页面滑动控制（小圆点）
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 32, kPageControlWidth, 21)];
    self.PageControl.currentPage = 0;
    [self addSubview:self.PageControl];
    
    //Get skipString dimensions  左右跳过按钮
    NSString *skipString = NSLocalizedString(@"Skip", nil);
    CGFloat skipStringWidth = 0;
    kSkipButtonFont = [UIFont systemFontOfSize:16];
    
    if ([IntroductionPanel runningiOS7]) {
        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kSkipButtonFont forKey: NSFontAttributeName];
        skipStringWidth = [skipString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.width;
        
        skipStringWidth = ceilf(skipStringWidth);
    }
    else {
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:kSkipButtonFont, NSFontAttributeName,nil];
            skipStringWidth =[skipString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size.width;
    }
    
    //Left Skip Button
    self.LeftSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftSkipButton.frame = CGRectMake(10, self.frame.size.height - 48, 46, 37);
    [self.LeftSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.LeftSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.LeftSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.LeftSkipButton];
    
    //Right Skip Button
    self.RightSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightSkipButton.frame = CGRectMake(self.frame.size.width - skipStringWidth - kLeftRightSkipPadding, self.frame.size.height - 48, skipStringWidth, 37);
    [self.RightSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.RightSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.RightSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.RightSkipButton];
}

//Public method used to build panels  构建图片页面
-(void)buildIntroductionWithPanels:(NSArray *)panels{
    Panels = panels;
    //根据数据构造图片对象
    for (IntroductionPanel *panel in Panels) {
        panel.parentIntroductionView = self;
    }
    
    //初始化背景色 Initialize Constants
    [self initializeConstants];
    
    //初始化背景框 Add the blur view to the background
    [self addBlurViewwithFrame:self.frame];
    
    //根据列表构造数据 Construct panels
    [self addPanelsToScrollView];
}

//设置颜色
-(void)initializeConstants{
    kBlurTintColor = [UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1];
}

//Adds the blur view just below the master scroll view for a blurred background look
-(void)addBlurViewwithFrame:(CGRect)frame{
    if ([IntroductionPanel runningiOS7]) {
        self.BlurView = [AMBlurView new];
        self.BlurView.alpha = 1;
        self.BlurView.blurTintColor = kBlurTintColor;
        
        [self.BlurView setFrame:CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height)];
        [self insertSubview:self.BlurView belowSubview:self.MasterScrollView];
    }
    else {
        self.BackgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height)];
        
        self.BackgroundColorView.backgroundColor = kBlurTintColor;
        [self insertSubview:self.BackgroundColorView belowSubview:self.MasterScrollView];
    }
}

//构造所有的显示页面
-(void)addPanelsToScrollView{
    if (Panels) {
        if (Panels.count > 0) {
            //Set page control number of pages
            self.PageControl.numberOfPages = Panels.count;
            
            //设置滚动方向,默认从左到右滚动  Set items specific to text direction
            if (self.LanguageDirection == LanguageDirectionLeftToRight) {
                self.LeftSkipButton.hidden = YES;
                [self buildScrollViewLeftToRight];
            }
            else {
                self.RightSkipButton.hidden = YES;
                [self buildScrollViewRightToLeft];
            }
        }
        else {
            NSLog(@"You must pass in panels for the introduction view to have content. 0 panels were found");
        }
    }
    else {
        NSLog(@"You must pass in panels for the introduction view to have content. The panels object was nil.");
    }
}

//构建左到右的滚动
-(void)buildScrollViewLeftToRight{
    CGFloat panelXOffset = 0;
    
    //一个一个构建滚动子对象
    for (IntroductionPanel *panelView in Panels) {
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.MasterScrollView addSubview:panelView];
        
        //Update panelXOffset to next view origin location
        panelXOffset += panelView.frame.size.width;
    }
    
    //[self appendCloseViewAtXIndex:&panelXOffset];

    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.height)];
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
}

//构建右到左的滚动
-(void)buildScrollViewRightToLeft{
    NSLog(@"buildScrollViewRightToLeft page has %lu",(long)Panels.count);
    CGFloat panelXOffset = self.frame.size.width * Panels.count;
    
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset + self.frame.size.width, self.frame.size.height)];
    
    //从左到右，达到最大
    for (IntroductionPanel *panelView in Panels) {
        //Update panelXOffset to next view origin location
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.MasterScrollView addSubview:panelView];
        
        panelXOffset -= panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    
    [self.MasterScrollView setContentOffset:CGPointMake(self.frame.size.width*Panels.count, 0)];
    
    self.PageControl.currentPage = Panels.count;
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollView Delegate

//开始滑动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"start scroll page %ld.",(long)self.CurrentPanelIndex);
}

//完成滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (self.LanguageDirection == LanguageDirectionLeftToRight) {
        //从左向右滑
        self.CurrentPanelIndex = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        
        //最后一页  Trigger the finish if you are at the end
        if (self.CurrentPanelIndex > ([Panels count] - 1)) {
            
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = 0;
            
            
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:FinishTypeSwipeOut];
            }
            
        }
        else {
            //换页
            //Assign the last page to be the previous current page
            LastPanelIndex = self.PageControl.currentPage;
            
            //Trigger the panel did appear method in the
            if ([Panels[LastPanelIndex] respondsToSelector:@selector(panelDidDisappear)]) {
                [Panels[LastPanelIndex] panelDidDisappear];
            }
            
            //Update Page Control
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            NSLog(@"current page = %ld",(long)self.PageControl.currentPage);
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
                
                //Trigger the panel did appear method in the
                if ([Panels[self.CurrentPanelIndex] respondsToSelector:@selector(panelDidAppear)]) {
                    [Panels[self.CurrentPanelIndex] panelDidAppear];
                }
                
                //Animate content to pop in nicely! :-)
                [self animatePanelAtIndex:self.CurrentPanelIndex];
            }
        }
    }
    else if(self.LanguageDirection == LanguageDirectionRightToLeft){
        //从右向左滑
        self.CurrentPanelIndex = (scrollView.contentOffset.x-self.frame.size.width)/self.MasterScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == -1) {
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:FinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[Panels.count-1 - self.CurrentPanelIndex] withIndex:Panels.count-1 - self.CurrentPanelIndex];
                }
                //Trigger the panel did appear method in the
                if ([Panels[Panels.count-1 - self.CurrentPanelIndex] respondsToSelector:@selector(panelDidAppear)]) {
                    [Panels[Panels.count-1 - self.CurrentPanelIndex] panelDidAppear];
                }
                
                //Animate content to pop in nicely! :-)
                [self animatePanelAtIndex:Panels.count-1 - self.CurrentPanelIndex];
            }
        }
    }
}

//滑动事件，到头了要怎么处理   This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.LanguageDirection == LanguageDirectionLeftToRight) {
        if (self.CurrentPanelIndex == (Panels.count - 1)) {
        }
    }
    else if (self.LanguageDirection == LanguageDirectionRightToLeft){
        if (self.CurrentPanelIndex == 0) {
        }
    }
}



#pragma mark - Helper Methods
//动画   Show the information at the given panel with animations
-(void)animatePanelAtIndex:(NSInteger)index{
    //If it is a custom panel, skip stock animation
    
//    NSLog(@"animate panel index %d",index);
    //Hide all labels
    for (IntroductionPanel *panelView in Panels) {
        panelView.PanelTitleLabel.alpha = 0;
        panelView.PanelDescriptionLabel.alpha = 0;
        panelView.PanelSeparatorLine.alpha = 0;
        if (panelView.PanelHeaderView) {
            panelView.PanelHeaderView.alpha = 0;
        }
        panelView.PanelImageView.alpha = 0;
    }
    
    if ([Panels[index] isCustomPanel] && ![Panels[index] hasCustomAnimation]) {
        return;
    }
    
    //Animate
    if (Panels.count > index) {
        //Get initial frames
        CGRect initialHeaderFrame = CGRectZero;
        if ([Panels[index] PanelHeaderView]) {
            initialHeaderFrame = [Panels[index] PanelHeaderView].frame;
        }
        CGRect initialTitleFrame = [Panels[index] PanelTitleLabel].frame;
        CGRect initialDescriptionFrame = [Panels[index] PanelDescriptionLabel].frame;
        CGRect initialImageFrame = [Panels[index] PanelImageView].frame;
        
        //Offset frames
        [[Panels[index] PanelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
        [[Panels[index] PanelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
        [[Panels[index] PanelHeaderView] setFrame:CGRectMake(initialHeaderFrame.origin.x, initialHeaderFrame.origin.y - 10, initialHeaderFrame.size.width, initialHeaderFrame.size.height)];
        [[Panels[index] PanelImageView] setFrame:CGRectMake(initialImageFrame.origin.x, initialImageFrame.origin.y + 10, initialImageFrame.size.width, initialImageFrame.size.height)];
        
        //Animate title and header
        [UIView animateWithDuration:0.3 animations:^{
            [[Panels[index] PanelTitleLabel] setAlpha:1];
            [[Panels[index] PanelTitleLabel] setFrame:initialTitleFrame];
            [[Panels[index] PanelSeparatorLine] setAlpha:1];
            
            if ([Panels[index] PanelHeaderView]) {
                [[Panels[index] PanelHeaderView] setAlpha:1];
                [[Panels[index] PanelHeaderView] setFrame:initialHeaderFrame];
            }
        } completion:^(BOOL finished) {
            //Animate description
            [UIView animateWithDuration:0.3 animations:^{
                [[Panels[index] PanelDescriptionLabel] setAlpha:1];
                [[Panels[index] PanelDescriptionLabel] setFrame:initialDescriptionFrame];
                [[Panels[index] PanelImageView] setAlpha:1];
                [[Panels[index] PanelImageView] setFrame:initialImageFrame];
            }];
        }];
    }
}
//加上最后一个页面，这个页面没有显示了
-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.MasterScrollView addSubview:closeView];
    
    *xIndex += self.MasterScrollView.frame.size.width;
}

#pragma mark - Interaction Methods

- (void)didPressSkipButton {
    [self skipIntroduction];
}

-(void)skipIntroduction{
    if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
        [delegate introduction:self didFinishWithType:FinishTypeSkipButton];
    }
    
    [self hideWithFadeOutDuration:0.3];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}

-(void)changeToPanelAtIndex:(NSInteger)index{
    NSLog(@" change index %ld",(long)index);
}

-(void)setEnabled:(BOOL)enabled{
    [UIView animateWithDuration:0.3 animations:^{
        if (enabled) {
            if (self.LanguageDirection == LanguageDirectionLeftToRight) {
                self.LeftSkipButton.alpha = !enabled;
                self.RightSkipButton.alpha = enabled;
            }
            else if (self.LanguageDirection == LanguageDirectionRightToLeft){
                self.LeftSkipButton.alpha = enabled;
                self.RightSkipButton.alpha = !enabled;
            }
            
            self.MasterScrollView.scrollEnabled = YES;
        }
        else {
            self.LeftSkipButton.alpha = enabled;
            self.RightSkipButton.alpha = enabled;
            self.MasterScrollView.scrollEnabled = NO;
        }
    }];
}

#pragma mark - Customization Methods

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    if (self.BackgroundColorView) {
        self.BackgroundColorView.backgroundColor = backgroundColor;
    }
    else if (self.BlurView){
        self.BlurView.blurTintColor = backgroundColor;
    }
}

-(void)setBlurTintColor:(UIColor *)blurTintColor
{
    
}

@end
