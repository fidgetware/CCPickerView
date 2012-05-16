//
//  ScrollLayer.m
//  scrollmenu
//
//  Created by Tomohisa Takaoka on 11/9/10.
//  Copyright 2010 Systom. All rights reserved.
//

#import "ScrollLayer.h"

@interface ScrollLayer()
@property (nonatomic,retain) CCLayer* world;
- (BOOL)containsTouchLocation:(UITouch *)touch;
- (void) moveToPagePosition;
@end


@implementation ScrollLayer
@synthesize pageSize;
@synthesize arrayPages;
@synthesize world;
-(id) init {
	if ((self=[super init])) {
		self.isTouchEnabled = YES;
		isTouching = NO;
	}
    
	return self;
}

- (void)onEnter {
//	CCLOG(@"onEnter");
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit {
//	CCLOG(@"onEnter");
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

-(void)makePages {
	CGSize s = self.contentSize;
//	CCLOG(@"[%f][%f]",s.width,s.height);
//	CCLOG(@"anchorpoint[%f][%f]",self.anchorPoint.x,self.anchorPoint.y);
	self.world = [CCLayer node];
	world.contentSize = CGSizeMake(s.width, s.height * pageSize);
	for (int i=0; i < [arrayPages count]; i++) {
		CCNode* n = [arrayPages objectAtIndex:i];
		n.position = ccp(s.width / 2, s.height / 2 + i * s.height);
		[world addChild:n];
	}
	//world.anchorPoint = ccp(0,0);
	world.position = ccp(-s.width /2, -s.height/2 -s.height * currentPage);
	[self addChild:world];
	
    rect = CGRectMake(self.position.x - s.width/2, self.position.y - s.height/2*3, s.width, s.height*3);
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = CGRectMake(-self.contentSize.width, -self.contentSize.height / 2*3, self.contentSize.width, self.contentSize.height*3);
	return CGRectContainsPoint(r, p);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (isTouching) return NO;
	if ( ![self containsTouchLocation:touch] ) return NO;
	isTouching = YES;
	touchStartedPoint = [self convertTouchToNodeSpaceAR:touch];
	touchStartedWorldPosition = world.position;
	CCLOG(@"touch handle");
	return YES;
	
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    didMove = YES;
	CGPoint n = [self convertTouchToNodeSpaceAR:touch];
	world.position = ccp(touchStartedWorldPosition.x, touchStartedWorldPosition.y + n.y - touchStartedPoint.y);
    NSLog(@"moved");
	
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint n = [self convertTouchToNodeSpaceAR:touch];    
    int pagesToMove = round((n.y - touchStartedPoint.y) / 50.0);
    
    if (!didMove) {
        if (n.y < -50/2) {
            pagesToMove = 1;
        }
        if (n.y > 50/2) {
            pagesToMove = -1;
        }
    }
    didMove = NO;
    
    self.currentPage = self.currentPage - pagesToMove;
	isTouching = NO;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	isTouching = NO;
	[self moveToPagePosition];
}

-(int) currentPage {
	return currentPage;
}

-(void) setCurrentPage:(int)a {
    if (a < 0) {
        a = 0;
    }
    if (a > pageSize) {
        a = pageSize;
    }
    
    currentPage = a;
    
	if (world) {
		[self moveToPagePosition];
	}
	
}
- (void) moveToPagePosition {
	CGPoint positionNow = world.position;
	CGSize s = self.contentSize;
	float diffY = fabs( (positionNow.y) - (-s.height /2 -s.height * currentPage) );
//	CCLOG(@"diff[%f]",diffX);
	
	if (diffY > 0) {
		id moveTo = [CCMoveTo actionWithDuration:(0.1 * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * currentPage)];
		[world runAction:moveTo];
	}
	
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
