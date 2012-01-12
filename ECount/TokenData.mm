//
//  TokenData.m
//  ECount
//
//  Created by Chris Desch on 1/7/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "TokenData.h"

#define PTM_RATIO 32

@implementation TokenData 

@synthesize name = _name;
@synthesize imageName = _imageName;
@synthesize itemPosition = _itemPosition;
@synthesize itemValue = _itemValue;
@synthesize itemType = _itemType;
@synthesize imageSize = _imageSize;
@synthesize vertices = _vertices;
@synthesize radius = _radius;

- (id)initWithName:(NSString *)name 
         imageName:(NSString *)imageName
         imageSize:(int)imageSize
      itemPosition:(CGPoint)itemPosition{
    
	if((self=[super init])){
        
        //Initialize the object parameters
        self.name = name;  
        self.imageSize = imageSize;
        self.itemPosition = itemPosition;
        self.imageName = [NSString stringWithString:[imageName stringByAppendingString:@".png"]];
        
        //Get the Object properties from the token's plist
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Tokens" ofType:@"plist"];
        NSDictionary *tokensDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *objectDict = [[NSDictionary alloc] initWithDictionary:[tokensDict objectForKey:self.name]];
                            
        //Assign the values from the object dictionary
        self.itemType  = [[objectDict objectForKey:@"itemType"] intValue];
        self.itemValue = [[objectDict objectForKey:@"itemValue"] floatValue];
        
        if ([objectDict objectForKey:@"radius"] != nil){
            self.radius = [[objectDict objectForKey:@"radius"] floatValue];    
        }
        
        
        
        /*
        //build the vertices list for collision detection based on what image size the image is
        NSArray* vertList = [objectDict objectForKey:[NSString stringWithFormat:@"%d",imageSize]];
        
        int const num = [vertList count];
        int i = 0;
        b2Vec2* _verts;
        _verts = new b2Vec2[num];
        //b2Vec2& _verts[num];
        for(NSDictionary* vert in vertList){
            float x = [[vert objectForKey:@"x"] floatValue];
            float y = [[vert objectForKey:@"y"] floatValue];
            _verts[i] = b2Vec2( round(x) / PTM_RATIO, round(y)  / PTM_RATIO);
            i++;
            NSLog(@"i: %d %f %f" , i,round(x) ,round(y));

        }
        NSLog(@"%d",num);
        
        //////
        
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

        //self.vertices = [[NSArray alloc] initWithObjects:[NSData dataWithBytes:&verts length:sizeof(verts)], [NSNumber numberWithInt:8],nil] ;
        self.vertices = [[NSArray alloc] initWithObjects:[NSData dataWithBytes:_verts length:sizeof(_verts)], [NSNumber numberWithInt:num],nil] ;
        //self.vertices = [[NSArray alloc] initWithObjects:[NSData dataWithBytes:&verts length:sizeof(verts)*2], [NSNumber numberWithInt:num],nil] ;
*/
        
	}
    
	return self;
}
/*
- (NSArray*)getVerts{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Tokens" ofType:@"plist"];
    NSDictionary *tokensDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *objectDictionary = [[NSDictionary alloc] initWithDictionary:[tokensDictionary objectForKey:self.name];
    
    //Get from file
    //token
    int const num = 8;
    b2Vec2 verts[num];
    verts[0] = b2Vec2(-3.5f / PTM_RATIO, 51.7f / PTM_RATIO),
    verts[1] = b2Vec2(-41.7f / PTM_RATIO, 30.5f / PTM_RATIO);
    verts[2] = b2Vec2(-50.7f / PTM_RATIO, -2.0f / PTM_RATIO);
    verts[3] = b2Vec2(-40.0f / PTM_RATIO, -31.5f / PTM_RATIO);
    verts[4] = b2Vec2(-9.7f / PTM_RATIO, -49.0f / PTM_RATIO);
    verts[5] = b2Vec2(30.2f / PTM_RATIO, -39.2f / PTM_RATIO);
    verts[6] = b2Vec2(47.7f / PTM_RATIO, 5.5f / PTM_RATIO);
    verts[7] = b2Vec2(23.0f / PTM_RATIO, 43.7f / PTM_RATIO);
    
    NSArray* vertices = [[[NSArray alloc] initWithObjects:[NSData dataWithBytes:&verts length:sizeof(verts)], [NSNumber numberWithInt:num],nil] autorelease];
    
    //[vertices addObject:[NSData dataWithBytes:verts length:sizeof(b2Vec2)*2]];
    //[vertices addObject:[NSData dataWithBytes:&verts length:sizeof(verts)]];
    //[vertices addObject:[NSNumber numberWithInt:num]];  //Add number of vertices for reference
    
    //return the array
    return vertices;
}*/

- (void)dealloc{

    [_name release];
    [_imageName release];
    [_vertices release];

   [super dealloc];
}

@end
