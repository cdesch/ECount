//
//  WorkspaceData.h
//  ECount
//
//  Created by Chris Desch on 1/12/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "GLES-Render.h"

@interface WorkspaceData : NSObject{
    NSString*   _wsName; //Gives the workspace name
    NSString*   _wsImageName; //Gives the representative image for the workspace
    CGPoint     _wsPosition; //Gives the origin point of the workspace; other verts should be extrapolated from this single point, since we know the object's dimensions
    float       _wsValueContained; //Tracks the accumulated value in a workspace (updates at onTokenEnter and onTokenExit events)
    int         _wsImageSize; //Gives the area of the workspace's image representation
    NSArray*    _wsVertices; //should be able to figure these from itemPosition and           
                           //dimensions, right?
    float       (*_wsDimensions)[2]; //max two dimensions (widthxheight), can be only one dimension (radius)

    //Workspace Specific
    BOOL        _wsObjectiveCompleteFlag; //Set to True  when wsValueContained is equal to the target value, _wsObjective
    float       _wsObjective; //Tracks the current workspace's target wsValueContained value; when this value is met the workspace is 'completed' 
}

@property(nonatomic, retain) NSString*      wsName;
@property(nonatomic, retain) NSString*      wsImageName;
@property(nonatomic, readwrite) CGPoint     wsPosition;
@property(nonatomic, readwrite) float       wsValueContained;
@property(nonatomic, readwrite) int         wsImageSize;
@property(nonatomic, retain) NSArray*       wsVertices;
@property(nonatomic, readwrite) float      (*wsDimensions)[2];

//-(float*) _wsDimensions;
//-(void) set_wsDimensions;

//Workspace Specific
@property(nonatomic, readwrite) BOOL        wsObjectiveCompleteFlag;
@property(nonatomic, readwrite) float       wsObjective; 
- (id)initWithName:(NSString *)name 
         wsImageName:(NSString *)imageName
         wsImageSize:(int)imageSize
      wsPosition:(CGPoint)itemPosition;


@end
