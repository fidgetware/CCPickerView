//
//  ScrollLayer.m
//  scrollmenu
//
//  Created by Tomohisa Takaoka on 11/9/10.
//  Copyright 2010 Systom. All rights reserved.
//
// https://github.com/tomohisa/scrollmenu
//
// Modifed by Mick Lester on 5/19/2012
// Copyright (c) 2012 fidgetware. All rights reserved.
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
@synthesize touchSize;

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
	world.contentSize = CGSizeMake(s.width, s.height);
	for (int i=0; i < [arrayPages count]; i++) {
		CCNode* n = [arrayPages objectAtIndex:i];
		n.position = ccp(s.width / 2, s.height / 2 + i * s.height);
		[world addChild:n];
	}
	//world.anchorPoint = ccp(0,0);
	world.position = ccp(-s.width/2, -s.height/2 -s.height * currentPage);
	[self addChild:world];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = CGRectMake(-touchSize.width, -self.contentSize.height/2 - touchSize.height/2, touchSize.width, touchSize.height);
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
    CCLOG(@"moved %f %f", world.position.x, world.position.y);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint n = [self convertTouchToNodeSpaceAR:touch];    
    int pagesToMove = round((n.y - touchStartedPoint.y) / self.contentSize.height);
    
    if (!didMove) {
        if (n.y < -self.contentSize.height) {
            pagesToMove = 1;
        }
        if (n.y > 0) {
            pagesToMove = -1;
        }
    }
    didMove = NO;
    
    self.currentPage = self.currentPage - pagesToMove;
	isTouching = NO;
    CCLOG(@"ended %f %f", world.position.x, world.position.y);    
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

-(void)spin {
    currentPage = [arrayPages count]-1;

    CGPoint positionNow = world.position;
	CGSize s = self.contentSize;
	float diffY = fabs( (positionNow.y) - (-s.height /2 -s.height * currentPage) );
    //	CCLOG(@"diff[%f]",diffX);
	

    CCFiniteTimeAction *moveAction = [CCMoveTo actionWithDuration:(0.2 * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * currentPage)];
    CCFiniteTimeAction *zeroAction = [CCMoveTo actionWithDuration:0 position:ccp(-s.width /2, -s.height/2)];
    
    id action = [CCRepeatForever actionWithAction:[CCSequence actions:moveAction, zeroAction, nil]];
    
    [world runAction:action];
}

@end
