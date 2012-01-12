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

#import "LevelData.h"

@interface GamePlayLayer : CCLayer {
    
    CCLabelTTF *timer; 
    
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
    NSMutableDictionary* workspaceLabelDictionary;
    
    //Options Menu Parameters
    BOOL soundEffects;      
    
    LevelData* levelData;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;
@property (nonatomic, retain) LevelData* levelData;

//+(id)nodeWithGameLevel:(int)level chapter:(int)chapter;
+ (id)nodeWithGameLevel:(int)level chapter:(int)chapter;
- (id)initWithGameLevel:(int)level chapter:(int)chapter;
- (BOOL)checkEndGame;


@end