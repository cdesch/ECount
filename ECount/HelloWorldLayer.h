//
//  HelloWorldLayer.h
//  ECount
//
//  Created by Chris Desch on 1/4/12.
//  Copyright Desch Enterprises 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "TokenData.h"
#import "SimpleAudioEngine.h"
#import "CCMenuDock.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
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
    
    CCMenuDock *menu;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate

- (void)addNewSpriteWithCoords:(CGPoint)p;
- (bool)detectCollision:(CCNode *)obj with:(CCNode*)object2;


@end
