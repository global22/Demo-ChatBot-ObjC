//
//  AppDelegate.m
//  Demo-ChatBot
//
//  Created by Imac  on 08/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:chatState];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorNamed:@"orangeHeaderColor"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorNamed:@"orangeHeaderColor"]];
    [ChatLogController sharedClass];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SideMenuController *sideMenuController = [[SideMenuController alloc] init];
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    
    UINavigationController *sideMenuNavigationController = [[UINavigationController alloc] initWithRootViewController:sideMenuController];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:sideMenuNavigationController
                                                                                      frontViewController:homeNavigationController];
    
    [revealController setDelegate:self];
    [self.window setRootViewController:revealController];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
