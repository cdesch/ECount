//
//  GamePlayLayer.h
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TRBox2D.h"
#import "SceneManager.h"

@interface GamePlayLayer : CCLayer {
    CCSprite *pauseButton;
    CCSprite *pausedSprite;
    CCMenu *pausedMenu;
    BOOL paused;
    b2World *world;
    GLESDebugDraw *debugDraw;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;

@end