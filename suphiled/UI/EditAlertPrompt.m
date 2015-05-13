//
//  EditAlertPrompt.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-26.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "EditAlertPrompt.h"
#import <QuartzCore/QuartzCore.h>

@interface EditAlertPrompt ()
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UITextField *plainTextField;
@property(nonatomic, retain) UITextField *secretTextField;
- (void)orientationDidChange:(NSNotification *)notification;
@end


@implementation EditAlertPrompt
@synthesize tableView = tableView_;
@synthesize plainTextField = plainTextField_;
@synthesize secretTextField = secretTextField_;


- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles {
    
	if ((self = [super initWithTitle:title
                             message:@"wweewrew" delegate:delegate
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles, nil])) {
        
		// FIXME: This is a workaround. By uncomment below, UITextFields in tableview will show characters when typing (possible keyboard reponder issue).
		

        
        
        plainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 160, 28)];
		plainTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		plainTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        [plainTextField_ setBackgroundColor:[UIColor whiteColor]];
		plainTextField_.placeholder = @"Nickname or Email";
        [self addSubview:plainTextField_ ];

        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	}
	return self;
}


#pragma mark layout

- (void)layoutSubviews {
	// We assume keyboard is on.
	if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
		if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
			self.center = CGPointMake(160.0f, (460.0f - 216.0f)/2 + 12.0f);
			self.tableView.frame = CGRectMake(12.0f, 51.0f, 260.0f, 56.0f);
		} else {
			self.center = CGPointMake(240.0f, (300.0f - 162.0f)/2 + 12.0f);
			self.tableView.frame = CGRectMake(12.0f, 35.0f, 260.0f, 56.0f);
		}
	}
}

- (void)orientationDidChange:(NSNotification *)notification {
	[self setNeedsLayout];
}

#pragma mark Accessors

- (UITextField *)plainTextField {
    
	if (!plainTextField_) {
		plainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		plainTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		plainTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		plainTextField_.placeholder = @"Nickname or Email";
        [self addSubview:plainTextField_ ];
	}
	return plainTextField_;
}

- (UITextField *)secretTextField {
	
	if (!secretTextField_) {
		secretTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		secretTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		secretTextField_.secureTextEntry = YES;
		secretTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		secretTextField_.placeholder = @"Password";
	}
	return secretTextField_;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *AlertPromptCellIdentifier = @"DDAlertPromptCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:AlertPromptCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlertPromptCellIdentifier];
    }
	
	if (![cell.contentView.subviews count]) {
		if (indexPath.row) {
			[cell.contentView addSubview:self.secretTextField];
		} else {
			[cell.contentView addSubview:self.plainTextField];
		}
	}
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

@end



