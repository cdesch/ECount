//
//  HelloWorldLayer.mm
//  ECount
//
//  Created by Chris Desch on 1/4/12.
//  Copyright Desch Enterprises 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "TokenData.h"
#import "TokenSprite.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define kSpriteLevel 2
//Touches

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

typedef enum {
    kActive,
    kSpawend,
    kSpawnStack
} SpriteState;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
/*
- (b2Vec2)getb2Vec2:(TokenData*)token{
  //TODO: Implementation Goes here  
}
*/
- (void)addBoxBodyForSprite:(TokenSprite *)sprite {
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = _world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    /*spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
     sprite.contentSize.height/PTM_RATIO/2);
     */
    if (sprite.tag == 2) {
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
    //spriteShapeDef.friction = 0.4f;
    //spriteShapeDef.restitution = 0.1f;
    if(sprite.itemState == kSpawnStack){
        spriteShapeDef.isSensor = true;
    }else{
        spriteShapeDef.isSensor = false;
    }
    
    
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

- (void)spawnSprite:(NSString*)imageName tag:(NSInteger)tag{
    
    
    /*
    CCSprite *car = [CCSprite spriteWithSpriteFrameName:@"quarter.png"];
    car.position = ccp(555, 555);
    car.tag = tag;
    //car.itemValue = 25.0f;

    [self addBoxBodyForSprite:car];
    
    [_spriteSheet addChild:car z:0 tag:tag];
     */
    
    //TokenSprite *token = [TokenSprite spriteWithSpriteFrame:imageName];
    //token.position = 
    
}

//Spawn a Sprite from a Token Data
- (void)spawnSpriteFromToken:(TokenData*)token isStack:(BOOL)isStack{
    
    TokenSprite *sprite = [TokenSprite spriteWithSpriteFrameName:token.imageName];
    sprite.name = token.name;
    sprite.position = token.itemPosition;
    sprite.itemType = token.itemType;
    
    int state;
    if(isStack){
        state = kSpawnStack;
    }else{
        state = kSpawend;
    }
    
    sprite.itemState = state;
    sprite.tag = token.itemType;        
    [self addBoxBodyForSprite:sprite];
    [_spriteSheet addChild:sprite z:1 tag:token.itemType];
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

        
        // enable touches
		self.isTouchEnabled = YES;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Create our sprite sheet and frame cache
        _spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:@"CoinImages128.png" capacity:2] retain];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CoinImages128.plist"];
        [self addChild:_spriteSheet z:0 tag:0];
        
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
        
        // Create contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        // Preload effect
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"hahaha.caf"];
        
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
        
        //Spawn Stacks
        

        //stackPosition = CGPointMake(555, 555);
        //Item Types should derive for dictionary of gameobjects (same as image) name, but enumerated
        tokenDictionary = [[NSMutableDictionary alloc] init];
        
        TokenData* tokenData = [[TokenData alloc] init];
        tokenData = [[TokenData alloc] init];
        tokenData.name = @"quarter";
        tokenData.imageName = @"quarter.png";
        tokenData.itemPosition = CGPointMake(555, 555);
        tokenData.itemType = 1;
        tokenData.itemValue = 1;

        [tokenDictionary setObject:tokenData forKey:tokenData.name];

        TokenData* tokenData1 = [[TokenData alloc] init];
        tokenData1 = [[TokenData alloc] init];
        tokenData1.name = @"dime";
        tokenData1.imageName = @"dime.png";
        tokenData1.itemPosition = CGPointMake(200, 200);
        tokenData1.itemType = 2;
        tokenData1.itemValue = 1;

        [tokenDictionary setObject:tokenData1 forKey:tokenData1.name];

        [self spawnSpriteFromToken:tokenData isStack:YES];
        [self spawnSpriteFromToken:tokenData1 isStack:YES];
        [self spawnSpriteFromToken:tokenData isStack:NO];
        [self spawnSpriteFromToken:tokenData1 isStack:NO];

        [tokenData1 release];
        [tokenData release];
      
        //[self schedule:@selector(secondUpdate:) interval:1.0];
        [self schedule:@selector(tick:)];
        
	}
	return self;
}


-(void) draw
{
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	_world->DrawDebugData();
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}

- (void)tick:(ccTime)dt {
    
    // Updates the physics simulation for 10 iterations for velocity/position
    _world->Step(dt, 10, 10);
    
    // Loop through all of the Box2D bodies in our Box2D world..
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        
        // See if there's any user data attached to the Box2D body
        // There should be, since we set it in addBoxBodyForSprite
        if (b->GetUserData() != NULL) {            
            
            // We know that the user data is a sprite since we set
            // it that way, so cast it...
            TokenSprite *sprite = (TokenSprite *)b->GetUserData();
            
            // Convert the Cocos2D position/rotation of the sprite to the Box2D position/rotation
            //b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
            //float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            
            // Update the Box2D position/rotation to match the Cocos2D position/rotation

            //b->SetTransform(b2Position, b2Angle);
            
            
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
                                    
                                    //Change the Fixture type 
                                    for(b2Fixture *fixture = c->GetFixtureList(); fixture; fixture=fixture->GetNext()) {
                                        fixture->SetSensor(NO);
                                    }
                                    
                                    //Spawn New Sprite in place
                                    [self spawnSpriteFromToken:[tokenDictionary objectForKey:sprite.name] isStack:NO];
                                    NSLog(@"Spawned %@", sprite.name);
                                    //We are done for now. Return for the next Loop
                                    return;
                                    
                                }
                            }
                        }
                    }
                }
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
            if (spriteA.itemState == kActive && spriteB.itemState == kSpawnStack) {
                toDestroy.push_back(bodyA);
            } 
            // Is sprite A a car and sprite B a cat?  If so, push the cat on a list to be destroyed...
            else if (spriteA.itemState == kSpawnStack && spriteB.itemState == kActive) {
                toDestroy.push_back(bodyB);
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
        //[[SimpleAudioEngine sharedEngine] playEffect:@"hahaha.caf"];   
    }
    
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

            if(sprite.itemState == kSpawnStack) return;

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
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }  
}


/*
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}*/

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = _world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}

- (bool)detectCollision:(CCNode *)obj with:(CCNode*)object2
{
	// Create two rectangles with CGRectMake, using each sprite's x/y position and width/height
	CGRect ownRect = CGRectMake(object2.position.x - (object2.contentSize.width / 2), object2.position.y - (object2.contentSize.height / 2), object2.contentSize.width, object2.contentSize.height);
	CGRect otherRect = CGRectMake(obj.position.x - (obj.contentSize.width / 2), obj.position.y - (obj.contentSize.height / 2), obj.contentSize.width, obj.contentSize.height);
    
	// Feed the results into CGRectIntersectsRect() which tells if the rectangles intersect (obviously)
	return CGRectIntersectsRect(ownRect, otherRect);
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
