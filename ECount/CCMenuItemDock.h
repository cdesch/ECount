//
//  CCMenuItemDock.h
//  ECount
//
//  Created by Chris Desch on 1/16/12.
//  Copyright 2012 Desch Enterprises. All rights reserved.
//

#import "cocos2d.h"

typedef enum  {
    kLocked,
    kMovingRight,
    kMovingLeft,
} DockItemMoveState;

@interface CCMenuItemDock : CCMenuItemImage {
    
    NSString        *key;
    CGPoint                desiredPos;
    BOOL                markedToActivate;
    DockItemMoveState dockItemMoveState;
    
}

@property (nonatomic, assign) NSString        *key;
@property (nonatomic) CGPoint desiredPos;
@property (nonatomic) BOOL markedToActivate;
@property (nonatomic) DockItemMoveState dockItemMoveState;

+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2;
+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 target:(id) t selector:(SEL) s;
+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3;
+(id) itemFromNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3 target:(id) t selector:(SEL) s;
-(id) initFromNormalImage: (NSString*) normalI selectedImage:(NSString*)selectedI disabledImage: (NSString*) disabledI target:(id)t selector:(SEL)sel;
- (void)tick;

@end