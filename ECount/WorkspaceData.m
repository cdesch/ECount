//
//  WorkspaceData.m
//  ECount
//
//  Created by Chris Desch on 1/7/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "WorkspaceData.h"

@implementation WorkspaceData 

@synthesize itemValue;
@synthesize itemType;
@synthesize imageName;
@synthesize name;
@synthesize itemPosition;

-(id)init{
    
	if((self=[super init])){
        
        //Initialize the object parameters
        itemValue = 0.0;
        itemType = 0;
		
	}
    
	return self;
}

- (void)dealloc{
    name = nil;
    imageName = nil;
    
    [super dealloc];
}

@end
