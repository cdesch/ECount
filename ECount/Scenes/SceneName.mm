//
//  SceneName.m  <-- RENAME THIS
//  

#import "SceneName.h"  // <-- RENAME THIS

@implementation SceneName  // <-- RENAME THIS
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    //[SceneManager goMainMenu];
}

- (void)addBackButton {
    
 // Create a menu image button using an image specific to iPad or iPhone
    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];        
    CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal 
                                                     selectedImage:selected
                                                            target:self 
                                                          selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
 // Position menu in the bottom left of the screen (0,0 starts bottom left)
    if (self.iPad) {
        back.position = ccp(64, 64);
        
    }
    else {
        back.position = ccp(32, 32);
    }
 // Add menu to this scene
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
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"New Scene"    // <-- RENAME THIS
                                               fontName:@"Marker Felt" 
                                               fontSize:largeFont];  
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height/2);  
        
        // Add label to this scene
		[self addChild:label z:0]; 

        //  Put a 'back' button in the scene
        [self addBackButton];   

    }
    return self;
}

@end
