//
//  Level.m
//

#import "Level.h"

@implementation Level

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;
@synthesize data = _data;

// Custom init method takes a variable 
// for each class instance variable
- (id)initWithName:(NSString *)name 
            number:(int)number 
          unlocked:(BOOL)unlocked 
             stars:(int)stars 
              data:(NSString *)data {

    if ((self = [super init])) {

        // Set class instance variables based 
        // on values given to this method
        self.name = name;  
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        self.data = data;
    }
    return self;
}

- (void) dealloc {
    [_name release]; // FIX MEMORY LEAK
    [_data release]; // FIX MEMORY LEAK
    [super dealloc];
}

@end