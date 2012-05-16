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
@synthesize scrollLayer;

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
        
        self.scrollLayer = [ScrollLayer node];
		self.scrollLayer.contentSize = CGSizeMake(50, 50);
		self.scrollLayer.position = ccp( size.width /2 , size.height/2 );
        //		self.scrollLayer.pageSize = 5;
		NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
		CCSprite* temp;
		temp = [CCSprite node];
		temp.color = ccYELLOW;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
		temp = [CCSprite node];
		temp.color = ccBLUE;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
		temp = [CCSprite node];
		temp.color = ccWHITE;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
		temp = [CCSprite node];
		temp.color = ccRED;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
		temp = [CCSprite node];
		temp.color = ccGREEN;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
        temp = [CCSprite node];
		temp.color = ccMAGENTA;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
        temp = [CCSprite node];
		temp.color = ccORANGE;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
        temp = [CCSprite node];
		temp.color = ccGRAY;
		temp.textureRect = CGRectMake(0, 0, 50, 50);
		[array addObject:temp];
        
		scrollLayer.arrayPages = array;
		scrollLayer.pageSize = 8;
		scrollLayer.currentPage = 2;
		[scrollLayer makePages];
		[self addChild:self.scrollLayer];
        
		

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
@end
