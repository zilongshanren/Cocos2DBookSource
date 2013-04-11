//
//  ChapterParser.m
//

#import "ChapterParser.h"
#import "Chapter.h"
#import "Chapters.h"
#import "GDataXMLNode.h"

@implementation ChapterParser

+ (NSString *)dataFilePath:(BOOL)forSave {
  
  NSString *xmlFileName = @"Chapters";
  
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

+ (Chapters *)loadData {
  
  /***************************************************************************
   This loadData method is used to load data from the xml file
   specified in the dataFilePath method above.
   
   MODIFY the list of variables below which will be used to create
   and return an instance of TemplateData at the end of this method.
   ***************************************************************************/
  
  NSString *name;
  int number;
  BOOL unlocked;
  
  
  Chapters *chapters = [[[Chapters alloc] init] autorelease];
  
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
  
  NSArray *dataArray = [doc nodesForXPath:@"//Chapters/Chapter" error:nil];
  NSLog(@"Array Contents = %@", dataArray);
  
  /***************************************************************************
   We use dataArray to populate variables created at the start of this
   method. For each variable you will need to:
   1. Create an array based on the elements in the xml
   2. Assign the variable a value based on data in elements in the xml
   ***************************************************************************/
  
  for (GDataXMLElement *element in dataArray) {
    
    NSArray *nameArray = [element elementsForName:@"Name"];
    NSArray *numberArray = [element elementsForName:@"Number"];
    NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
    
    // name
    if (nameArray.count > 0) {
      GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
      name = [nameElement stringValue];
    }
    
    // number
    if (numberArray.count > 0) {
      GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
      number = [[numberElement stringValue] intValue];
    }
    
    
    // unlocked
    if (unlockedArray.count > 0) {
      GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
      unlocked = [[unlockedElement stringValue] boolValue];
    }
    
    
    Chapter *chapter = [[Chapter alloc] initWithName:name number:number unlocked:unlocked];
    [chapters.chapters addObject:chapter];
  }
  
  [doc release];
  [xmlData release];
  return chapters;
}

@end