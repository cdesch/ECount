//
//  DragSprite.m
//  articletest
//
//  Created by Mathieu Roy on 10-09-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DragSprite.h"

@implementation DragSprite

@synthesize itemValue;
@synthesize itemValueLabel;

-(id) init{
    
	if((self=[super init])){
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        //[NSString stringWithFormat:@"%f",itemValue]
        itemValueLabel = [CCLabelTTF labelWithString:@"1" fontName:@"Helvetica" fontSize:24];
        itemValueLabel.position =  ccp(((self.position.x + 42)) , ((self.position.y - 15))); 
        [self addChild:itemValueLabel];
		
	}
    
	return self;
}

-(BOOL)isTouchOnSprite:(CGPoint)touch{
	if(CGRectContainsPoint(CGRectMake(self.position.x - ((self.contentSize.width/2)*self.scale), self.position.y - ((self.contentSize.height/2)*self.scale), self.contentSize.width*self.scale, self.contentSize.height*self.scale), touch)) 
		return YES;
	else return NO;
}

#pragma mark - Touch Actions

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
    //[self reorderChild:self z:10];
	
	if([self isTouchOnSprite:touchPoint]){
		whereTouch=ccpSub(self.position, touchPoint);
		return YES;
	}
	
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	self.position=ccpAdd(touchPoint,whereTouch);
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}

#pragma mark - Collision Detection

// Super-basic AABB collision detection
- (BOOL)collidesWith:(CCNode *)obj
{
	// Create two rectangles with CGRectMake, using each sprite's x/y position and width/height
	CGRect ownRect = CGRectMake(self.position.x - (self.contentSize.width / 2), self.position.y - (self.contentSize.height / 2), self.contentSize.width, self.contentSize.height);
	CGRect otherRect = CGRectMake(obj.position.x - (obj.contentSize.width / 2), obj.position.y - (obj.contentSize.height / 2), obj.contentSize.width, obj.contentSize.height);
    
	// Feed the results into CGRectIntersectsRect() which tells if the rectangles intersect (obviously)
	return CGRectIntersectsRect(ownRect, otherRect);
    
}

@end
