//
//  TemplateData.m  // <-- RENAME TemplateData
//

#import "TemplateData.h"  // <-- RENAME TemplateData

@implementation TemplateData  // <-- RENAME TemplateData

// Synthesize your variables here, for example: 
@synthesize exampleInt = _exampleInt;
@synthesize exampleBool = _exampleBool;
@synthesize exampleString = _exampleString;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)initWithExampleInt:(int)exampleInt 
            exampleBool:(BOOL)exampleBool 
          exampleString:(NSString*)exampleString {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.exampleInt = exampleInt; 
        self.exampleBool = exampleBool; 
        self.exampleString = exampleString; 
    }
    return self;
}

- (void) dealloc {
    [_exampleString release]; // FIX MEMORY LEAK
    [super dealloc];
}

@end