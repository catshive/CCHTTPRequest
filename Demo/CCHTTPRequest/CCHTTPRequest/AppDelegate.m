//
//  AppDelegate.m
//  CCHTTPRequest
//
//  Created by Cathy's JackBook on 2/21/15.
//  Copyright (c) 2015 Cadet. All rights reserved.
//

#import "AppDelegate.h"

#import "CCHTTPRequest.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Step 1. Create the request.
    CCHTTPRequest *aRequest = [[CCHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://graph.facebook.com/zowieso"]];
    
    // Step 2. Set the completion and failure blocks.
    [aRequest setCompletionBlock:^(NSURLResponse *theResponse, NSData *theData) {
        NSError *anError;
        id aResponseJSON = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingAllowFragments error:&anError];
        if (!anError) {
            NSLog(@"%@", aResponseJSON);
        } else {
            NSLog(@"JSON Serialization failed with error: %@", anError);
        }
    } failureBlock:^(NSError *theError) {
        NSLog(@"Request failed with error: %@", theError);
    }];
    
    // Step 3. Begin the Request.
    [aRequest begin];
    
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
