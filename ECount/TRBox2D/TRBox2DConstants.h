//
//  TRBox2DConstants.h
//  
//  This file is used for 'global' variables (constants).  
//  
//  Just ensure you import this header file to use the constants.
//

// Box2D Pixels to Meters ratio:
#define PTM_RATIO 32

// Box2D World Gravity:
#define kVerticalGravity -10.0
#define kHorizontalGravity 0.0

// Box2D Object Type, add to this as you see fit:
typedef enum {
    kObjectNone,
    kObjectPlayer,
    kObjectPlatform,
    kObjectOneSidedPlatform,
    kObjectMob,
    kObjectCoin
} ObjectType;