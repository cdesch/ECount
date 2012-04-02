//
//  TemplateData.h  <-- RENAME TemplateData 
//

#import <Foundation/Foundation.h>

@interface TemplateData : NSObject {  // <-- RENAME TemplateData

    // Declare variables with an underscore in front, for example:
    int _exampleInt;
    BOOL _exampleBool;
    NSString *_exampleString;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, assign) int exampleInt;
@property (nonatomic, assign) BOOL exampleBool;
@property (nonatomic, copy) NSString *exampleString;
   
// Put your custom init method interface here:
-(id)initWithExampleInt:(int)exampleInt 
            exampleBool:(BOOL)exampleBool 
          exampleString:(NSString*)exampleString;

@end
