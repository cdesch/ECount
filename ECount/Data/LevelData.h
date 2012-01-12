//
//  LevelData.h
//  ECount
//
//  Created by Chris Desch on 1/9/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelData : NSObject {
    NSString*   _name;
    NSArray*    _tokens;
    NSArray*    _workspaces;

}

@property(nonatomic, retain) NSString*      name;
@property(nonatomic, retain) NSArray*       tokens;
@property(nonatomic, retain) NSArray*       workspaces;

- (id)initWithName:(NSString *)name chapter:(NSString*)chapter;

@end
