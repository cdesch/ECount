//
//  StackSprite.m
//  ECount
//
//  Created by Chris Desch on 1/5/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import "StackSprite.h"


@implementation StackSprite

@synthesize itemValue;
@synthesize itemValueLabel;


-(id) init{
    
	if((self=[super init])){
		
        /*
        //[NSString stringWithFormat:@"%f",itemValue]
        itemValueLabel = [CCLabelTTF labelWithString:@"1" fontName:@"Helvetica" fontSize:24];
        itemValueLabel.position =  ccp(((self.position.x + 42)) , ((self.position.y - 15))); 
        [self addChild:itemValueLabel];
		*/
	}
    
	return self;
}

// Super-basic AABB collision detection
- (bool)collidesWith:(CCNode *)obj
{
	// Create two rectangles with CGRectMake, using each sprite's x/y position and width/height
	CGRect ownRect = CGRectMake(self.position.x - (self.contentSize.width / 2), self.position.y - (self.contentSize.height / 2), self.contentSize.width, self.contentSize.height);
	CGRect otherRect = CGRectMake(obj.position.x - (obj.contentSize.width / 2), obj.position.y - (obj.contentSize.height / 2), obj.contentSize.width, obj.contentSize.height);
    
	// Feed the results into CGRectIntersectsRect() which tells if the rectangles intersect (obviously)
	return CGRectIntersectsRect(ownRect, otherRect);
    
}

@end
