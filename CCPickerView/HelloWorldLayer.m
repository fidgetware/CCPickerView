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
@synthesize feedbackLabel0;
@synthesize feedbackLabel1;
@synthesize feedbackLabel2;

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
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
        self.pickerView = [CCPickerView node];
        pickerView.position = ccp(size.width*0.25 ,size.height/2);
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        // If you do not want the nodes repeated uncomment the line below.
//        [pickerView autoRepeatNodes:NO];
		[self addChild:self.pickerView];        
        
        feedbackLabel0 = [CCLabelTTF labelWithString:@"Component 0 Stopped " fontName:@"Helvetica" fontSize:16];
        feedbackLabel1 = [CCLabelTTF labelWithString:@"Component 1 Stopped " fontName:@"Helvetica" fontSize:16];
        feedbackLabel2 = [CCLabelTTF labelWithString:@"Component 2 Stopped " fontName:@"Helvetica" fontSize:16];
        feedbackLabel0.color = ccc3(255, 255, 255);
        feedbackLabel1.color = ccc3(255, 255, 255);
        feedbackLabel2.color = ccc3(255, 255, 255);

		feedbackLabel0.position =  ccp( size.width *0.8 , size.height*0.90 );
		feedbackLabel1.position =  ccp( size.width *0.8 , size.height*0.85 );
		feedbackLabel2.position =  ccp( size.width *0.8 , size.height*0.80);
		
		[self addChild: feedbackLabel0];
		[self addChild: feedbackLabel1];
		[self addChild: feedbackLabel2];
        
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
    
    int stopRow0 = arc4random() % 10;
    int stopRow1 = arc4random() % 10;
    int stopRow2 = arc4random() % 10;

    // Change the easeRate, speed, repeat and stopRow for the desired spin effect.
    // Seems like there is a bug with EaseInOut so use an integer value for easeRate.
    [pickerView spinComponent:0 speed:15 easeRate:1 repeat:4 stopRow:stopRow0];
    [pickerView spinComponent:1 speed:15 easeRate:1 repeat:4 stopRow:stopRow1];
    [pickerView spinComponent:2 speed:15 easeRate:1 repeat:4 stopRow:stopRow2];

    [feedbackLabel0 setString:@"Component 0 Spinning"];
    [feedbackLabel1 setString:@"Component 1 Spinning"];
    [feedbackLabel2 setString:@"Component 2 Spinning"];
    feedbackLabel0.color = ccc3(255, 0, 0);
    feedbackLabel1.color = ccc3(255, 0, 0);
    feedbackLabel2.color = ccc3(255, 0, 0);
}

-(void)spinPickerSlow {
    
    int stopRow0 = arc4random() % 10;
    int stopRow1 = arc4random() % 10;
    int stopRow2 = arc4random() % 10;
    
    // Change the easeRate, speed, repeat and stopRow for the desired spin effect.
    // Seems like there is a bug with EaseInOut so use an integer value for easeRate.
    [pickerView spinComponent:0 speed:5 easeRate:1.0 repeat:2 stopRow:stopRow0];
    [pickerView spinComponent:1 speed:4 easeRate:1.0 repeat:1 stopRow:stopRow1];
    [pickerView spinComponent:2 speed:1 easeRate:1.0 repeat:0 stopRow:stopRow2];
    
    [feedbackLabel0 setString:@"Component 0 Spinning"];
    [feedbackLabel1 setString:@"Component 1 Spinning"];
    [feedbackLabel2 setString:@"Component 2 Spinning"];
    feedbackLabel0.color = ccc3(255, 0, 0);
    feedbackLabel1.color = ccc3(255, 0, 0);
    feedbackLabel2.color = ccc3(255, 0, 0);
}

-(void)spinPickerEase {
    
    int stopRow0 = arc4random() % 10;
    int stopRow1 = arc4random() % 10;
    int stopRow2 = arc4random() % 10;
    
    // Change the easeRate, speed, repeat and stopRow for the desired spin effect.
    // Seems like there is a bug with EaseInOut so use an integer value for easeRate.
    [pickerView spinComponent:0 speed:10 easeRate:1 repeat:2 stopRow:stopRow0];
    [pickerView spinComponent:1 speed:10 easeRate:2 repeat:2 stopRow:stopRow1];
    [pickerView spinComponent:2 speed:10 easeRate:3 repeat:2 stopRow:stopRow2];
    
    [feedbackLabel0 setString:@"Component 0 Spinning"];
    [feedbackLabel1 setString:@"Component 1 Spinning"];
    [feedbackLabel2 setString:@"Component 2 Spinning"];
    feedbackLabel0.color = ccc3(255, 0, 0);
    feedbackLabel1.color = ccc3(255, 0, 0);
    feedbackLabel2.color = ccc3(255, 0, 0);
}


-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    
    CCLabelTTF *spinLabel = [CCLabelTTF labelWithString:@"Spin" fontName:@"Helvetica" fontSize:32];
    CCMenuItemLabel *menuSpinLabel = [CCMenuItemLabel itemWithLabel:spinLabel target:self selector:@selector(spinPicker)];

    CCLabelTTF *spinSlowLabel = [CCLabelTTF labelWithString:@"Spin Slow" fontName:@"Helvetica" fontSize:32];
    CCMenuItemLabel *menuSpinSlowLabel = [CCMenuItemLabel itemWithLabel:spinSlowLabel target:self selector:@selector(spinPickerSlow)];

    CCLabelTTF *spinEaseLabel = [CCLabelTTF labelWithString:@"Spin Ease" fontName:@"Helvetica" fontSize:32];
    CCMenuItemLabel *menuSpinEaseLabel = [CCMenuItemLabel itemWithLabel:spinEaseLabel target:self selector:@selector(spinPickerEase)];

    CCMenu *mainMenu = [CCMenu menuWithItems:menuSpinLabel, menuSpinSlowLabel, menuSpinEaseLabel, nil];
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

- (void)onDoneSpinning:(CCPickerView *)pickerView component:(NSInteger)component {
    switch (component) {
        case 0: {
            [feedbackLabel0 setString:@"Component 0 Stopped"];
            feedbackLabel0.color = ccc3(255, 255, 255);
            break;
        }
        case 1: {
            [feedbackLabel1 setString:@"Component 1 Stopped"];
            feedbackLabel1.color = ccc3(255, 255, 255);
            break;
        }
        case 2: {
            [feedbackLabel2 setString:@"Component 2 Stopped"];
            feedbackLabel2.color = ccc3(255, 255, 255);
            break;
        }
        default:
            break;
    }

    NSLog(@"Component %d stopped spinning.", component);
}
@end
