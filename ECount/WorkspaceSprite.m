//
//  WorkspaceSprite.m
//  ECount
//
//  Created by Chris Desch on 1/12/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "WorkspaceSprite.h"

@implementation WorkspaceSprite


@synthesize itemValue;
@synthesize itemType;
@synthesize itemState;
@synthesize name;
@synthesize vertices;
@synthesize radius;

-(id)init{
    
	if((self=[super init])){
        
        //Initialize the object parameters
        itemValue = 0.0;
        itemType = 0;
		
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

//No Release Needed when subclassing CCSprite Class
/*- (void)dealloc{
 name = nil;
 
 
 }*/

@end
