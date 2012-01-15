//
//  Loader.m
//  ECount
//
//  Created by Chris Desch on 1/14/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//


#import "Loader.h"

@interface Loader ()
+ (NSOperationQueue *) sharedQueue;

@end

@implementation Loader

- (id) initWithLoadables: (NSArray *) ploadables asynchronous: (BOOL) asyn {
	self = [super init];
    
	loadables = [ploadables retain];
	asynchronous = asyn;
	progresses = calloc([loadables count], sizeof(float));
	for( int i = 0; i < [loadables count]; i++ ) {
		progresses[i] = 0;
	}
	return self;
}

+ (id) loaderWithLoadables: (NSArray *) loadables asynchronous: (BOOL) asyn {
	return [[[Loader alloc] initWithLoadables: loadables asynchronous: asyn] autorelease];
}

- (id) initWithLoadable: (NSObject <Loadable> *) loadable asynchronous: (BOOL) asyn {
	self = [super init];
    
	asynchronous = asyn;
	progresses = calloc(0, sizeof(float));
	progresses[0] = 0;
	loadables = [[NSArray alloc] initWithObjects: loadable, nil];
    
	return self;
}

+ (id) loaderWithLoadable: (NSObject <Loadable> *) loadable asynchronous: (BOOL) asyn {
	return [[[Loader alloc] initWithLoadable: loadable asynchronous: asyn] autorelease];
}

- (void) loadWithDelegate: (NSObject <LoadableDelegate> *) pdelegate {
	delegate = [pdelegate retain];
    
	if( asynchronous ) {
		[[Loader sharedQueue] addOperation: self];
	} else {
		[self main];
	}
}

- (BOOL) loadingUsesOpenGL {
	BOOL res = NO;
	for( id<Loadable> l in loadables ) {
		res = res || [l loadingUsesOpenGL];
	}
	return res;
}

- (void) loadable: (id <Loadable>) ldble reportingProgress: (float) progrs {
	progresses[[loadables indexOfObject:ldble]] = progrs;
    
	float sum = 0;
	for( int i = 0; i < [loadables count]; i++ ) {
		sum += progresses[i];
	}
	[delegate loadable: self reportingProgress: sum/[loadables count]];
}

- (void) main {
	// the real loading
	if( asynchronous && ![NSThread isMainThread] ) {
		[EAGLContext setCurrentContext: [[[CCDirector sharedDirector] openGLView] context]];
	}
    
	for( NSObject <Loadable> * loadable in loadables ) {
		[loadable loadWithDelegate: self];
	}
    
}

+ (NSOperationQueue *) sharedQueue {
	static NSOperationQueue *queue;
    
	if (queue == nil) {
		// create dict
		queue = [[NSOperationQueue alloc] init];
	}
    
	return queue;
}

- (BOOL) isFinished {
	float sum = 0;
	for( int i = 0; i < [loadables count]; i++ ) {
		sum += progresses[i];
	}
    
	return (sum/[loadables count]) == 1;
}

- (void) dealloc {
	free(progresses);
	[delegate release];
	[loadables release];
	[super dealloc];
}

@end
