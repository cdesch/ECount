//
//  GamePlayLayer.m
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import "GamePlayLayer.h"

#import "TokenData.h"
#import "TokenSprite.h"

#define PTM_RATIO 32
#define kBackgroundLevel 1
#define kSpriteSpawnLevel 2
#define kSpriteActiveLevel 3

#define kSpaceDamping 0.5f
#define kWorkspaceDamping 2.0f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

typedef enum {
    kActive,
    kSpawend,
    kSpawnStack,
    kWorkspace
} SpriteState;

@implementation GamePlayLayer

@synthesize iPad, device;

#pragma mark - Button Actions
- (void)quitButtonWasPressed:(id)sender {
    [SceneManager goLevelSelect];
}
- (void)restartButtonWasPressed:(id)sender {
    [SceneManager goGameScene];
}
- (void)resumeButtonWasPressed:(id)sender {
    
    // unpause the game
    paused = NO;
    
    // show the pause button
    [pauseButton runAction:[CCFadeIn actionWithDuration:0.5]];
    
    // hide the sprite that shows the word 'Paused' from view
    [pausedSprite runAction:[CCMoveTo actionWithDuration:0.5
                                                position:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height + 200)]];
    // hide the paued menu from view
    [pausedMenu runAction:[CCMoveTo actionWithDuration:0.5
                                              position:ccp([CCDirector sharedDirector].winSize.width/2, -300)]];    
    
}
- (void)pauseButtonWasPressed:(id)sender {
    
    // pause the game
    paused = YES;
    
    // hide the pause button
    [pauseButton runAction:[CCFadeOut actionWithDuration:0.5]];
    
    // bring the sprite that shows the word 'Paused' into view
    [pausedSprite runAction:[CCMoveTo actionWithDuration:0.5
                                                position:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height/2+50)]];
    // bring the paued menu into view
    [pausedMenu runAction:[CCMoveTo actionWithDuration:0.5
                                              position:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height/2-100)]];
}
- (void)createPausedMenu {
    
    // create a sprite that says simply 'Paused'
    pausedSprite = [CCSprite spriteWithFile:@"Paused.png"];
    
    // create the quit button
    CCMenuItemSprite *item1 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"54-stop-%@.png", self.device]]
                            selectedSprite:nil
                                    target:self selector:@selector(quitButtonWasPressed:)];
    
    // create the restart button
    CCMenuItemSprite *item2 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"02-redo-%@.png", self.device]]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(restartButtonWasPressed:)];
    // create the resume button
    CCMenuItemSprite *item3 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:[NSString stringWithFormat:@"49-play-%@.png", self.device]]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(resumeButtonWasPressed:)];

    [item1 setScale:2.0f];
    [item2 setScale:2.0f];
    [item3 setScale:2.0f];
    
    // put all those three buttons on the menu
    pausedMenu = [CCMenu menuWithItems:item1, item2, item3, nil];
    
    [pausedMenu alignItemsHorizontallyWithPadding:40.0f];
    
    // align the menu
    /*
    [pausedMenu alignItemsInRows:
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     nil];
    */
    // create the paused sprite and paused menu buttons off screen
    [pausedSprite setPosition:ccp([CCDirector sharedDirector].winSize.width/2-10, [CCDirector sharedDirector].winSize.height + 200)];
    [pausedMenu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, -300)];
    
    // add the Paused sprite and menu to the current layer
    [self addChild:pausedSprite z:100];
    [self addChild:pausedMenu z:100];
}
- (void)createPauseButton {
    
    // create sprite for the pause button
    pauseButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"48-pause-%@.png", self.device]];
    
    // create menu item for the pause button from the pause sprite
    CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite:pauseButton
                                                     selectedSprite:nil
                                                             target:self
                                                           selector:@selector(pauseButtonWasPressed:)];
    
    // create menu for the pause button and put the menu item on the menu
    CCMenu *menu = [CCMenu menuWithItems: item, nil];
    [menu setAnchorPoint:ccp(0, 0)];
    [menu setIsRelativeAnchorPoint:NO];
    [menu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height-16)];
    //[menu setScale:0.3];
    [self addChild:menu];
}

#pragma mark - Sprite Controllers and Models

- (void)addBoxBodyForSprite:(TokenSprite *)sprite {
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = _world->CreateBody(&spriteBodyDef);
    
    spriteBody->SetLinearDamping(kSpaceDamping); 
    spriteBody->SetAngularDamping(kSpaceDamping);
    
    b2PolygonShape spriteShape;
    if(sprite.itemType == 4){
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-3.5f / PTM_RATIO, 51.7f / PTM_RATIO),
            b2Vec2(-41.7f / PTM_RATIO, 30.5f / PTM_RATIO),
            b2Vec2(-50.7f / PTM_RATIO, -2.0f / PTM_RATIO),
            b2Vec2(-40.0f / PTM_RATIO, -31.5f / PTM_RATIO),
            b2Vec2(-9.7f / PTM_RATIO, -49.0f / PTM_RATIO),
            b2Vec2(30.2f / PTM_RATIO, -39.2f / PTM_RATIO),
            b2Vec2(47.7f / PTM_RATIO, 5.5f / PTM_RATIO),
            b2Vec2(23.0f / PTM_RATIO, 43.7f / PTM_RATIO)
            
        };
        
        //NSMutableArray* array = [self getb2Vec2:sprite];
        //b2Vec2 * vl = (b2Vec2*)[[array objectAtIndex:0] bytes];
        //spriteShape.Set(vl, [[array objectAtIndex:1] intValue] );
        spriteShape.Set(verts, num);
        
    }else if (sprite.itemType == 5){
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-176.2f / PTM_RATIO, -118.4f / PTM_RATIO),
            b2Vec2(164.6f / PTM_RATIO, -118.8f / PTM_RATIO),
            b2Vec2(170.6f / PTM_RATIO, -47.0f / PTM_RATIO),
            b2Vec2(169.2f / PTM_RATIO, 51.6f / PTM_RATIO),
            b2Vec2(162.8f / PTM_RATIO, 118.4f / PTM_RATIO),
            b2Vec2(-174.1f / PTM_RATIO, 120.9f / PTM_RATIO),
            b2Vec2(-180.1f / PTM_RATIO, 52.7f / PTM_RATIO),
            b2Vec2(-180.5f / PTM_RATIO, -47.7f / PTM_RATIO)
        };
        
        spriteShape.Set(verts, num);
    }    
    else if (sprite.itemType == 3){
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-0.7f / PTM_RATIO, 48.5f / PTM_RATIO),
            b2Vec2(-35.7f / PTM_RATIO, 33.0f / PTM_RATIO),
            b2Vec2(-47.7f / PTM_RATIO, 2.5f / PTM_RATIO),
            b2Vec2(-35.5f / PTM_RATIO, -30.5f / PTM_RATIO),
            b2Vec2(-6.2f / PTM_RATIO, -46.5f / PTM_RATIO),
            b2Vec2(34.7f / PTM_RATIO, -32.5f / PTM_RATIO),
            b2Vec2(46.7f / PTM_RATIO, 11.2f / PTM_RATIO),
            b2Vec2(19.7f / PTM_RATIO, 43.5f / PTM_RATIO)
        };
        spriteShape.Set(verts, num);
    }
    
    else if (sprite.itemType == 2) {
        //row 1, col 4
        int num = 7;
        b2Vec2 verts[] = {
            b2Vec2(-2.5f / PTM_RATIO, 45.1f / PTM_RATIO),
            b2Vec2(-43.3f / PTM_RATIO, 14.3f / PTM_RATIO),
            b2Vec2(-39.4f / PTM_RATIO, -23.2f / PTM_RATIO),
            b2Vec2(-4.2f / PTM_RATIO, -44.0f / PTM_RATIO),
            b2Vec2(35.5f / PTM_RATIO, -24.7f / PTM_RATIO),
            b2Vec2(43.3f / PTM_RATIO, 10.8f / PTM_RATIO),
            b2Vec2(14.1f / PTM_RATIO, 42.2f / PTM_RATIO)
        };
        spriteShape.Set(verts, num);
    } else {
        // Do the same thing as the above, but use the car data this time
        //row 1, col 1
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-3.5f / PTM_RATIO, 62.0f / PTM_RATIO),
            b2Vec2(-52.0f / PTM_RATIO, 34.0f / PTM_RATIO),
            b2Vec2(-61.0f / PTM_RATIO, -3.5f / PTM_RATIO),
            b2Vec2(-39.0f / PTM_RATIO, -47.5f / PTM_RATIO),
            b2Vec2(-0.5f / PTM_RATIO, -61.0f / PTM_RATIO),
            b2Vec2(48.5f / PTM_RATIO, -36.0f / PTM_RATIO),
            b2Vec2(58.0f / PTM_RATIO, 15.5f / PTM_RATIO),
            b2Vec2(12.5f / PTM_RATIO, 59.5f / PTM_RATIO)
        };
        spriteShape.Set(verts, num);
    }

    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    
    spriteShapeDef.isSensor = true;
    
    spriteBody->CreateFixture(&spriteShapeDef);
    
}

- (void)addCircleBodyForSprite:(TokenSprite *)sprite {
    
    //Define Body
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = _world->CreateBody(&spriteBodyDef);
    
    //Set Body movement properties
    spriteBody->SetLinearDamping(kSpaceDamping); 
    spriteBody->SetAngularDamping(kSpaceDamping);
    
    //Define Shape
    b2CircleShape spriteShape;
    spriteShape.m_radius =  sprite.radius / PTM_RATIO;
    
    //Define Fixture
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    
    spriteShapeDef.isSensor = true;
    
    spriteBody->CreateFixture(&spriteShapeDef);
    
}



//Destroy the sprite!
- (void)spriteDone:(id)sender {
    
    // This selector is called from CCCallFuncN, and it passes the object the action is
    // run on as a parameter.  We know it's a sprite, so cast it as that!
    CCSprite *sprite = (CCSprite *)sender;
    
    // Loop through all of the Box2D bodies in our Box2D world...
    // We're looking for the Box2D body corresponding to the sprite.
    b2Body *spriteBody = NULL;
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        
        // See if there's any user data attached to the Box2D body
        // There should be, since we set it in addBoxBodyForSprite
        if (b->GetUserData() != NULL) {
            
            // We know that the user data is a sprite since we set
            // it that way, so cast it...
            CCSprite *curSprite = (CCSprite *)b->GetUserData();
            
            // If the sprite for this body is the same as our current
            // sprite, we've found the Box2D body we're looking for!
            if (sprite == curSprite) {
                spriteBody = b;
                break;
            }
        }
    }
    
    // If we found the body, we want to destroy it since the cat is offscreen now.
    if (spriteBody != NULL) {
        _world->DestroyBody(spriteBody);
    }
    
    // And of course we need to remove the Cocos2D sprite too.
    [_spriteSheet removeChild:sprite cleanup:YES];
    
}

//Spawn a Sprite from a Token Data
- (void)spawnSpriteFromToken:(TokenData*)token state:(int)state {

    TokenSprite *sprite = [TokenSprite spriteWithSpriteFrameName:token.imageName];
    sprite.name = token.name;
    //sprite.vertices = token.vertices;
    sprite.radius = token.radius;
    sprite.position = token.itemPosition;
    sprite.itemType = token.itemType;
    sprite.itemValue = token.itemValue;
    sprite.itemState = state;
    sprite.tag = token.itemType;        
    if(token.itemType == 5){
        [self addBoxBodyForSprite:sprite];    
    }else {
        [self addCircleBodyForSprite:sprite];    
    }
       
    
    [_spriteSheet addChild:sprite z:kSpriteSpawnLevel tag:token.itemType];
    
}


#pragma mark - init

- (void) setupPhysicsWorld {
    /*
    b2Vec2 gravity = b2Vec2(kHorizontalGravity, kVerticalGravity); // Set in TRBox2DConstants.h
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    _world->SetDebugDraw(_debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    flags += b2DebugDraw::e_jointBit;
    //      flags += b2DebugDraw::e_aabbBit;
    //      flags += b2DebugDraw::e_pairBit;
    //      flags += b2DebugDraw::e_centerOfMassBit;
    _debugDraw->SetFlags(flags);
    */
    
    // Create b2 world
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = false;
    _world = new b2World(gravity, doSleep);
    
    // Enable debug draw
    _debugDraw = new GLESDebugDraw( PTM_RATIO );
    _world->SetDebugDraw(_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    _debugDraw->SetFlags(flags);
}


- (void) limitWorldToScreen {

    /*
    TRBox2D *limits = [[TRBox2D new] autorelease];
    [limits createEdgesForWorld:_world 
                 fromScreenSize:[CCDirector sharedDirector].winSize];
    [self addChild:limits];
     */
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Create edges around the entire screen    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO, 0));
    _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, screenSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(0, screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO, 
                                                                       screenSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO), 
                        b2Vec2(screenSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&groundBoxDef);   
    
}
- (void)tick: (ccTime) dt {
    if (!paused) {
        
        /*
        //It is recommended that a fixed time step is used with Box2D for stability
        //of the simulation, however, we are using a variable time step here.
        //You need to make an informed choice, the following URL is useful
        //http://gafferongames.com/game-physics/fix-your-timestep/
    
        int32 velocityIterations = 8;
        int32 positionIterations = 1;
    
        // Instruct the world to perform a single step of simulation. It is
        // generally best to keep the time step and iterations fixed.
        _world->Step(dt, velocityIterations, positionIterations);
    
        //Iterate over the bodies in the physics world
        for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
        {
            if (b->GetUserData() != NULL) {
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                CCSprite *myActor = (CCSprite*)b->GetUserData();
                myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
        }
         */
        
        
        // Updates the physics simulation for 10 iterations for velocity/position
        _world->Step(dt, 10, 10);
        
        // Loop through all of the Box2D bodies in our Box2D world..
        for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
            
            //Turn off linear damping if it was set by a different cycle. 
            b->SetLinearDamping(kSpaceDamping); 
            b->SetAngularDamping(kSpaceDamping);
            
            // See if there's any user data attached to the Box2D body
            // There should be, since we set it in addBoxBodyForSprite
            if (b->GetUserData() != NULL) {            
                
                // We know that the user data is a sprite since we set
                // it that way, so cast it...
                TokenSprite *sprite = (TokenSprite *)b->GetUserData();
                
                /*
                 if( [sprite isKindOfClass:[WorkspaceSprite class]]){
                 NSLog(@"Workspace found");
                 //Find all sprites 
                 
                 return; 
                 }*/
                
                //Only Move sprites that are not a stack
                if(sprite.itemState != kSpawnStack){
                    
                    sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                          b->GetPosition().y * PTM_RATIO);
                    sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                    
                }else{
                    //NSLog(@"itemType: %@", sprite.itemType);
                }
                
                
                //Check the stack to see if the spawned sprite resting on it has left
                //spawn a new sprite and change its properties if it has left the stack
                if(sprite.itemState == kSpawnStack){
                    
                    //Check through all the bodies in the world for this sprite. 
                    for(b2Body *c = _world->GetBodyList(); c; c=c->GetNext()) {
                        
                        //Only check the ones with Userdata
                        if(c->GetUserData() != NULL){
                            TokenSprite *subSprite = (TokenSprite *)c->GetUserData();
                            
                            //Don't Check it if it is itself
                            if(subSprite != sprite){
                                
                                //Only check if it is in a kSpawned State AND is of that sprite type
                                if (subSprite.itemState == kSpawend && subSprite.itemType == sprite.itemType){
                                    
                                    //Check to see if this sprite is colliding (resting).  skip if it is and check the next one
                                    //if(![self detectCollision:sprite with:subSprite]){
                                    if(![sprite collidesWith:subSprite]){    
                                        
                                        //Change properties of subsprite
                                        subSprite.itemState = kActive;
                                        [_spriteSheet reorderChild:subSprite z:kSpriteActiveLevel];
                                        
                                        //Change the Fixture type 
                                        for(b2Fixture *fixture = c->GetFixtureList(); fixture; fixture=fixture->GetNext()) {
                                            fixture->SetSensor(NO);
                                        }
                                        
                                        //Spawn New Sprite in place
                                        [self spawnSpriteFromToken:[tokenDictionary objectForKey:sprite.name] state:kSpawend];
                                        NSLog(@"Spawned %@", sprite.name);
                                        //We are done for now. Return for the next Loop
                                        return;
                                        
                                    }
                                }
                            }
                        }
                    }
                }else if(sprite.itemState == kWorkspace){
                    
                    //
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
                    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                
                    // Change local and output as currency
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    [formatter setLocale:locale];
                    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithFloat:sprite.itemValue]];
                                        
                    //NOTE: MAy have to put this on a different check interval that is less than 1 step
                    //Set HUD View 
                    [total setString:formattedOutput];
                    
                    //Check end game case
                    //NSLog(@"Workspace: %@  Value: %f", sprite.name, sprite.itemValue);
                    
                    //Reset to 0 if not
                    sprite.itemValue = 0;
                }
            }
        }
        
        
        
        // Loop through all of the box2d bodies that are currently colliding, that we have
        // gathered with our custom contact listener...
        std::vector<b2Body *>toDestroy; 
        std::vector<MyContact>::iterator pos;
        for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
            MyContact contact = *pos;
            
            // Get the box2d bodies for each object
            b2Body *bodyA = contact.fixtureA->GetBody();
            b2Body *bodyB = contact.fixtureB->GetBody();
            if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
                TokenSprite *spriteA = (TokenSprite *) bodyA->GetUserData();
                TokenSprite *spriteB = (TokenSprite *) bodyB->GetUserData();
                
                // Is sprite A a cat and sprite B a car?  If so, push the cat on a list to be destroyed...
                if ((spriteA.itemState == kActive && spriteB.itemState == kSpawnStack) && (spriteB.itemType == spriteA.itemType )) {
                    toDestroy.push_back(bodyA);
                } 
                // Is sprite A a car and sprite B a cat?  If so, push the cat on a list to be destroyed...
                else if ((spriteA.itemState == kSpawnStack && spriteB.itemState == kActive) && (spriteB.itemType == spriteA.itemType)) {
                    toDestroy.push_back(bodyB);
                }else if (spriteA.itemState ==  kWorkspace){
                    //Check if there are any conllisions with a workspace// Add the value of the collision to that workspace. 
                    spriteA.itemValue += spriteB.itemValue;
                    bodyB->SetLinearDamping(kWorkspaceDamping);
                    bodyB->SetAngularDamping(kWorkspaceDamping);
                }else if (spriteB.itemState ==  kWorkspace){
                    spriteB.itemValue += spriteA.itemValue;
                    bodyA->SetLinearDamping(kWorkspaceDamping);
                    bodyA->SetAngularDamping(kWorkspaceDamping);
                }
            }        
        }
        
        // Loop through all of the box2d bodies we wnat to destroy...
        std::vector<b2Body *>::iterator pos2;
        for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
            b2Body *body = *pos2;     
            
            // See if there's any user data attached to the Box2D body
            // There should be, since we set it in addBoxBodyForSprite
            if (body->GetUserData() != NULL) {
                
                //Null the MousePointer
                if (_mouseJoint) {
                    _world->DestroyJoint(_mouseJoint);
                    _mouseJoint = NULL;
                }
                
                // We know that the user data is a sprite since we set
                // it that way, so cast it...
                TokenSprite *sprite = (TokenSprite *) body->GetUserData();
                
                NSLog(@"Destroy %@", sprite.name);
                
                // Remove the sprite from the scene
                [_spriteSheet removeChild:sprite cleanup:YES];
            }
            
            // Destroy the Box2D body as well
            _world->DestroyBody(body);
        }
        
        // If we've destroyed anything, play an amusing and malicious sound effect!  ;]
        if (toDestroy.size() > 0) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"coin-drop-1.caf"];   
        }

    }
}
- (void)draw {
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    //world->DrawDebugData();  // comment this out to get rid of Box2D debug drawing
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
        
        self.isTouchEnabled = YES;

        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  

        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your %@ is displaying the GamePlayLayer", self.device]
                                               fontName:@"Marker Felt" 
                                               fontSize:14]; 
        
        label.position = ccp( screenSize.width/2, 50);  
        
        // Add label to this scene
        [self addChild:label z:0]; 

        //Setup Labels for HUD
        //[menu setPosition:ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height-16)];
        total = [CCLabelTTF labelWithString:@"$0.00" fontName:@"Marker Felt" fontSize:36];
        [total setPosition:ccp(screenSize.width * 0.95, screenSize.height * 0.95)];
        timer = [CCLabelTTF labelWithString:@"00:00" fontName:@"Marker Felt" fontSize:36];        
        [timer setPosition:ccp(screenSize.width * 0.05, screenSize.height * 0.95)];    
        
        [self addChild:total z:50]; 
        [self addChild:timer z:50];
        
        // ** put new code below ** //
        
        /* -- Boilerplate code to set up TRBox2D  -- */
        [self setupPhysicsWorld];
        [self limitWorldToScreen];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin-drop-1.caf"];
        
        /* -- Set Up Shape Cache  -- */
        //[[GB2ShapeCache sharedShapeCache]  addShapesWithFile:@"Sprites-Physics.plist"];
        
        /* -- Set Up Sprite Cache  -- */
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        //CCSpriteBatchNode *sprites = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];
        //[self addChild:sprites];
        
        /* -- Create Box2D Body with CCSprite userdata  -- */
        //TRBox2D *newBody = [TRBox2D spriteWithSpriteFrameName:@"NinjaBaby.png"]; 
        
        //[newBody setPosition:ccp((screenSize.width/2), (screenSize.height/2))];
        /*
        [newBody createBodyInWorld:_world 
                        b2bodyType:b2_dynamicBody 
                             angle:0.0 
                        allowSleep:true 
                     fixedRotation:false 
                            bullet:false];
        */
        /* -- Add fixtures to Physics Object -- */
        //[[GB2ShapeCache sharedShapeCache] addFixturesToBody:newBody.body forShapeName:@"NinjaBaby"];
       
        /*  // to add a circle fixture instead, comment out the line above
        b2CircleShape circle;
        circle.m_radius = 1.0; // radius in meters 
        [newBody addFixtureOfShape:&circle 
                          friction:1.0 
                       restitution:1.0 
                           density:1.0 
                          isSensor:false];
        */
        //[self addChild:newBody];
        
        // Create our sprite sheet and frame cache
        _spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:@"CoinImages128.png" capacity:2] retain];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CoinImages128.plist"];
        [self addChild:_spriteSheet z:0 tag:0];
        
        
        /*
        // Create b2 world
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        bool doSleep = false;
        _world = new b2World(gravity, doSleep);
        
        // Enable debug draw
        _debugDraw = new GLESDebugDraw( PTM_RATIO );
        _world->SetDebugDraw(_debugDraw);
        
        uint32 flags = 0;
        flags += b2DebugDraw::e_shapeBit;
        _debugDraw->SetFlags(flags);
        */
        // Create contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        // Preload effect
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"hahaha.caf"];
        /*
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        b2FixtureDef groundBoxDef;
        groundBoxDef.shape = &groundBox;
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO, 0));
        _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, screenSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(0, screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO, 
                                                                           screenSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO, screenSize.height/PTM_RATIO), 
                            b2Vec2(screenSize.width/PTM_RATIO, 0));
        _groundBody->CreateFixture(&groundBoxDef);        
        */
        //Spawn Stacks
        
        //Item Types should derive for dictionary of gameobjects (same as image) name, but enumerated
    
        tokenDictionary = [[NSMutableDictionary alloc] init];
        workspaceDictionary = [[NSMutableDictionary alloc] init];
        
        TokenData* tokenData = [[TokenData alloc] initWithName:@"quarter" imageSize:128 itemPosition:CGPointMake(200, 650)];
        TokenData* tokenData1 = [[TokenData alloc] initWithName:@"dime" imageSize:128 itemPosition:CGPointMake(200, 500)];
        TokenData* tokenData2 = [[TokenData alloc] initWithName:@"penny" imageSize:128 itemPosition:CGPointMake(200, 200)];
        TokenData* tokenData3 = [[TokenData alloc] initWithName:@"nickel" imageSize:128 itemPosition:CGPointMake(200, 350)];
        
        [tokenDictionary setObject:tokenData forKey:tokenData.name];
        [tokenDictionary setObject:tokenData1 forKey:tokenData1.name];
        [tokenDictionary setObject:tokenData2 forKey:tokenData2.name];
        [tokenDictionary setObject:tokenData3 forKey:tokenData3.name];
        
        TokenData* workspaceData = [[TokenData alloc] initWithName:@"TrayTop" imageSize:128 itemPosition:CGPointMake(600, 600)];
    
        [workspaceDictionary setObject:workspaceData forKey:workspaceData.name];

        //Create the SpawnStacks
        for(id key in [tokenDictionary allKeys]){
            id value = [tokenDictionary objectForKey:key];
            [self spawnSpriteFromToken:value state:kSpawnStack];
        }
        
        //Create the Workspaces
        for(id key in [workspaceDictionary allKeys]){
            id value = [workspaceDictionary objectForKey:key];
            [self spawnSpriteFromToken:value state:kWorkspace];
        }
        
        //Create the Create the First Spawned Token on each stak
        for(id key in [tokenDictionary allKeys]){
            id value = [tokenDictionary objectForKey:key];
            [self spawnSpriteFromToken:value state:kSpawend];
        }
        
        
        /*
        [self spawnSpriteFromToken:tokenData state:kSpawnStack];
        [self spawnSpriteFromToken:tokenData1 state:kSpawnStack];
        [self spawnSpriteFromToken:tokenData2 state:kSpawnStack];
        [self spawnSpriteFromToken:tokenData3 state:kSpawnStack];
        
        
        [self spawnSpriteFromToken:tokenData state:kSpawend];
        [self spawnSpriteFromToken:tokenData1 state:kSpawend];
        [self spawnSpriteFromToken:tokenData2 state:kSpawend];
        [self spawnSpriteFromToken:tokenData3 state:kSpawend];
        */
        


        [tokenData release];
        [tokenData1 release];
        [tokenData2 release];
        [tokenData3 release];

        // schedule Box2D updates
        [self schedule: @selector(tick:)];
        
        [self createPauseButton];
        [self createPausedMenu];
        // ** put new code above ** //                            
    }
    return self;
}

#pragma mark - Touch Handling

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    
    // Loop through all of the Box2D bodies in our Box2D world..
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        
        
        // See if there's any user data attached to the Box2D body
        // There should be, since we set it in addBoxBodyForSprite
        
        if (b->GetUserData() != NULL) {            
            // We know that the user data is a sprite since we set
            // it that way, so cast it...
            
            TokenSprite *sprite = (TokenSprite *)b->GetUserData();
            
            if(sprite.itemState == kSpawnStack || sprite.itemState == kWorkspace) return;
            
            for(b2Fixture *fixture = b->GetFixtureList(); fixture; fixture=fixture->GetNext()) {
                
                if(fixture->TestPoint(locationWorld)){
                    //NSLog(@"Touched itemType %d", sprite.itemType);
                    b2MouseJointDef md;
                    md.bodyA = _groundBody;
                    md.bodyB = b;
                    md.target = locationWorld;
                    md.collideConnected = true;
                    md.maxForce = 1000.0f * b->GetMass();
                    
                    _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
                    b->SetAwake(true);
                }else{
                    //NSLog(@"NOT TOUCHED");
                }
            }
        }
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
        
        //Check for any dangling mouse joints
        if(_world->GetJointCount() > 0){
            //NSLog(@"Found %d Extra Joints", _world->GetJointCount() );
            for(b2Joint *b = _world->GetJointList(); b; b=b->GetNext()) {
                //NSLog(@"Destproying the Dangling Joint");
                //Should check type first
                if(b){
                    _world->DestroyJoint(b);
                    b = NULL;
                    return;
                }
            }
        }
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
        
        //Check for any dangling mouse joints
        if(_world->GetJointCount() > 0){
            //NSLog(@"Found %d Extra Joints", _world->GetJointCount() );
            for(b2Joint *b = _world->GetJointList(); b; b=b->GetNext()) {
                //NSLog(@"Destproying the Dangling Joint");
                //Should check type first
                if(b){
                    _world->DestroyJoint(b);
                    b = NULL;
                    return;
                }
            }
        }
    }  
}


- (void)dealloc {
    
    _mouseJoint = NULL;
    _groundBody = NULL;
    delete _world;
    delete _debugDraw;
    delete _contactListener;
    [_spriteSheet release];
    [tokenDictionary release];
    
    [super dealloc];
}

@end
