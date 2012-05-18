//
//  ScrollLayer.h
//  scrollmenu
//
//  Created by Tomohisa Takaoka on 11/9/10.
//  Copyright 2010 Systom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScrollLayer : CCLayer <CCTargetedTouchDelegate>{
	int pageSize;
	int currentPage;
	NSMutableArray* arrayPages;
	CCLayer* world;
    CGSize touchSize;
	CGPoint touchStartedPoint;
	CGPoint touchStartedWorldPosition;
	BOOL isTouching;
    BOOL didMove;
}
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) NSMutableArray* arrayPages;
@property (nonatomic, assign) CGSize touchSize;
-(void)makePages;

@end
