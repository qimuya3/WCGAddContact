//
//  AppDelegate.m
//  WCGAddContact
//
//  Created by wuchungang on 16/3/25.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import "AppDelegate.h"
#import "AddContactVC.h"        //通讯录添加联系人
#import "CreatCodeVC.h"         //原生二维码条形码生成
#import "ScanCodeRootVC.h"      //原生二维码扫描
#import "MotionVC.h"            //摇一摇
#import "AccelerometerVC.h"     //重力感应

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    AddContactVC *addVC = [[AddContactVC alloc]init];
    addVC.title = @"添加联系人";
    UINavigationController *addNav = [[UINavigationController alloc]initWithRootViewController:addVC];
    
    CreatCodeVC *codeVC = [[CreatCodeVC alloc]init];
    codeVC.title = @"原生二维码条形码";
    UINavigationController *codeNav = [[UINavigationController alloc]initWithRootViewController:codeVC];
    
    ScanCodeRootVC *scanCodeVC = [[ScanCodeRootVC alloc]init];
    scanCodeVC.title = @"原生二维码扫描";
    UINavigationController *scanCodeNav = [[UINavigationController alloc]initWithRootViewController:scanCodeVC];
    
    MotionVC *mVC = [[MotionVC alloc]init];
    mVC.title = @"摇一摇";
    UINavigationController *mNav = [[UINavigationController alloc]initWithRootViewController:mVC];
    
    AccelerometerVC *aVC = [[AccelerometerVC alloc]init];
    aVC.title = @"重力感应";
    UINavigationController *aNav = [[UINavigationController alloc]initWithRootViewController:aVC];
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = @[addNav,codeNav,scanCodeNav,mNav,aNav];
    self.window.rootViewController = tabBar;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
