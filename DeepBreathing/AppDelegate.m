//
//  AppDelegate.m
//  DeepBreathing
//
//  Created by DreamHack on 15-7-15.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "DHDrawerViewController.h"
#import "MainTabViewController.h"
#import "LeftViewController.h"


NSString * const kUserIdKey = @"kUserIdKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey]) {
        
        // 各个模块controller的类名
        NSArray * controllerClassNames = @[@"HomePageViewController",@"AssessmentViewController",@"MedicineViewController",@"KnowledgeViewController",@"AttendanceViewController"];
        
        // 传给tabController的controller数组
        NSMutableArray * controllerArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString * className in controllerClassNames) {
            // 通过类名初始化controller
            UIViewController * controller = [[NSClassFromString(className) alloc] init];
            [controllerArray addObject:controller];
            
        }
        
        // 初始化tabController
        MainTabViewController * mainViewController = [[MainTabViewController alloc] initWithViewControllers:controllerArray];
        
        
        // 初始化抽屉controller
        // 因为某一个子controller push的效果是把整个tabController进行push，所以要把tabController作为一个navigationController的rootController
        DHDrawerViewController * drawerViewController = [[DHDrawerViewController alloc] initWithMainViewContorller:[[UINavigationController alloc] initWithRootViewController:mainViewController] leftViewController:[[LeftViewController alloc] init] rightViewController:nil];
        
        
        // 因为抽屉controller的按钮点击事件push controller的效果是对整个tabController进行push
        // 所以把抽屉controller作为navigationController的rootController
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:drawerViewController];
    }
    
    [self.window makeKeyAndVisible];
    
#warning 注册推送
    return YES;
}

- (UIWindow *)window
{
    if (!_window) {
        _window = ({
            
            UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            window;
            
        });
    }
    
    return _window;
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
