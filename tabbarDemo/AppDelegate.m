//
//  AppDelegate.m
//  tabbarDemo
//
//  Created by jack on 2020/3/6.
//  Copyright © 2020 jack. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKAnimationTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ZKAnimationTabBarController *rootVC = [[ZKAnimationTabBarController alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
