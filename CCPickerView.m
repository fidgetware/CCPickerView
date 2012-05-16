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
@synthesize pickers;
@synthesize numberOfComponents;
@synthesize showsSelectionIndicator;

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
    
    return -1;
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
    NSLog(@"Not implemented %@", _cmd);    
}

- (CCNode *)nodeForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"Not implemented %@", _cmd);
    
    return nil;
}

@end

