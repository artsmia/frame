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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self updateBatteryStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
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
        }
    ];
}

@end
