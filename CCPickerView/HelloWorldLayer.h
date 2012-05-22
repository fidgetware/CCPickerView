//
//  HelloWorldLayer.h
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright fidgetware 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCPickerView.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <CCPickerViewDataSource, CCPickerViewDelegate>
{
    CCPickerView *pickerView;
    CCLabelTTF *feedbackLabel0;
    CCLabelTTF *feedbackLabel1;
    CCLabelTTF *feedbackLabel2;
}
@property (nonatomic, retain) CCPickerView *pickerView;
@property (nonatomic, retain) CCLabelTTF *feedbackLabel0;
@property (nonatomic, retain) CCLabelTTF *feedbackLabel1;
@property (nonatomic, retain) CCLabelTTF *feedbackLabel2;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
