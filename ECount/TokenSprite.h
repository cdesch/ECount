//
//  TokenSprite.h
//  ECount
//
//  Created by Chris Desch on 1/7/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TokenSprite : CCSprite {
    
    float       itemValue;
    int         itemType;
    int         itemState;
    NSString*   name;
    NSArray*    vertices;
    float       radius;
}

@property(nonatomic, readwrite) float       itemValue;
@property(nonatomic, readwrite) int         itemType;
@property(nonatomic, readwrite) int         itemState;
@property(nonatomic, retain)    NSString*   name;
@property(nonatomic, retain)    NSArray*    vertices;
@property(nonatomic, readwrite) float       radius;

- (bool)collidesWith:(CCNode *)obj;

@end
