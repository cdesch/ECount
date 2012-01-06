//
//  StackSprite.h
//  ECount
//
//  Created by Chris Desch on 1/5/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StackSprite : CCSprite {
    float itemValue;
    CCLabelTTF* itemValueLabel;
}
@property(nonatomic, readwrite) float itemValue;
@property(nonatomic, retain)    CCLabelTTF* itemValueLabel;

- (bool)collidesWith:(CCNode *)obj;

@end
