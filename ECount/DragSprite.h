//
//  DragSprite.h
//  articletest
//
//  Created by Mathieu Roy on 10-09-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DragSprite : CCSprite <CCTargetedTouchDelegate> {
	
	BOOL isDrag;
	CGPoint whereTouch;
    
    float itemValue;
    CCLabelTTF* itemValueLabel;
	
}

@property(nonatomic, readwrite) float itemValue;
@property(nonatomic, retain)    CCLabelTTF* itemValueLabel;

- (BOOL)isTouchOnSprite:(CGPoint)touch;
- (BOOL)collidesWith:(CCNode *)obj;

@end
