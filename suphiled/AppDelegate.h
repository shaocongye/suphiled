//
//  AppDelegate.h
//  SuphiLED_control
//
//  Created by mac book on 14-9-2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DataModuleControl.h"
#import "BLENetworkControl.h"
#import "ASIHTTPRequestDelegate.h"

#define registerURL @"http://www.jinslight.com:8080/LightServer/register"


@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>
{
    DataModuleControl *_config;
    
    UIImageView  *_SplashImage;
    UIView *_SplashView;
    
    int _stop;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) BLENetworkControl *BLENetworkControl;
@property (strong, nonatomic) DataModuleControl *config;

- (float)getIOSVersion;
- (void)savedUUID:(NSString *)uuid;

- (void)saveContext;
- (NSString *)fetchUUID;

- (NSURL *)applicationDocumentsDirectory;

-(void)reachabilityChanged:(NSNotification*)note;

- (id)getCurNavController;
@end
