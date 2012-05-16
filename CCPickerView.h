//
//  CCPickerView.h
//  CCPickerView
//
//  Created by Mick Lester on 5/16/12.
//  Copyright (c) 2012 fidgetware. All rights reserved.
//

#import "CCLayer.h"

@protocol CCPickerViewDataSource;
@protocol CCPickerViewDelegate;

@interface CCPickerView : CCLayer {
    id <CCPickerViewDataSource> dataSource;
    id <CCPickerViewDelegate> delegate;
    NSMutableArray *pickers;
    CGFloat width;
    CGFloat height;
    CGRect rect;
}
@property (nonatomic, assign) id <CCPickerViewDataSource> dataSource;
@property (nonatomic, assign) id <CCPickerViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *pickers;

@property(nonatomic, readonly) NSInteger numberOfComponents;
@property(nonatomic) BOOL showsSelectionIndicator;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (CGSize)rowSizeForComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component;
@end

@protocol CCPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(CCPickerView *)pickerView;
- (NSInteger)pickerView:(CCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end

@protocol CCPickerViewDelegate
- (CGFloat)pickerView:(CCPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (CGFloat)pickerView:(CCPickerView *)pickerView widthForComponent:(NSInteger)component;
- (NSString *)pickerView:(CCPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)pickerView:(CCPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingNode:(CCNode *)view;
- (void)pickerView:(CCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
