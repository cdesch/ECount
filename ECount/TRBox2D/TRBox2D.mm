//
//  TRBox2D.mm v0.3 (two m's because it's supports Objective-C and also C++ code)
//
//  Tim Roadley's Box2D Object Creator
//
//  License : share and share alike, no charge
//

#import "TRBox2D.h"
#import "TRBox2DConstants.h"

@implementation TRBox2D
@synthesize body, fixture;
@synthesize revoluteJoint, prismaticJoint, distanceJoint, mouseJoint;

- (id) init {
	if ((self = [super init])) {
        self.objectType = kObjectNone;
	}
	return self;
}

- (void)createEdgesForWorld:(b2World*)world
             fromScreenSize:(CGSize)screenSize {
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    
    self.body = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundBox;		
    
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
    self.body->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
    self.body->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
    self.body->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
    
    self.body->CreateFixture(&groundBox,0);
}

- (void)createBodyInWorld:(b2World*)world 
               b2bodyType:(b2BodyType)b2bodyType
                    angle:(float)angle
               allowSleep:(bool)allowSleep
            fixedRotation:(bool)fixedRotation
                   bullet:(bool)bullet {

    b2BodyDef bodyDef;
    bodyDef.type = b2bodyType;
    bodyDef.angle = angle;
    bodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    bodyDef.allowSleep = allowSleep;
    bodyDef.fixedRotation = fixedRotation;
    bodyDef.bullet = bullet;
    bodyDef.userData = self;   
    
	self.body = world->CreateBody(&bodyDef);
}

- (void)addFixtureOfShape:(b2Shape*)shape
                 friction:(float)friction
              restitution:(float)restitution
                  density:(float)density
                 isSensor:(bool)isSensor {

    b2FixtureDef fixtureDef;
    fixtureDef.shape = shape;	
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;
    fixtureDef.density = density;
    fixtureDef.isSensor = isSensor;
    
    self.fixture = self.body->CreateFixture(&fixtureDef);
}

- (void)createRevoluteJointInWorld:(b2World*)world 
                             bodyA:(b2Body*)bodyA 
                             bodyB:(b2Body*)bodyB 
                      localAnchorA:(b2Vec2)localAnchorA 
                      localAnchorB:(b2Vec2)localAnchorB  
                       enableMotor:(BOOL)enableMotor 
                    maxMotorTorque:(float)maxMotorTorque 
                        motorSpeed:(float)motorSpeed 
                       enableLimit:(BOOL)enableLimit 
                        lowerAngle:(float)lowerAngle 
                        upperAngle:(float)upperAngle {
	
    b2RevoluteJointDef jointDef;  
    jointDef.Initialize(bodyA, bodyB, bodyA->GetWorldCenter());
    jointDef.bodyA = bodyA;
    jointDef.bodyB = bodyB;
    jointDef.localAnchorA = localAnchorA;
    jointDef.localAnchorB = localAnchorB;
    jointDef.enableMotor = enableMotor;
    jointDef.maxMotorTorque = maxMotorTorque;
    jointDef.motorSpeed = motorSpeed;
    jointDef.enableLimit = enableLimit;
    jointDef.lowerAngle = lowerAngle;
    jointDef.upperAngle = upperAngle;
    
    self.revoluteJoint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);
}

- (void)createPrismaticJointInWorld:(b2World*)world 
                              bodyA:(b2Body*)bodyA 
                              bodyB:(b2Body*)bodyB 
                             anchor:(b2Vec2)anchor 
                               axis:(b2Vec2)axis 
                   lowerTranslation:(float)lowerTranslation 
                   upperTranslation:(float)upperTranslation {
    
    b2PrismaticJointDef jointDef;
    jointDef.Initialize(bodyA, bodyB, anchor, axis);
    jointDef.enableLimit = true;
    jointDef.lowerTranslation = lowerTranslation;
    jointDef.upperTranslation = upperTranslation;
    jointDef.referenceAngle = 0;
    
    self.distanceJoint = (b2DistanceJoint*)world->CreateJoint(&jointDef);
}

- (void)createDistanceJointInWorld:(b2World*)world 
                             bodyA:(b2Body*)bodyA 
                             bodyB:(b2Body*)bodyB 
                           anchorA:(b2Vec2)anchorA 
                           anchorB:(b2Vec2)anchorB {
    
    b2DistanceJointDef jointDef;
    jointDef.Initialize(bodyA, bodyB, anchorA, anchorB);

    self.distanceJoint = (b2DistanceJoint*)world->CreateJoint(&jointDef);
}

- (void)createMouseJointInWorld:(b2World*)world 
                     groundBody:(b2Body*)groundBody
                         target:(b2Vec2)target 
                       maxForce:(float32)maxForce {
    
    b2MouseJointDef mouseJointDef;
    
    mouseJointDef.bodyA = groundBody;  // The groundBody passed from the call of this method.
    mouseJointDef.bodyB = self.body;  // The body you're moving, ie this one.
    mouseJointDef.target = target; // The destination you're moving bodyB to
    mouseJointDef.collideConnected = true; // ensures whatever you hit, collides normally.
    mouseJointDef.maxForce = maxForce * body->GetMass();  // about 1000.0 is good
    
    self.mouseJoint = (b2MouseJoint*)world->CreateJoint(&mouseJointDef);
    
    self.body->SetAwake(true);
}

- (void)setMotorSpeed:(float32)speed {
    self.revoluteJoint->SetMotorSpeed(speed);   
}
- (void)setLinearVelocity:(b2Vec2)velocity {
    self.body->SetLinearVelocity(velocity);
}
- (void)applyLinearImpulse:(b2Vec2)impulse {
    self.body->ApplyLinearImpulse(impulse, body->GetWorldCenter());
}
-(void) applyForce:(b2Vec2)force atPoint:(b2Vec2)point {
    body->ApplyForce(force, point);
}
- (void)destroyBodyInWorld:(b2World*)world {    
    self.body->SetUserData(nil);
    world->DestroyBody(self.body);
}
- (void)dealloc {
    [super dealloc];
}

@end
