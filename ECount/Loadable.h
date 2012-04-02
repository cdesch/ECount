//
//  Loadable.h
//  ECount
//
//  Created by Chris Desch on 1/14/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

@protocol LoadableDelegate;

@protocol Loadable

- (void) loadWithDelegate: (id <LoadableDelegate>) delegate;
- (BOOL) loadingUsesOpenGL;

@end