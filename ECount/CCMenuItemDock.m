//
//  CCMenuItemDock.m
//  ECount
//
//  Created by Chris Desch on 1/16/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import "CCMenuItemDock.h"

#define DOCK_ITEM_MOVE_SPEED 8


@implementation CCMenuItemDock

@synthesize key, desiredPos, markedToActivate, dockItemMoveState;

+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2
{
    return [self itemFromNormalImage:value selectedImage:value2 disabledImage: nil target:nil selector:nil];
}

+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 target:(id) t selector:(SEL) s
{
    return [self itemFromNormalImage:value selectedImage:value2 disabledImage: nil target:t selector:s];
}

+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3
{
    return [[[self alloc] initFromNormalImage:value selectedImage:value2 disabledImage:value3 target:nil selector:nil] autorelease];
}

+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3 target:(id) t selector:(SEL) s
{
    return [[[self alloc] initFromNormalImage:value selectedImage:value2 disabledImage:value3 target:t selector:s] autorelease];
}

-(id) initFromNormalImage: (NSString*) normalI selectedImage:(NSString*)selectedI disabledImage: (NSString*) disabledI target:(id)t selector:(SEL)sel
{
    markedToActivate = NO;
    CCNode *normalImage = [CCSprite spriteWithFile:normalI];
    CCNode *selectedImage = [CCSprite spriteWithFile:selectedI]; 
    CCNode *disabledImage = nil;
    
    if(disabledI)
        disabledImage = [CCSprite spriteWithFile:disabledI];
    
    return [self initFromNormalSprite:normalImage selectedSprite:selectedImage disabledSprite:disabledImage target:t selector:sel];
}

- (void) dealloc
{
    NSLog(@"dock item deallocated");
    [super dealloc];
}

- (void)tick
{
    switch(dockItemMoveState)
    {
        case kMovingLeft:
            // See if we have reached the desired position 
            if (self.position.x <= desiredPos.x)
            {
                self.position = desiredPos;
                dockItemMoveState = kLocked;
            }
            // Otherwise keep moving
            else
            {
                self.position = CGPointMake(self.position.x - DOCK_ITEM_MOVE_SPEED, self.position.y);
            }
            break;
        case kMovingRight:
            // See if we have reached the desired position 
            if (self.position.x >= desiredPos.x)
            {
                self.position = desiredPos;
                dockItemMoveState = kLocked;
            }
            // Otherwise keep moving
            else
            {
                self.position = CGPointMake(self.position.x + DOCK_ITEM_MOVE_SPEED, self.position.y);
            }                        
            break;
        case kLocked:
        default:
            break;
    }
}

// Override method from CCMenu Item class
-(void) selected 
{
    [super selected];
}

// Override method from CCMenu Item class
-(void) unselected 
{
    [super unselected];
}

// Override method from CCMenu Item class
- (void) activate 
{
    // If used with the dock, this should probably somehow check that the button has not moved
    NSLog(@"activated: do something");
    [super activate];
}


@end