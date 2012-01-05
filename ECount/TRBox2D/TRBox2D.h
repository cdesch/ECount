//
//  TRBox2D.h v0.3
//
//  Tim Roadley's Box2D Object Creator
//
//  License : share and share alike, no charge
//

#import "cocos2d.h"
#import "Box2D.h"
#import "TRBox2DObject.h"
#import "GB2ShapeCache.h" // so the user does not have to import it

@interface TRBox2D : TRBox2DObject {

    b2Body *body;

    b2Fixture *fixture;  // multiples?

    b2RevoluteJoint *revoluteJoint;
    b2PrismaticJoint *prismaticJoint;
    b2DistanceJoint *distanceJoint;
    b2MouseJoint *mouseJoint;
    
}

- (void)createEdgesForWorld:(b2World*)world
             fromScreenSize:(CGSize)screenSize;

- (void)createBodyInWorld:(b2World*)world 
               b2bodyType:(b2BodyType)b2bodyType
                    angle:(float)angle
               allowSleep:(bool)allowSleep
            fixedRotation:(bool)fixedRotation
                   bullet:(bool)bullet;

- (void)addFixtureOfShape:(b2Shape*)shape
                 friction:(float)friction
              restitution:(float)restitution
                  density:(float)density
                 isSensor:(bool)isSensor;

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
                        upperAngle:(float)upperAngle;

- (void)createPrismaticJointInWorld:(b2World*)world 
                              bodyA:(b2Body*)bodyA 
                              bodyB:(b2Body*)bodyB 
                             anchor:(b2Vec2)anchor 
                               axis:(b2Vec2)axis 
                   lowerTranslation:(float)lowerTranslation 
                   upperTranslation:(float)upperTranslation;

- (void)createDistanceJointInWorld:(b2World*)world 
                             bodyA:(b2Body*)bodyA 
                             bodyB:(b2Body*)bodyB 
                           anchorA:(b2Vec2)anchorA 
                           anchorB:(b2Vec2)anchorB;

- (void)createMouseJointInWorld:(b2World*)world 
                     groundBody:(b2Body*)groundBody
                         target:(b2Vec2)target 
                       maxForce:(float32)maxForce;

- (void)setMotorSpeed:(float32)speed;
- (void)setLinearVelocity:(b2Vec2)velocity;
- (void)applyLinearImpulse:(b2Vec2)impulse;
- (void)applyForce:(b2Vec2)force atPoint:(b2Vec2)point;

- (void)destroyBodyInWorld:(b2World*)world;

@property (nonatomic, readwrite) b2Body *body;
@property (nonatomic, readwrite) b2Fixture *fixture;
@property (nonatomic, readwrite) b2RevoluteJoint *revoluteJoint;
@property (nonatomic, readwrite) b2PrismaticJoint *prismaticJoint;
@property (nonatomic, readwrite) b2DistanceJoint *distanceJoint;
@property (nonatomic, readwrite) b2MouseJoint *mouseJoint;

@end
