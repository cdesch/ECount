//
//  MainMenu.m
//  

#import "MainMenu.h"  
#import "GameData.h"
#import "GameDataParser.h"

@implementation MainMenu
@synthesize iPad, device;

- (void)onPlay: (id) sender {
    [SceneManager goChapterSelect];
}

- (void)onOptions: (id) sender {
    [SceneManager goOptionsMenu];
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

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 

        // Set font settings
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:largeFont];
        
        // Create font based items ready for CCMenu
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlay:)];
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(onOptions:)];

        // Add font based items to CCMenu
        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];

        // Align the menu 
        [menu alignItemsVertically];

        // Add the menu to the scene
        [self addChild:menu];
        
        // Testing GameData
        /*
        GameData *gameData = [GameDataParser loadData];

        CCLOG(@"Read from XML 'Selected Chapter' = %i", gameData.selectedChapter);
        CCLOG(@"Read from XML 'Selected Level' = %i", gameData.selectedLevel);
        CCLOG(@"Read from XML 'Music' = %i", gameData.music);
        CCLOG(@"Read from XML 'Sound' = %i", gameData.sound);
        
        gameData.selectedChapter = 7;
        gameData.selectedLevel = 4;
        gameData.music = 0;
        gameData.sound = 0;
        
        [GameDataParser saveData:gameData];
        */
    }
    return self;
}

@end
