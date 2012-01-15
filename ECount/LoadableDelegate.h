//
//  LoadableDelegate.h
//  ECount
//
//  Created by Chris Desch on 1/14/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "Loadable.h"

@protocol LoadableDelegate

- (void) loadable: (id <Loadable>) ldble reportingProgress: (float) progrs;

@end