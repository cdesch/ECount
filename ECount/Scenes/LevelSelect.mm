//
//  LevelSelect.m
//  

#import "LevelSelect.h"
#import "Level.h"
#import "LevelParser.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "Chapter.h"
#import "ChapterParser.h"

@implementation LevelSelect  
@synthesize iPad, device;

- (void) onPlay: (CCMenuItemImage*) sender {

 // the selected level is determined by the tag in the menu item 
    int selectedLevel = sender.tag;
    
 // store the selected level in GameData
    GameData *gameData = [GameDataParser loadData];
    gameData.selectedLevel = selectedLevel;
    [GameDataParser saveData:gameData];
    
 // load the game scene
    [SceneManager goGameScene];
}

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goChapterSelect];
}

- (void)addBackButton {

    NSString *normal = [NSString stringWithFormat:@"60-x-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"60-x-%@.png", self.device];                        
    CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal 
                                                     selectedImage:selected
                                                            target:self 
                                                          selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
     
    if (self.iPad) {
        back.position = ccp(64, 64);
    
    }
    else {
        back.position = ccp(32, 32);
    }
    
    [self addChild:back];        
}

- (id)init {
    
    if( (self=[super init])) {
        
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }

        int smallFont = [CCDirector sharedDirector].winSize.height / kFontScaleSmall;   
        
     // read in selected chapter number:
        GameData *gameData = [GameDataParser loadData];
        int selectedChapter = gameData.selectedChapter;
        
        
     // Read in selected chapter name (use to load custom background later):
        NSString *selectedChapterName = nil;        
        NSMutableArray *selectedChapters = [ChapterParser loadData]; //Chapters *selectedChapters = [ChapterParser loadData];

        for (Chapter *chapter in selectedChapters) {            //for (Chapter *chapter in selectedChapters.chapters) {            
            if ([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter) {
                CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
                selectedChapterName = chapter.name;
            }
        }
        
        
     // Read in selected chapter levels
        CCMenu *levelMenu = [CCMenu menuWithItems: nil]; 
        NSMutableArray *overlay = [NSMutableArray new];
        
        NSMutableArray *selectedLevels = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
    
        
     // Create a button for every level
        for (Level *level in selectedLevels) {
            
            NSString *normal =   [NSString stringWithFormat:@"%@-Normal-%@.png", selectedChapterName, self.device];
            NSString *selected = [NSString stringWithFormat:@"%@-Selected-%@.png", selectedChapterName, self.device];

            CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage:normal
                                                           selectedImage:selected
                                                                  target:self 
                                                                selector:@selector(onPlay:)];
            [item setTag:level.number]; // note the number in a tag for later usage
            [item setIsEnabled:level.unlocked];  // ensure locked levels are inaccessible
            [levelMenu addChild:item];
            
            if (!level.unlocked) {
                
                NSString *overlayImage = [NSString stringWithFormat:@"Locked-%@.png", self.device];
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }
            else {
                
                NSString *stars = [[NSNumber numberWithInt:level.stars] stringValue];
                NSString *overlayImage = [NSString stringWithFormat:@"%@Star-Normal-%@.png",stars, self.device];
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }

        }

        [levelMenu alignItemsInColumns:
          [NSNumber numberWithInt:6],
          [NSNumber numberWithInt:6],
          [NSNumber numberWithInt:6],
          nil];

     // Move the whole menu up by a small percentage so it doesn't overlap the back button
        CGPoint newPosition = levelMenu.position;
        newPosition.y = newPosition.y + (newPosition.y / 10);
        [levelMenu setPosition:newPosition];
        
        [self addChild:levelMenu z:-3];


     // Create layers for star/padlock overlays & level number labels
        CCLayer *overlays = [[CCLayer alloc] init];
        CCLayer *labels = [[CCLayer alloc] init];

        
        for (CCMenuItem *item in levelMenu.children) {

         // create a label for every level
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",item.tag] 
                                                        fontName:@"Marker Felt" 
                                                        fontSize:smallFont];
            
            [label setAnchorPoint:item.anchorPoint];
            [label setPosition:item.position];
            [labels addChild:label];
            
            
         // set position of overlay sprites
         
            for (CCSprite *overlaySprite in overlay) {
                if (overlaySprite.tag == item.tag) {
                    [overlaySprite setAnchorPoint:item.anchorPoint];
                    [overlaySprite setPosition:item.position];
                    [overlays addChild:overlaySprite];
                }
            }
        }
        
     // Put the overlays and labels layers on the screen at the same position as the levelMenu
        
        [overlays setAnchorPoint:levelMenu.anchorPoint];
        [labels setAnchorPoint:levelMenu.anchorPoint];
        [overlays setPosition:levelMenu.position];
        [labels setPosition:levelMenu.position];
        [self addChild:overlays];
        [self addChild:labels];
        [overlays release];
        [labels release];
        [overlay release]; // FIX MEMORY LEAK
        
     // Add back button
        
        [self addBackButton]; 
    }
    return self;
}

@end
