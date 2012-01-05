//
//  Level.h
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {

    // Declare variables with an underscore
    NSString *_name;
    int _number;
    BOOL _unlocked;
    int _stars;
    NSString *_data;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;
@property (nonatomic, copy) NSString *data;

// Custom init method interface
- (id)initWithName:(NSString *)name 
            number:(int)number 
          unlocked:(BOOL)unlocked 
             stars:(int)stars 
              data:(NSString *)data;
   


@end
