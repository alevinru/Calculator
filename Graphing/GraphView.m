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

@synthesize datasource = _datasource, scale = _scale, origin = _origin;

- (void)setOrigin:(CGPoint) newOrigin
{
    if (!CGPointEqualToPoint(newOrigin, _origin)) {
        _origin = newOrigin;
        [self setNeedsDisplay];
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (CGFloat) scale {
    return _scale? _scale: (_scale = 1);
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
    [AxesDrawer drawAxesInRect: rect originAtPoint: CGPointMake( self.origin.x + rect.size.width / 2.0, self.origin.y + rect.size.height / 2.0) scale: self.scale];
}

@end
