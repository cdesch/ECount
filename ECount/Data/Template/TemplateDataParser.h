//
//  TemplateDataParser.h  <-- RENAME TemplateDataParser
//

#import <Foundation/Foundation.h>

@class TemplateData;  // <-- RENAME TemplateData (NOT to parser)

@interface TemplateDataParser : NSObject {}  // <-- RENAME TemplateDataParser

+ (TemplateData *)loadData;  // <-- RENAME TemplateData
+ (void)saveData:(TemplateData *)saveData;  // <-- RENAME TemplateData

@end