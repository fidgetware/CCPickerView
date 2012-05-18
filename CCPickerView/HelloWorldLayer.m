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
            numRows = 1;
            break;
        case 2:
            numRows = 5;
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
    temp.color = ccWHITE;
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
