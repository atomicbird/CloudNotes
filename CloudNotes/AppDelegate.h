//
//  AppDelegate.h
//  CloudNotes
//
//  Created by Tom Harrington on 10/30/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
