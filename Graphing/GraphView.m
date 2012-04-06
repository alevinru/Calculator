//
//  GraphView.m
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView 

@synthesize datasource = _datasource, scale = _scale;

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (CGFloat) scale {
    if (!_scale) {
        _scale = 1;
    }
    
    return _scale;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"GraphView initWithFrame");
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [AxesDrawer drawAxesInRect: rect originAtPoint: CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0) scale: self.scale];
}

@end
