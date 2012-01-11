//
//  ChapterSelect.m
//  

#import "ChapterSelect.h"  
#import "CCScrollLayer.h"
#import "Chapter.h"
//#import "Chapters.h"
#import "ChapterParser.h"
#import "GameData.h"
#import "GameDataParser.h"


@implementation ChapterSelect
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goMainMenu];
}

- (void)onSelectChapter:(CCMenuItemImage *)sender { 
    
    //CCLOG(@"writing the selected stage to GameData.xml as %i", sender.tag);
    GameData *gameData = [GameDataParser loadData];
    [gameData setSelectedChapter:sender.tag];
    [GameDataParser saveData:gameData];    
    [SceneManager goLevelSelect];
}

- (CCLayer*)layerWithChapterName:(NSString*)chapterName 
                   chapterNumber:(int)chapterNumber 
                      screenSize:(CGSize)screenSize {

    CCLayer *layer = [[[CCLayer alloc] init] autorelease]; // FIX MEMORY LEAK
    
    if (self.iPad) {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"StickyNote-iPad.png" 
                                                        selectedImage:@"StickyNote-iPad.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];
    }
    else {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"StickyNote-iPhone.png" 
                                                        selectedImage:@"StickyNote-iPhone.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        [layer addChild: menu];    
    }
    
    // Put a label in the new layer based on the passed chapterName
    int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleLarge;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Marker Felt" fontSize:largeFont];
    layerLabel.position =  ccp( screenSize.width / 2 , screenSize.height / 2 + 10 );
    layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95,58,0);
    [layer addChild:layerLabel];
    
    return layer;
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
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;  

        NSMutableArray *layers = [NSMutableArray new];

        NSMutableArray *chapters = [ChapterParser loadData];
        
        for (Chapter *chapter in chapters) { //for (Chapter *chapter in chapters.chapters) {
            // Create a layer for each of the stages found in Chapters.xml
            CCLayer *layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        
        
        // Set up the swipe-able layers
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers 
                                                            widthOffset:230];

        
        GameData *gameData = [GameDataParser loadData];
        [scroller selectPage:(gameData.selectedChapter -1)];
        
        [self addChild:scroller];
        
        [scroller release];
        [layers release];
        
        [self addBackButton];  

    }
    return self;
}



@end
