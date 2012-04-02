//
//  LoopingMenu.m
//  ECount
//
//  Created by Chris Desch on 1/15/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//
/*
#import "LoopingMenu.h"

@implementation LoopingMenu

#pragma mark -
#pragma mark Menu

-(void) alignItemsVerticallyWithPadding:(float)padding
{
	[self alignItemsHorizontallyWithPadding:padding];
}

-(void) alignItemsHorizontallyWithPadding:(float)padding
{
	[super alignItemsHorizontallyWithPadding:padding];
}

-(void) registerWithTouchDispatcher
{
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:false];
}

#pragma mark -
#pragma mark Touches

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	moving = false;
	selectedItem = [super itemForTouch:touch];
	[selectedItem selected];
    
	state = kMenuStateTrackingTouch;
	return true;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(!moving)
		[super ccTouchEnded:touch withEvent:event];
	else
		[super ccTouchCancelled:touch withEvent:event];
	moving = false;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super ccTouchCancelled:touch withEvent:event];
	moving = false;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	NSMutableSet* touches = [[[NSMutableSet alloc] initWithObjects:touch, nil] autorelease];
    
	CGPoint distance = [InputController distance:1:touches :event];
    
	if([InputController wasSwipeLeft:touches :event] && distance.y < distance.x)
	{
		moving = true;
		[selectedItem unselected];
		[self setPosition:ccpAdd([self position], ccp(-distance.x, 0))];
        
		MenuItem* leftItem = [children objectAtIndex:0];
		if([leftItem position].x + [self position].x + [leftItem contentSize].width / 2.0  < 0)
		{
			[leftItem retain];
			[children removeObjectAtIndex:0];
			MenuItem* lastItem = [children objectAtIndex:[children count] - 1];
			[leftItem setPosition:ccpAdd([lastItem position], ccp([lastItem contentSize].width / 2.0 + [leftItem contentSize].width / 2.0, 0))];
			[children addObject:leftItem];
			[leftItem autorelease];
		}
	} 
	else if([InputController wasSwipeRight:touches:event] && distance.y < distance.x)
	{
		moving = true;
		[selectedItem unselected];
		[self setPosition:ccpAdd([self position], ccp(distance.x, 0))];
        
		MenuItem* lastItem = [children objectAtIndex:[children count] - 1];
		if([lastItem position].x + [self position].x - [lastItem contentSize].width / 2.0 > 480)
		{
			[lastItem retain];
			[children removeObjectAtIndex:[children count] - 1];
			MenuItem* firstItem = [children objectAtIndex:0];
			[lastItem setPosition:ccpSub([firstItem position], ccp([firstItem contentSize].width / 2.0 + [lastItem contentSize].width / 2.0, 0))];
			[children insertObject:lastItem atIndex:0];
			[lastItem autorelease];
		}
	}
	else if(!moving)
	{
		[super ccTouchMoved:touch withEvent:event];
	}
    
	//[self updateAnimation];
}

@end
*/