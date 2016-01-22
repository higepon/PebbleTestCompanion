//
//  AppDelegate.m
//  PebbleTestCompanion
//
//  Created by Taro Minowa on 1/7/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

@import PebbleKit;
#import "AppDelegate.h"
#import "Predictor.h"
#define MESSAGE_KEY_ACCEL_DATA @(0)
#define MESSAGE_KEY_PREDICTION @(1)

@interface AppDelegate () <PBPebbleCentralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.


    [PBPebbleCentral defaultCentral].delegate = self;
    // Set UUID of watchapp
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"e4016b18-9d23-478a-bd8c-29e2d40db02b"];
    [PBPebbleCentral defaultCentral].appUUID = myAppUUID;
    [[PBPebbleCentral defaultCentral] run];

    for (PBWatch *watch in [PBPebbleCentral defaultCentral].connectedWatches) {
        [self _setupHandlersWithWatch:watch];
    }
    return YES;
}

- (void)_setupHandlersWithWatch:(PBWatch *)connectedWatch
{
    [self sendMessageTest:connectedWatch];
    [connectedWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        [self _messageRecieved:watch data:update];
        return YES;
    }];
}

#define endian_swap(num) (((num>>24)&0xff) |((num<<8)&0xff0000) | ((num>>8)&0xff00) | ((num<<24)&0xff000000))

- (void)_messageRecieved:(PBWatch *)watch data:(NSDictionary *)dic
{
    NSData *data = [dic objectForKey:MESSAGE_KEY_ACCEL_DATA];
    NSLog(@"Received message: %@", data);
    const uint32_t* x = (const uint32_t*)data.bytes;

    NSArray *prediction = [Predictor predict:x];
    NSLog(@"%@", prediction);
    NSUInteger predictionIndex = ([prediction[0] floatValue] > [prediction[1] floatValue]) ? (([prediction[0] floatValue] > [prediction[2] floatValue]) ? 0 : 2) : (([prediction[1] floatValue] > [prediction[2] floatValue]) ? 1 : 2);

    NSDictionary *update = @{ MESSAGE_KEY_PREDICTION:@(predictionIndex) };
    [watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        } else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (void)sendMessageTest:(PBWatch *)watch
{
    NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):@"a string" };
    [watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        } else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}


- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    NSLog(@"Pebble connected: %@", [watch name]);
    [self _setupHandlersWithWatch:watch];
//    [self sendMessageTest];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    NSLog(@"Pebble disconnected: %@", [watch name]);
/*
    if ([watch isEqual:self.connectedWatch]) {
        self.connectedWatch = nil;
    }
 */
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
