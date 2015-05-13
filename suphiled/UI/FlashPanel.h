//
//  FlashPanel.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-5.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashPanel : NSObject

@property (nonatomic, copy) NSString *ntype;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descript;

@property NSInteger index;

- (instancetype)initWithDict:(NSDictionary *)dict idx:(NSInteger) index;

+ (instancetype)panelWithDict:(NSDictionary *)dict idx:(NSInteger) index;


@end
