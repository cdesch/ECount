//
//  TRBox2DObject.h
//
//  Tim Roadley's Box2D Object
//
//  License : share and share alike, no charge
//

#import "cocos2d.h"
#import "TRBox2DConstants.h"
#import "GLES-Render.h"

@interface TRBox2DObject : CCSprite {
    ObjectType _objectType;
}

@property (nonatomic, readwrite) ObjectType objectType;

@end
