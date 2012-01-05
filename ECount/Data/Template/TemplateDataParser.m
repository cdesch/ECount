//
//  TemplateDataParser.m  <-- RENAME TemplateDataParser
//

#import "TemplateDataParser.h"  // <-- RENAME TemplateDataParser
#import "TemplateData.h"  // <-- RENAME TemplateData
#import "GDataXMLNode.h"

@implementation TemplateDataParser  // <-- RENAME TemplateDataParser

+ (NSString *)dataFilePath:(BOOL)forSave {

    NSString *xmlFileName = @"TemplateData";  // <-- RENAME to XML filename (no extension)
    
    /***************************************************************************
     This method is used to set up the specified xml for reading/writing.
     Specify the name of the XML file you want to work with above.
     You don't have to worry about the rest of the code in this method.
     ***************************************************************************/

    NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;   
        NSLog(@"%@ opened for read/write",documentsPath);
    } else {
        NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
        return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    }    
}

+ (TemplateData *)loadData { // <-- RENAME TemplateData

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    int exampleInt;
    BOOL exampleBool;
    NSString *exampleString;

    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    /*************************************************************************** 
     This next line will usually have the most customisation applied because 
     it will be a direct reflection of what you want out of the XML file.
     ***************************************************************************/
    
    NSArray *dataArray = [doc nodesForXPath:@"//ExampleData" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    /*************************************************************************** 
     We use dataArray to populate variables created at the start of this 
     method. For each variable you will need to:
        1. Create an array based on the elements in the xml
        2. Assign the variable a value based on data in elements in the xml
     ***************************************************************************/
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *exampleIntArray = [element elementsForName:@"ExampleInt"];       
        NSArray *exampleBoolArray = [element elementsForName:@"ExampleBool"];   
        NSArray *exampleStringArray = [element elementsForName:@"ExampleString"];
        
        // exampleInt
        if (exampleIntArray.count > 0) {
            GDataXMLElement *exampleIntElement = (GDataXMLElement *) [exampleIntArray objectAtIndex:0];
            exampleInt = [[exampleIntElement stringValue] intValue];
        } 
   
        // exampleBool    
        if (exampleBoolArray.count > 0) {
            GDataXMLElement *exampleBoolElement = (GDataXMLElement *) [exampleBoolArray objectAtIndex:0];
            exampleBool = [[exampleBoolElement stringValue] boolValue];
        }

        // exampleString
        if (exampleStringArray.count > 0) {
            GDataXMLElement *exampleStringElement = (GDataXMLElement *) [exampleStringArray objectAtIndex:0];
            exampleString = [exampleStringElement stringValue];
        }
    }
    
    /*************************************************************************** 
     Now the variables are populated from xml data we create an instance of
     TemplateData to pass back to whatever called this method.
     
     The initWithExampleInt:exampleBool:exampleString will need to be replaced
     with whatever method you have updaed in the TemplateData class.
     ***************************************************************************/
    
    //NSLog(@"XML value read for exampleInt = %i", exampleInt);
    //NSLog(@"XML value read for exampleBool = %i", exampleBool);
    //NSLog(@"XML value read for exampleString = %@", exampleString);
    
    TemplateData *Data = [[[TemplateData alloc] initWithExampleInt:exampleInt 
                                                      exampleBool:exampleBool 
                                                    exampleString:exampleString] autorelease];  
                                                  
    [doc release];
    [xmlData release];
    return Data;
}

+ (void)saveData:(TemplateData *)saveData {  // <-- RENAME TemplateData
    
   
    /*************************************************************************** 
     This method writes data to the xml based on a TemplateData instance
     You will have to be very aware of the intended xml contents and structure
     as you will be wiping and re-writing the whole xml file.
     
     We write an xml by creating elements and adding 'children' to them.
     
     You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
     ***************************************************************************/
    
    GDataXMLElement *exampleDataElement = [GDataXMLNode elementWithName:@"ExampleData"];
   
    GDataXMLElement *exampleIntElement = [GDataXMLNode elementWithName:@"ExampleInt" 
                                                           stringValue:[[NSNumber numberWithInt:saveData.exampleInt] stringValue]];

    GDataXMLElement *exampleBoolElement = [GDataXMLNode elementWithName:@"ExampleBool"   
                                                            stringValue:[[NSNumber numberWithBool:saveData.exampleBool] stringValue]];
    
    GDataXMLElement *exampleStringElement = [GDataXMLNode elementWithName:@"ExampleString"
                                                              stringValue:saveData.exampleString];   
    
    // Using the elements just created, set up the hierarchy
    [exampleDataElement addChild:exampleIntElement];
    [exampleDataElement addChild:exampleBoolElement];
    [exampleDataElement addChild:exampleStringElement];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:exampleDataElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end