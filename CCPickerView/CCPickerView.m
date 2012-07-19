//
//  CCPickerView.m
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright (c) 2012 fidgetware. All rights reserved.
//

#import "CCPickerView.h"

@implementation CCPickerView
@synthesize dataSource;
@synthesize delegate;
@synthesize numberOfComponents;

-(id) init {
	if ((self=[super init])) {
        repeatNodes = YES;
	}
    
	return self;
}

-(void)initialLoad {
    CGSize size = [delegate sizeOfPickerView:self];
    CGFloat spacing = [delegate spaceBetweenComponents:self];
    
    self.contentSize = size;
    
    CCSprite* background;
    background = [CCSprite node];
    background.color = ccWHITE;
    background.textureRect = CGRectMake(0, 0, size.width-spacing, size.height-spacing);
    [self addChild:background];
    
    CCNode *overlayImage = [delegate overlayImage:self];
    [self addChild:overlayImage z:10];
    
    rect = CGRectMake(self.position.x - size.width/2, self.position.y - size.height/2, size.width, size.height);
    
    [self reloadAllComponents];    
}

-(void)setDelegate:(id<CCPickerViewDelegate>)newDelegate {
    delegate = newDelegate;
    
    if (dataSource != nil) {
        [self initialLoad];
    }
}

-(void)setDataSource:(id<CCPickerViewDataSource>)newDataSource {
    dataSource = newDataSource;
    
    if (delegate != nil) {
        [self initialLoad];
    }
}

- (void)autoRepeatNodes:(BOOL)repeat {
    repeatNodes = repeat;
    [self reloadAllComponents];
}

- (void)spinComponent:(NSInteger)component speed:(float)speed easeRate:(float)rate repeat:(NSInteger)repeat stopRow:(NSInteger)row {
    if (repeatNodes) {
        ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
        [scrollLayer spin:speed rate:rate repeat:repeat stopPage:row];
    } else {
        CCLOG(@"You need to turn on autoRepeatNodes");
    }
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
    
    return [scrollLayer.arrayPages count];
}

- (void)reloadAllComponents {
    for (int c = 0; c < [dataSource numberOfComponentsInPickerView:self]; c++) {
        [self reloadComponent:c];
    }
}

- (void)reloadComponent:(NSInteger)component {
    NSInteger numComponents = [dataSource numberOfComponentsInPickerView:self];
    CGFloat componentsWidth = 0;
    NSInteger pickerStart = 0;
    CGFloat spacing = [delegate spaceBetweenComponents:self];

    [self removeChildByTag:component cleanup:YES];
    
    ScrollLayer *scrollLayer = [ScrollLayer node];
    scrollLayer.delegate = self;
    
    for (int i = 0; i < numComponents; i++) {
        componentsWidth += [delegate pickerView:self widthForComponent:i];
    }
    
    componentsWidth += (numComponents-1)*spacing;

    pickerStart = -componentsWidth/2;
    for (int c = 0; c < component; c++) {
        CGSize componentSize = CGSizeMake([delegate pickerView:self widthForComponent:c], [delegate pickerView:self rowHeightForComponent:c]);
        pickerStart += componentSize.width + spacing;
    }

    CGSize componentSize = CGSizeMake([delegate pickerView:self widthForComponent:component], [delegate pickerView:self rowHeightForComponent:component]);

    scrollLayer.contentSize = componentSize;
    scrollLayer.position = ccp(pickerStart+componentSize.width/2, 0);
        
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSInteger pageSize = [dataSource pickerView:self numberOfRowsInComponent:component];
    
    // Duplicate the nodes if we have repeatNodes on.
    int numPages = repeatNodes?3:1;
    
    for (int r = 0; r < numPages; r++) {
        for (int p = 0; p < pageSize; p++) {
            [array addObject:[delegate pickerView:self nodeForRow:p forComponent:component reusingNode:nil]];
        }
    }
    
    scrollLayer.arrayPages = array;
    scrollLayer.pageSize = pageSize;
    [scrollLayer setCurrentPage:0];
    scrollLayer.touchSize = CGSizeMake(componentSize.width, self.contentSize.height);
    [scrollLayer makePages];
        
    [self addChild:scrollLayer z:0 tag:component];
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
    
    return scrollLayer.contentSize;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
    
    return scrollLayer.currentPage;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
    [scrollLayer setCurrentPage:row];    
}

- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component {
    ScrollLayer *scrollLayer = (ScrollLayer *)[self getChildByTag:component];
    
    return [scrollLayer getChildByTag:row];
}

//http://www.cocos2d-iphone.org/forum/topic/10270
- (void) visit {
	if (!self.visible)
		return;
    
	glPushMatrix();
    
	glEnable(GL_SCISSOR_TEST);
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    
    CGRect scissorRect = rect;
    
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
    
    // Original code scaled and then rotated.  You need to rotate then scale.
	scissorRect = CGRectMake( scissorRect.origin.x * CC_CONTENT_SCALE_FACTOR(),
                             scissorRect.origin.y* CC_CONTENT_SCALE_FACTOR(),
                             scissorRect.size.width* CC_CONTENT_SCALE_FACTOR(),
                             (scissorRect.size.height)* CC_CONTENT_SCALE_FACTOR() );
    
	glScissor(scissorRect.origin.x, scissorRect.origin.y,
			  scissorRect.size.width, scissorRect.size.height);
    
	[super visit];
    
	glDisable(GL_SCISSOR_TEST);
	glPopMatrix();
}

#pragma mark - ScrollLayerDelegate
-(void)onDoneSelecting:(ScrollLayer *)scrollLayer {
    if ([delegate respondsToSelector:@selector(pickerView: didSelectRow: inComponent:)]) {
        [delegate pickerView:self didSelectRow:scrollLayer.currentPage inComponent:scrollLayer.tag];
    }
}

-(void)onDoneSpinning:(ScrollLayer *)scrollLayer {
    if ([delegate respondsToSelector:@selector(onDoneSpinning: component:)]) {
        [delegate onDoneSpinning:self component:scrollLayer.tag];
    }
}

@end

