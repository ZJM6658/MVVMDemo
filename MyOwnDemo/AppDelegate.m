//
//  AppDelegate.m
//  MyOwnDemo
//
//  Created by zhujiamin on 16/5/13.
//  Copyright © 2016年 zhujiamin@yaomaitong.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "JobListViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    JobListViewController *jobLVC = [[JobListViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:jobLVC];
    self.window.rootViewController = naVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
