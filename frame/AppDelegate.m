//
//  AppDelegate.m
//  frame
//
//  Created by Kjell Olsen on 4/23/14.
//  Copyright (c) 2014 Minneapolis Institute of Arts. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [self updateBatteryStatus];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBatteryStatus) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBatteryStatus) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self updateBatteryStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateBatteryStatus
{
    NSString *urlWithParams = [NSString stringWithFormat:
                               @"http://clog.local:2345/battery/%d/%0.0f",
                               [[UIDevice currentDevice] batteryState],
                               [[UIDevice currentDevice] batteryLevel] * 100];

    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlWithParams]];
    [req setHTTPMethod: @"POST"];
    
    [NSURLConnection
        sendAsynchronousRequest:req
        queue:[[NSOperationQueue alloc] init]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            NSLog(@"%@", response);
        }
    ];
}

@end
