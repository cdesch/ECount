//
//  TRBox2DObject.m
//
//  Tim Roadley's Box2D Object
//
//  License : share and share alike, no charge
//

#import "TRBox2DObject.h"

@implementation TRBox2DObject
@synthesize objectType = _objectType;

- (id)init
{
    self = [super init];
    if (self) {
        self.objectType = kObjectNone;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
