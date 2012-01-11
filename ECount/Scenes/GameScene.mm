//
//  GameScene.m
//  

#import "GameScene.h" 
#import "GameData.h"
#import "GameDataParser.h"
#import "LevelParser.h"
#import "Level.h"
#import "GameBackgroundLayer.h"
#import "GamePlayLayer.h"


@implementation GameScene  
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
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
        
        // Add background to this scene
        GameBackgroundLayer *gameBackgroundLayer = [GameBackgroundLayer node];
        [self addChild:gameBackgroundLayer z:-10];
        
        // Add the gameplay layer to this scene
        GamePlayLayer *gamePlayLayer = [GamePlayLayer node];
        [self addChild:gamePlayLayer z:-9];
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 
        
        GameData *gameData = [GameDataParser loadData];
        
        int selectedChapter = gameData.selectedChapter;
        int selectedLevel = gameData.selectedLevel;
        
        NSMutableArray *levels = [LevelParser loadLevelsForChapter:selectedChapter];
        
        for (Level *level in levels) {
            if (level.number == selectedLevel) {
                
                NSString *data = [NSString stringWithFormat:@"%@",level.data];
                
                CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                       fontName:@"Marker Felt" 
                                                       fontSize:largeFont]; 
                label.position = ccp( screenSize.width/2, screenSize.height/2);  
                
                // Add label to this scene
                [self addChild:label z:0]; 
            }
        }

        //  Put a 'back' button in the scene
        //[self addBackButton];   

    }
    return self;
}

@end
