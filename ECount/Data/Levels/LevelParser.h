//
//  LevelParser.h
//

#import <Foundation/Foundation.h>

//@class Levels;

@interface LevelParser : NSObject {}

+ (NSMutableArray *)loadLevelsForChapter:(int)chapter;
+ (void)saveData:(NSMutableArray *)saveData 
      forChapter:(int)chapter;

@end
