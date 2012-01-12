//
//  LevelData.m
//  ECount
//
//  Created by Chris Desch on 1/9/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "LevelData.h"

@implementation LevelData

//name is levelName
@synthesize name = _name;
@synthesize tokens = _tokens;
@synthesize workspaces = _workspaces;

- (id)initWithName:(NSString *)name chapter:(NSString*)chapter{
    
	if((self=[super init])){
        self.name = name;  
        
        //Get the Object properties from the token's plist
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LevelsData-Chapter%@",chapter] ofType:@"plist"];
        NSDictionary *tokensDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *objectDict = [[NSDictionary alloc] initWithDictionary:[tokensDict objectForKey:self.name]];
        
        //Assign the values from the object dictionary
        self.tokens  = [[NSArray alloc] initWithArray:[objectDict objectForKey:@"tokens"]]; 
        self.workspaces =  [[NSArray alloc] initWithArray:[objectDict objectForKey:@"workspaces"]];
        
	}
    
	return self;
}



- (void)dealloc{
    
    [_name release];
    [_tokens release];
    [_workspaces release];
    
    [super dealloc];
}


@end
