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
@synthesize delegate;

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
    [delegate onDoneSelecting:self];
    
    CCLOG(@"ended %f %f", world.position.x, world.position.y);    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	isTouching = NO;
	[self moveToPagePosition];
}

-(int) currentPage {
 
    // Always return a value in the first page.
    int retVal = currentPage % pageSize;
    CCLOG(@"currentPage %d, retVal %d", currentPage, retVal);
	return retVal;
}

-(void) setCurrentPage:(int)a {
    
    // If arrayPages is bigger than pageSize+1 then we must have duplicate records to enable a continuous display, so change the value to be on the second set of values.
    if (pageSize != [arrayPages count]) {
            a += pageSize;
    } else {
        // We do not have a continue display so make sure that we are within the range.
        if (a < 0) {
            a = 0;
        }
        
        if (a > pageSize-1) {
            a = pageSize-1;
        }
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
	CCLOG(@"positionNow %f, diff[%f]",positionNow.y, diffY);
	
    CCFiniteTimeAction *moveAction = nil;
    CCFiniteTimeAction *instantAction = nil;
	if (diffY > 0) {
		moveAction = [CCMoveTo actionWithDuration:(0.2 * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * currentPage)];
	}
    
    // If arrayPages is bigger than pageSize+1 then we must have duplicate records to enable a continuous display, so change the value to be on the second set of values.
     if (pageSize != [arrayPages count]) {
        // Make sure we have not moved too far for the continuous display.  If so we want to move back to the second set of values, but without the user seeing the change.
        if (currentPage >= pageSize*2) {
            currentPage -= pageSize;
            instantAction = [CCMoveTo actionWithDuration:0 position:ccp(-s.width /2, -s.height/2 - s.height * currentPage)];
        }

        if (currentPage < pageSize) {
            currentPage += pageSize;
            instantAction = [CCMoveTo actionWithDuration:0 position:ccp(-s.width /2, -s.height/2 - s.height * currentPage)];
        }
     }
    
    id sequence = [CCSequence actions:moveAction, instantAction, nil];
    if (sequence) {
        [world runAction:sequence];
    }
}

-(void)spin:(float)speed rate:(float)rate repeat:(NSInteger )repeat stopPage:(NSInteger) page {
    CGPoint positionNow = world.position;
	CGSize s = self.contentSize;
    
    speed = 1.0/speed;
    
	float diffY = fabs( (positionNow.y) - (-s.height /2 -s.height * pageSize * 2.0));
    
    // Move to end of the second set of pages for the first time.
    CCFiniteTimeAction *firstMoveToPageEndAction = [CCMoveTo actionWithDuration:(speed * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * pageSize * 2.0)];    
    
    // Move to the begining of the second set of pages, the user will not see this action.
    CCFiniteTimeAction *moveToPageStartAction = [CCMoveTo actionWithDuration:0 position:ccp(-s.width /2, -s.height/2 - s.height * pageSize)];
	
    // Move from the begining of the second set of pages to the end of the second set of pages.
    diffY = fabs( (-s.height /2 -s.height * pageSize) - (-s.height /2 -s.height * pageSize * 2.0));
    CCFiniteTimeAction *moveToPageEndAction = [CCMoveTo actionWithDuration:(speed * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * pageSize * 2.0)];    

    // Move from the begining of the second set of pages to the final page, in the second set of pages.
    diffY = fabs( (-s.height /2 -s.height * pageSize) - (-s.height /2 -s.height * (page+pageSize)));
    CCFiniteTimeAction *moveToFinalPageAction = [CCMoveTo actionWithDuration:(speed * diffY / s.height)  position:ccp(-s.width /2, -s.height/2 - s.height * (page+pageSize))];    

    id sRepeat = [CCRepeat actionWithAction:[CCSequence actions:moveToPageStartAction, moveToPageEndAction, nil] times:repeat];
    
    id doneSpinning  = [CCCallFunc actionWithTarget:self selector:@selector(onDoneSpinning)];
    
    id action = [CCEaseInOut actionWithAction:[CCSequence actions:firstMoveToPageEndAction, sRepeat, moveToPageStartAction, moveToFinalPageAction, doneSpinning, nil] rate:rate];
    [world runAction:action];
    
    currentPage = page+pageSize;
}

-(void)onDoneSpinning {
    [delegate onDoneSpinning:self];
}

@end
