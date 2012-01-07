//
//  TokenData.h
//  ECount
//
//  Created by Chris Desch on 1/7/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenData : NSObject   {
    
    float       itemValue;
    int         itemType;
    NSString*   imageName;
    NSString*   name;
    CGPoint     itemPosition;
}

@property(nonatomic, readwrite) float       itemValue;
@property(nonatomic, readwrite) int         itemType;
@property(nonatomic, retain) NSString*      imageName;
@property(nonatomic, retain) NSString*      name;
@property(nonatomic, readwrite) CGPoint     itemPosition;

@end
