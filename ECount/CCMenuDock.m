//
//  CCMenuDock.m
//  ECount
//
//  Created by Chris Desch on 1/16/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import "CCMenuDock.h"

#define DOCK_ITEMS_PADDING 5

// NSObject wrapper for CGPoint implementation
@implementation Pair

@synthesize point;

+ (id) makePair:(CGPoint)point
{
    return [[[self alloc] initPair:point] autorelease];
}

- (id) initPair:(CGPoint) cgPoint
{
    if ((self = [super init]))
    {
        self.point = cgPoint;
    }
    return self;
}

@end

@interface CCMenuDock (Private)

// returns touched menu item, if any
-(CCMenuItemDock *) itemForTouch: (UITouch *) touch;
- (void)contract;
- (void)expand:(int)index;
- (void)markSelectedItemForActivating;
- (void)unmarkSelectedItemForActivating;
- (NSInteger)getClosestDockIndex:(CGPoint)position;
- (BoundaryState)boundaryCheck:(CGPoint)position;
@end

@implementation CCMenuDock

- (id)initWithItems:(CCMenuItem *)item vaList:(va_list)args {
    if((self = [super initWithItems:item vaList:args])) {
        contracted = NO;
        [self schedule:@selector(updateDockItems) interval: (1.0f/60.0)];
    }
    return self;
}

+ (id)menuWithItems:(CCMenuItem *)item vaList:(va_list)args {
    CCMenuDock *dock = [[CCMenuDock alloc] initWithItems:item vaList:args];
    return [dock autorelease];
}

- (void)dealloc {
    [itemsArray release];
    [positionsArray release];
    [super dealloc];
}

- (void)addChild:(CCNode *)node
{
    [self addChild:node z:1 tag:0];
}

- (void)addChild:(CCNode *)node z:(NSInteger)z
{
    [self addChild:node z:z tag:0];
}

- (void)addChild:(CCMenuItem *)node z:(NSInteger)z tag:(NSInteger)tag {
    NSAssert( [node isKindOfClass:[CCMenuItemDock class]], @"CCMenu only supports MenuItemDock objects as children");
    
    if (!itemsArray)
        itemsArray = [[NSMutableArray arrayWithCapacity:10] retain];
    if (!positionsArray) 
        positionsArray = [[NSMutableArray arrayWithCapacity:10] retain];
    
    // Class cast node to CCMenuItemDock
    CCMenuItemDock *nodeTemp = (CCMenuItemDock *)node;
    
    // Creates a new anchor point within the dock as a new child is added based on its size and amount of separtion.
    [positionsArray addObject:[Pair makePair:CGPointMake((((node.contentSize.width+DOCK_ITEMS_PADDING)*positionsArray.count)+(node.contentSize.width/2)), (node.contentSize.height/2))]];
    
    NSLog(@"%@", positionsArray);
    
    // Add it to the array
    [itemsArray addObject:node];
    
    // Position the item based on where it is in the dock and how large the icons are
    nodeTemp.position = [[positionsArray objectAtIndex:[itemsArray indexOfObject:node]] point];
    
    nodeTemp.desiredPos = node.position;
    
    // Add it as a child to the dock object
    [super addChild:nodeTemp z:z tag:tag];
}

-(void) removeChild: (CCNode*)child cleanup:(BOOL)cleanup
{
    dockSelectedItem = nil;
    [positionsArray removeLastObject];
    [super removeChild:child cleanup:cleanup];
    
    
    //Add to field
    
    //
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CCMenuItemDock *temp = (CCMenuItemDock *)[self itemForTouch:touch];
    
    // Check if there is already an item selected
    // if there is then check if the new item is the same
    // if it is not the same then it resets the cast counter
    // other than that, stop the previously selected item from bouncing.
    if (dockSelectedItem && ![dockSelectedItem isEqual:temp]) {
        [dockSelectedItem stopAllActions];
        [self unmarkSelectedItemForActivating];
        dockSelectedItem.scale = 1.0f;
    }
    
    if(!temp) {
        [self stopAllActions];
    }
    
    
    NSLog(@"Dock: Touch Began, state: %d", state_);
    if( state_ != kCCMenuStateWaiting ) return NO;
    
    dockSelectedItem = temp;
    
    // Only allow selection if an item is actually selected and as long as it isn't moving
    if (dockSelectedItem && dockSelectedItem.dockItemMoveState == kLocked) 
    {
        dockSelectedItem.scale = 1.05f;
        [self reorderChild:dockSelectedItem z:99];
        [dockSelectedItem selected];                
        state_ = kCCMenuStateTrackingTouch;
        //NSLog(@"Inside touch began, change state to: %d", state);                
        // Store where the item started moving from for boundary checks later (store the absolute position)
        //startPoint = ccpAdd(dockSelectedItem.position, self.position);
        startIndex = [itemsArray indexOfObject:dockSelectedItem];
        return YES;
    }
    return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"Dock: Touch Ended, state: %d", state);        
    NSAssert(state_ == kCCMenuStateTrackingTouch, @"[CCMenu ccTouchEnded] -- invalid state");
    
    [dockSelectedItem unselected];
    if (dockSelectedItem) {
        [self reorderChild:dockSelectedItem z:1];
    }
    
    state_ = kCCMenuStateWaiting;
    
    // We are outside the top or bottom boundary and user has let go of the item
    // Destroy it
    if (boundaryState == kTopBoundary)
    {
        [self removeChild:dockSelectedItem cleanup:YES];
        // Reset the flag for next time
        contracted = NO;
        boundaryState = kNoBoundary;
    }
    else
    {
        dockSelectedItem.scale = 1.0f;
        NSLog(@"Touch Ended");
        
        // If the dock item did not move from its orginal position then count that as activated
        // If the summoner has enough mana to cast the card
        // Contract and remove it from the dock.
        if(ccpDistance(dockSelectedItem.position, [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point]) == 0.0) {
            
            
            // If the dock item isn't marked to cast and is pulsing, stop pulsing.
            // This is to implement the deselect when the player tap on the item
            // a second time.
            if(!dockSelectedItem.markedToActivate && [dockSelectedItem numberOfRunningActions] > 0) {
                [dockSelectedItem stopAllActions];
            }
            // If that check fails then the item should pulse to indicate selection.
            else {
                id resize = [CCScaleBy actionWithDuration:0.18f scale:1.1f];
                id reverseResize = [resize reverse];
                id bounce = [CCSequence actions:resize, reverseResize, nil];
                id pulse = [CCRepeatForever actionWithAction:bounce];
                [dockSelectedItem runAction:pulse];
            }
            
            // If the item is marked to activate then stop all actions (prevent the
            // item from being unmarked) and activate the item and contract the
            // dock.
            if(dockSelectedItem.markedToActivate) {
                [self stopAllActions];
                [dockSelectedItem activate];
                [self contract];
                [self removeChild:dockSelectedItem cleanup:YES];
            }
            
            // If the item isn't marked to activate then mark it for activating.
            // Also set up actions such that it will unmark the card after a
            // certain amount of seconds.
            else if(!dockSelectedItem.markedToActivate) {
                [self markSelectedItemForActivating];
                
                id wait = [CCDelayTime actionWithDuration:0.25f];
                id unmark = [CCCallFunc actionWithTarget:self selector:@selector(unmarkSelectedItemForActivating)];
                id sequence = [CCSequence actions:wait, unmark, nil];
                
                [self runAction:sequence];
            }
            
            // Reset the flag for next time
            contracted = NO;
            boundaryState = kNoBoundary;
        }
        // No boundary crossings, go back to original position        
        else {
            dockSelectedItem.position = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
        }
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Dock: Touch Cancelled");
    
    NSAssert(state_ == kCCMenuStateTrackingTouch, @"[CCMenu ccTouchCancelled] -- invalid state");
    
    [dockSelectedItem unselected];
    
    state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSAssert(state_ == kCCMenuStateTrackingTouch, @"[CCMenu ccTouchMoved] -- invalid state");
    
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    /*
     NSLog(@"Dock location: %4.2f, %4.2f", self.position.x, self.position.y);
     NSLog(@"Item location: %4.2f, %4.2f", dockSelectedItem.position.x, dockSelectedItem.position.y);
     NSLog(@"Current touch: %4.2f, %4.2f", touchLocation.x, touchLocation.y);
     */
    
    if(dockSelectedItem) {
        [dockSelectedItem stopAllActions];
        dockSelectedItem.scale = 1.05f;
        [dockSelectedItem stopAllActions];
    }
    
    // Find the new position relative to the dock item
    // This is touch (absolute) - dock (absolute)
    CGPoint location = ccpSub(touchLocation, self.position);
    
    dockSelectedItem.position = location;
    
    // Check if item has gone past a boundary
    boundaryState = [self boundaryCheck:location];
    
    switch (boundaryState)
    {
        case kRightBoundary:
            // Check that there is an item to our right
            if ([itemsArray indexOfObject:dockSelectedItem] + 1 < itemsArray.count)
            {
                // Get a reference to the item on our right
                CCMenuItemDock *temp = [itemsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem] + 1];
                // Move the item whose territory you're in into your old spot                                
                temp.desiredPos = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
                // Unlock the button so that it can move
                temp.dockItemMoveState = kMovingLeft;
                
                // Swap positions in the array
                [itemsArray removeObjectAtIndex:[itemsArray indexOfObject:dockSelectedItem]];
                [itemsArray insertObject:dockSelectedItem atIndex:[itemsArray indexOfObject:temp] + 1];                        
                
                // Set the target's old location as this item's base
                dockSelectedItem.desiredPos = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
                startIndex = [itemsArray indexOfObject:dockSelectedItem];
            }
            // Else we are at an array end, do nothing
            else
            {
                boundaryState = kNoBoundary;
            }
            break;
        case kLeftBoundary:
            // Check that there is an item to our left
            if ([itemsArray indexOfObject:dockSelectedItem] > 0)
            {
                // Get a reference to the item on our left
                CCMenuItemDock *temp = [itemsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem] - 1];
                // Move the item whose territory you're in into your old spot                                
                temp.desiredPos = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
                // Unlock the button so that it can move                
                temp.dockItemMoveState = kMovingRight;
                
                // Swap positions in the array
                [itemsArray removeObjectAtIndex:[itemsArray indexOfObject:dockSelectedItem]];
                [itemsArray insertObject:dockSelectedItem atIndex:[itemsArray indexOfObject:temp]];        
                
                // Set the target's old location as this item's base
                dockSelectedItem.desiredPos = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
                startIndex = [itemsArray indexOfObject:dockSelectedItem];
            }
            // Else we are at an array end, do nothing                        
            else
            {
                boundaryState = kNoBoundary;
            }                        
            break;
            // State where the item has been dragged past the top or the bottom of the dock
        case kTopBoundary:
            if (!contracted)
            {
                // Contract the dock
                [self contract];
                // Set the flag to indicate the item is outside the dock
                contracted = YES;
            }
            break;
            // State where the selected item has been outside the dock and is being returned
        case kReturnToDock:
            // Determine the index to add it back to and then expand the existing items to make room
            [self expand:[self getClosestDockIndex:location]];
            // Reset the flag 
            contracted = NO;
            break;
        case kNoBoundary:
        default:
            // Don't do anything
            break;
    }
}

- (void)markSelectedItemForActivating {
    dockSelectedItem.markedToActivate = YES;
}

- (void)unmarkSelectedItemForActivating {
    dockSelectedItem.markedToActivate = NO;
}

- (NSInteger)getClosestDockIndex:(CGPoint)position {
    int width = dockSelectedItem.contentSize.width;
    int tick = width + DOCK_ITEMS_PADDING;
    
    int index = (int)(position.x)/tick;
    
    if(index > positionsArray.count - 1)
        return positionsArray.count - 1;
    else if(index < 0)
        return 0;
    else
        return index;
}

// Function used when user moves an item out of the dock
- (void) contract
{
    NSInteger index = [itemsArray indexOfObject:dockSelectedItem];
    
    // Remove the item from the array
    [itemsArray removeObjectAtIndex:index];        
    
    // Shift all items on the left side to the right
    for (int i = 0; i < index; i++)
    {
        CCMenuItemDock *item = [itemsArray objectAtIndex:i];
        item.desiredPos = [[positionsArray objectAtIndex:i] point];
        item.dockItemMoveState = kMovingRight;
        
    }
    // Shift all items on the right side to the left
    for (int i = index; i < itemsArray.count; i++)
    {
        CCMenuItemDock *item = [itemsArray objectAtIndex:i];
        item.desiredPos = [[positionsArray objectAtIndex:i] point];
        item.dockItemMoveState = kMovingLeft;
    }
}

// Function used when user moves an item back into the dock
- (void) expand:(int)index
{
    [itemsArray insertObject:dockSelectedItem atIndex:index];
    
    // Put the item that the user dragged back into the dock into the correct position
    dockSelectedItem.desiredPos = [[positionsArray objectAtIndex:index] point];
    
    // Shift all items on the left side to the left
    for (int i = 0; i < index; i++)
    {
        CCMenuItemDock *item = [itemsArray objectAtIndex:i];
        item.desiredPos = [[positionsArray objectAtIndex:i] point];
        item.dockItemMoveState = kMovingLeft;
        
    }
    // Shift all items on the right side to the right
    for (int i = index + 1; i < itemsArray.count; i++)
    {
        CCMenuItemDock *item = [itemsArray objectAtIndex:i];
        item.desiredPos = [[positionsArray objectAtIndex:i] point];                
        item.dockItemMoveState = kMovingRight;
    }        
}

- (void)updateDockItems
{
    [children_ makeObjectsPerformSelector:@selector(tick)];
}

- (BoundaryState) boundaryCheck: (CGPoint)position 
{
    //NSLog(@"Original location: %4.2f, %4.2f", startPoint.x, startPoint.y);        
    //NSLog(@"Content size: %4.2f, %4.2f", dockSelectedItem.contentSize.width, dockSelectedItem.contentSize.height);
    //NSLog(@"Location to check: %4.2f, %4.2f", position.x, position.y);        
    
    CGSize size = dockSelectedItem.contentSize;
    
    // ButtonItem locations are always reference from the bottom left
    // Check if we've crossed the top or bottom of the dock
    if (abs((size.height/2) - position.y) > size.height)
    {
        return kTopBoundary;
    }        
    // If not, we now need to determine whether we came from a state where the user had the 
    // item outside the dock or whether the item is just moving around within the dock
    else
    {
        if (contracted)
        {
            // This indicates that the item has been returned to the dock after being moved outside
            return kReturnToDock;
        }
        else
        {
            CGPoint startPoint = [[positionsArray objectAtIndex:[itemsArray indexOfObject:dockSelectedItem]] point];
            // Check the left boundary
            if (startPoint.x - position.x > (size.width/2) + DOCK_ITEMS_PADDING)
            {
                return kLeftBoundary;
            }
            // Check the right boundary
            if (position.x - startPoint.x > (size.width/2) + DOCK_ITEMS_PADDING)
            {
                return kRightBoundary;                
            }        
            // Else the item hasn't been moved past a boundary
            return kNoBoundary;
        }
    }
}

#pragma mark CCMenu - Private

- (CCMenuItemDock *) itemForTouch: (UITouch *) touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    for( CCMenuItemDock* item in children_ ) {
        CGPoint local = [item convertToNodeSpace:touchLocation];
        
        CGRect r = [item rect];
        r.origin = CGPointZero;
        
        if( CGRectContainsPoint( r, local ) )
            return item;
    }
    return nil;
}


@end