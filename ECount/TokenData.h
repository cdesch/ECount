//
//  TokenData.h
//  ECount
//
//  Created by Chris Desch on 1/7/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "GLES-Render.h"

@interface TokenData : NSObject   {
    
    NSString*   _name;
    NSString*   _imageName;
    CGPoint     _itemPosition;
    float       _itemValue;
    int         _itemType;
    int         _imageSize;
    NSArray*    _vertices;
    float       _radius;
    
}

@property(nonatomic, retain) NSString*      name;
@property(nonatomic, retain) NSString*      imageName;
@property(nonatomic, readwrite) CGPoint     itemPosition;
@property(nonatomic, readwrite) float       itemValue;
@property(nonatomic, readwrite) int         itemType;
@property(nonatomic, readwrite) int         imageSize;
@property(nonatomic, retain) NSArray*       vertices;
@property(nonatomic, readwrite) float       radius;

- (id)initWithName:(NSString *)name 
         imageSize:(int)imageSize
      itemPosition:(CGPoint)itemPosition;



@end
