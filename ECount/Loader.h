//
//  Loader.h
//  ECount
//
//  Created by Chris Desch on 1/14/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loadable.h"
#import "LoadableDelegate.h"
#import "cocos2d.h"

@interface Loader : NSOperation <Loadable, LoadableDelegate> {
	NSArray *						loadables;
	NSObject <LoadableDelegate> *	delegate;
	BOOL							asynchronous;
	float *							progresses;
}
- (id) initWithLoadables: (NSArray *) ploadables asynchronous: (BOOL) asyn;
+ (id) loaderWithLoadables: (NSArray *) loadables asynchronous: (BOOL) asyn;

- (id) initWithLoadable: (NSObject <Loadable> *) loadable asynchronous: (BOOL) asyn;
+ (id) loaderWithLoadable: (NSObject <Loadable> *) loadable asynchronous: (BOOL) asyn;

@end