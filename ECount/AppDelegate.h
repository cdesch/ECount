//
//  AppDelegate.h
//  ECount
//
//  Created by Chris Desch on 1/4/12.
//  Copyright Desch Enterprises 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
