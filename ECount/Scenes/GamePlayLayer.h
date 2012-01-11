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

#import "GLES-Render.h"
#import "MyContactListener.h"
#import "SimpleAudioEngine.h"

@interface GamePlayLayer : CCLayer {
    
    CCLabelTTF*     timer; 
    CCLabelTTF*     total;
    
    CCSprite *pauseButton;
    CCSprite *pausedSprite;
    CCMenu *pausedMenu;
    BOOL paused;
    
	b2World* _world;
	GLESDebugDraw *_debugDraw;
    CCSpriteBatchNode *_spriteSheet;
    MyContactListener *_contactListener;
    b2MouseJoint *_mouseJoint;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    
    NSMutableDictionary* tokenDictionary; 
    NSMutableDictionary* workspaceDictionary;
    
    //Options Menu Parameters
    BOOL soundEffects;      //
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;



@end