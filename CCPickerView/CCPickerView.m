//
//  CCPickerView.m
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright (c) 2012 fidgetware. All rights reserved.
//

#import "CCPickerView.h"
#import "ScrollLayer.h"
#import "Scale9Sprite.h"

@implementation CCPickerView
@synthesize dataSource;
@synthesize delegate;
@synthesize scrollLayers;
@synthesize numberOfComponents;

-(id) init {
	if ((self=[super init])) {
	}
    
	return self;
}

-(void)loadData {
    NSInteger numComponents = [dataSource numberOfComponentsInPickerView:self];
    CGFloat componentsWidth = 0;
    NSInteger pickerStart = 0;
    CGSize size = [delegate sizeOfPickerView:self];
    CGFloat spacing = [delegate spaceBetweenComponents:self];

    CCSprite* background;
    background = [CCSprite node];
    background.color = ccWHITE;
    background.textureRect = CGRectMake(0, 0, size.width-spacing, size.height-spacing);
    [self addChild:background];
    
    for (int i = 0; i < numComponents; i++) {
        componentsWidth += [delegate pickerView:self widthForComponent:i];
    }
    
    componentsWidth += (numComponents-1)*spacing;
    
    self.contentSize = size;
    
    if (!scrollLayers) {
        scrollLayers = [[NSMutableArray alloc] initWithCapacity:numComponents];
        
        pickerStart = -componentsWidth/2;
        for (int c = 0; c < numComponents; c++) {
            ScrollLayer *scrollLayer = [ScrollLayer node];
            CGSize componentSize = CGSizeMake([delegate pickerView:self widthForComponent:c], [delegate pickerView:self rowHeightForComponent:c]);
            scrollLayer.contentSize = componentSize;
            scrollLayer.position = ccp(pickerStart+componentSize.width/2, 0);
            pickerStart += componentSize.width + spacing;
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
            NSInteger pageSize = [dataSource pickerView:self numberOfRowsInComponent:c];
                        
            for (int p = 0; p < pageSize; p++) {
                [array addObject:[delegate pickerView:self nodeForRow:p forComponent:c reusingNode:nil]];
            }
            scrollLayer.arrayPages = array;
            scrollLayer.pageSize = pageSize-1;
            [scrollLayer setCurrentPage:0];
            scrollLayer.touchSize = CGSizeMake(componentSize.width, self.contentSize.height);
            [scrollLayer makePages];
            
            [self addChild:scrollLayer];            
            [scrollLayers addObject:scrollLayer];
        }
    }

    CCNode *overlayImage = [delegate overlayImage:self];
    [self addChild:overlayImage];
    
    rect = CGRectMake(self.position.x - size.width/2, self.position.y - size.height/2, size.width, size.height);        
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = [scrollLayers objectAtIndex:component];
    
    return [scrollLayer.arrayPages count];
}

- (void)reloadAllComponents {
    NSLog(@"Not implemented %@", _cmd);    
}

- (void)reloadComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
    
    return CGSizeMake(0, 0);
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
    
    return -1;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    ScrollLayer *scrollLayer = [scrollLayers objectAtIndex:component];
    [scrollLayer setCurrentPage:row];    
}

- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
    
    return nil;
}

//http://www.cocos2d-iphone.org/forum/topic/10270
- (void) visit {
	if (!self.visible)
		return;
    
	glPushMatrix();
    
	glEnable(GL_SCISSOR_TEST);
    
	CGSize size = [[CCDirector sharedDirector] winSize];
	CGRect scissorRect = CGRectMake( rect.origin.x * CC_CONTENT_SCALE_FACTOR(),
                                    rect.origin.y* CC_CONTENT_SCALE_FACTOR(),
                                    rect.size.width* CC_CONTENT_SCALE_FACTOR(),
                                    (rect.size.height)* CC_CONTENT_SCALE_FACTOR() );
    
	// transform the clipping rectangle to adjust to the current screen
	// orientation: the rectangle that has to be passed into glScissor is
	// always based on the coordinate system as if the device was held with the
	// home button at the bottom. the transformations account for different
	// device orientations and adjust the clipping rectangle to what the user
	// expects to happen.
	ccDeviceOrientation orientation = [[CCDirector sharedDirector] deviceOrientation];
	switch (orientation) {
		case kCCDeviceOrientationPortrait:
			break;
		case kCCDeviceOrientationPortraitUpsideDown:
			scissorRect.origin.x = size.width-scissorRect.size.width-scissorRect.origin.x;
			scissorRect.origin.y = size.height-scissorRect.size.height-scissorRect.origin.y;
			break;
		case kCCDeviceOrientationLandscapeLeft:
		{
			float tmp = scissorRect.origin.x;
			scissorRect.origin.x = scissorRect.origin.y;
			scissorRect.origin.y = size.width-scissorRect.size.width-tmp;
			tmp = scissorRect.size.width;
			scissorRect.size.width = scissorRect.size.height;
			scissorRect.size.height = tmp;
		}
			break;
		case kCCDeviceOrientationLandscapeRight:
		{
			float tmp = scissorRect.origin.y;
			scissorRect.origin.y = scissorRect.origin.x;
			scissorRect.origin.x = size.height-scissorRect.size.height-tmp;
			tmp = scissorRect.size.width;
			scissorRect.size.width = scissorRect.size.height;
			scissorRect.size.height = tmp;
		}
			break;
	}
    
	glScissor(scissorRect.origin.x, scissorRect.origin.y,
			  scissorRect.size.width, scissorRect.size.height);
    
	[super visit];
    
	glDisable(GL_SCISSOR_TEST);
	glPopMatrix();
}

@end

