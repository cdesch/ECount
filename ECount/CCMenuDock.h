//
//  CCMenuDock.h
//  ECount
//
//  Created by Chris Desch on 1/16/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import "cocos2d.h"
#import "CCMenuItemDock.h"

typedef enum  {
    kNoBoundary,
    kRightBoundary,
    kLeftBoundary,
    kTopBoundary,
    kReturnToDock,
} BoundaryState;



// An NSObject wrapper for the CGPoint struct 
@interface Pair : NSObject
{
    CGPoint point;
}

@property (nonatomic) CGPoint point;

+ (id) makePair:(CGPoint)cgPoint;
- (id) initPair:(CGPoint)cgPoint;

@end

@interface CCMenuDock : CCMenu {
    
    //CGPoint                        startPoint;
    NSInteger                startIndex;
    NSMutableArray        *itemsArray;
    NSMutableArray        *positionsArray;
    CCMenuItemDock        *dockSelectedItem;
    
    BOOL                        contracted;
    BoundaryState        boundaryState;
}

@end