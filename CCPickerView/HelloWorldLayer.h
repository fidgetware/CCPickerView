//
//  HelloWorldLayer.h
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright fidgetware 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "ScrollLayer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    ScrollLayer *scrollLayer;
}
@property (nonatomic, retain) ScrollLayer* scrollLayer;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
