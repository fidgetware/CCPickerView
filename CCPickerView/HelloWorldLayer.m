//
//  HelloWorldLayer.m
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright fidgetware 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize pickerView;

#define kComponentWidth 54
#define kComponentHeight 32
#define kComponentSpacing 10

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        self.pickerView = [CCPickerView node];
        pickerView.position = ccp(size.width/2 ,size.height/2);
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
		[self addChild:self.pickerView];        
        
        [self displayMainMenu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void)spinPicker {
    // Seems like there is a bug with EaseInOut so use an integer value for easeRate.
    [pickerView spinComponent:0 speed:0.1 easeRate:4.0 repeat:5 stopPage:7];
    [pickerView spinComponent:1 speed:0.1 easeRate:3.0 repeat:6 stopPage:0];
    [pickerView spinComponent:2 speed:0.1 easeRate:5.0 repeat:4 stopPage:3];
}

-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
//    if (sceneSelectMenu != nil) {
//        [sceneSelectMenu removeFromParentAndCleanup:YES];
//    }
    // Main Menu
    CCMenuItemImage *playGameButton = [CCMenuItemImage 
                                       itemFromNormalImage:@"PlayGameButtonNormal.png" 
                                       selectedImage:@"PlayGameButtonSelected.png" 
                                       disabledImage:nil 
                                       target:self 
                                       selector:@selector(spinPicker)];
    
//    CCMenuItemImage *buyBookButton = [CCMenuItemImage 
//                                      itemFromNormalImage:@"BuyBookButtonNormal.png" 
//                                      selectedImage:@"BuyBookButtonSelected.png" 
//                                      disabledImage:nil 
//                                      target:self 
//                                      selector:@selector(buyBook)];
//    
//    CCMenuItemImage *optionsButton = [CCMenuItemImage 
//                                      itemFromNormalImage:@"OptionsButtonNormal.png" 
//                                      selectedImage:@"OptionsButtonSelected.png" 
//                                      disabledImage:nil 
//                                      target:self 
//                                      selector:@selector(showOptions)];
    
    CCMenu *mainMenu = [CCMenu menuWithItems:playGameButton, nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition:ccp(screenSize.width * 0.85f, screenSize.height/2.0f)];
    [self addChild:mainMenu z:0 tag:0];
}

#pragma mark - CCPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(CCPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(CCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numRows = 0;
    
    switch (component) {
        case 0:
            numRows = 10;
            break;
        case 1:
            numRows = 10;
            break;
        case 2:
            numRows = 10;
            break;
        default:
            break;
    }
    
    return numRows;
}

#pragma mark - CCPickerViewDelegate
- (CGFloat)pickerView:(CCPickerView *)pickerView rowHeightForComponent:(NSInteger)component {    
    return kComponentHeight;
}

- (CGFloat)pickerView:(CCPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kComponentWidth;
}

- (NSString *)pickerView:(CCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Not used";
}

- (CCNode *)pickerView:(CCPickerView *)pickerView nodeForRow:(NSInteger)row forComponent:(NSInteger)component reusingNode:(CCNode *)node {
    
    CCSprite *temp = [CCSprite node];
    temp.color = ccYELLOW;
    temp.textureRect = CGRectMake(0, 0, kComponentWidth, kComponentHeight);
    
    NSString *rowString = [NSString stringWithFormat:@"%d", row];
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:rowString fntFile:@"bitmapFont.fnt"];
    label.position = ccp(kComponentWidth/2, kComponentHeight/2-5);
    [temp addChild:label];
    
    return temp;
}

- (void)pickerView:(CCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (CGFloat)spaceBetweenComponents:(CCPickerView *)pickerView {
    return kComponentSpacing;
}

- (CGSize)sizeOfPickerView:(CCPickerView *)pickerView {
    CGSize size = CGSizeMake(200, 100);
    
    return size;
}

- (CCNode *)overlayImage:(CCPickerView *)pickerView {
    CCSprite *sprite = [CCSprite spriteWithFile:@"3slots.png"];
    return sprite;
}

@end
