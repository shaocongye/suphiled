//
//  EditAlertPrompt.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-26.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlertPrompt : UIAlertView<UITableViewDelegate, UITableViewDataSource> {
@private
//	UITableView *tableView_;
	UITextField *plainTextField_;
	UITextField *secretTextField_;
}


@property(nonatomic, retain, readonly) UITextField *plainTextField;
@property(nonatomic, retain, readonly) UITextField *secretTextField;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles;

@end
