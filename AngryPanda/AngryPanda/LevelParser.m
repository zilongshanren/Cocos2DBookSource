//
//  LevelParser.m
//

#import "LevelParser.h"
#import "Levels.h"
#import "Level.h"
#import "GDataXMLNode.h"

@implementation LevelParser

+ (NSString *)dataFilePath:(BOOL)forSave forChapter:(int)chapter {
  
  NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i",chapter];
  
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

+ (Levels *)loadLevelsForChapter:(int)chapter {
  
  /***************************************************************************
   This loadData method is used to load data from the xml file
   specified in the dataFilePath method above.
   
   MODIFY the list of variables below which will be used to create
   and return an instance of TemplateData at the end of this method.
   ***************************************************************************/
  
  NSString *name;
  int number;
  BOOL unlocked;
  int stars;
  NSString *data;
  BOOL levelClear;
  
  
  
  Levels *levels = [[[Levels alloc] init] autorelease];
  
  // Create NSData instance from xml in filePath
  NSString *filePath = [self dataFilePath:FALSE forChapter:chapter];
  NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
  NSError *error;
  GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
  if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
  NSLog(@"Loading %@", filePath);
  
  /***************************************************************************
   This next line will usually have the most customisation applied because
   it will be a direct reflection of what you want out of the XML file.
   ***************************************************************************/
  
  NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
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
    NSArray *starsArray = [element elementsForName:@"Stars"];
    NSArray *dataArray= [element elementsForName:@"Data"];
    NSArray *levelClearArray = [element elementsForName:@"LevelClear"];
    
    
    
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
    
    // stars
    if (starsArray.count > 0) {
      GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
      stars = [[starsElement stringValue] intValue];
    }
    
    // data
    if (dataArray.count > 0) {
      GDataXMLElement *dataElement = (GDataXMLElement *) [dataArray objectAtIndex:0];
      data = [dataElement stringValue];
    }
    
    //levelClear
    if(levelClearArray.count >0){
      GDataXMLElement *levelClearElement = (GDataXMLElement*)[levelClearArray objectAtIndex:0];
      levelClear = [[levelClearElement stringValue]boolValue];
    }
    
    
    
    
    
    
    Level *level = [[Level alloc] initWithName:name number:number unlocked:unlocked stars:stars data:data levelClear:levelClear];
    
    [levels.levels addObject:level];
  }
  
  [doc release];
  [xmlData release];
  return levels;
}

+ (void)saveData:(Levels *)saveData
      forChapter:(int)chapter {
  
  
  /***************************************************************************
   This method writes data to the xml based on a TemplateData instance
   You will have to be very aware of the intended xml contents and structure
   as you will be wiping and re-writing the whole xml file.
   
   We write an xml by creating elements and adding 'children' to them.
   
   You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
   ***************************************************************************/
  
  // create the <Levels> element
  GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];
  
  // Loop through levels found in the levels array
  for (Level *level in saveData.levels) {
    
    // create the <Level> element
    GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];
    
    // create the <Name> element
    GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name"
                                                     stringValue:level.name];
    // create the <Number> element
    GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number"
                                                       stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
    // create the <Unlocked> element
    GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked"
                                                         stringValue:[[NSNumber numberWithBool:level.unlocked] stringValue]];
    // create the <Stars> element
    GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars"
                                                      stringValue:[[NSNumber numberWithInt:level.stars] stringValue]];
    // create the <Data> element
    GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data"
                                                     stringValue:level.data];
    
    //create the <LevelClear> element
    GDataXMLElement *levelClearElement = [GDataXMLNode elementWithName:@"LevelClear" stringValue:[[NSNumber numberWithInt:level.levelClear]stringValue]];
    
    
    
    // enclose variable elements into a <Level> element
    [levelElement addChild:nameElement];
    [levelElement addChild:numberElement];
    [levelElement addChild:unlockedElement];
    [levelElement addChild:starsElement];
    [levelElement addChild:dataElement];
    [levelElement addChild:levelClearElement];
    
    // enclose each <Level> into the <Levels> element
    [levelsElement addChild:levelElement];
  }
  
  // put the <Levels> element (and everything in it) into the XML doc
  GDataXMLDocument *document = [[[GDataXMLDocument alloc]
                                 initWithRootElement:levelsElement] autorelease];
  
  NSData *xmlData = document.XMLData;
  
  // overwrite the existing file, being sure to overwrite the proper chapter
  NSString *filePath = [self dataFilePath:TRUE forChapter:chapter];
  NSLog(@"Saving data to %@...", filePath);
  [xmlData writeToFile:filePath atomically:YES];
}

@end