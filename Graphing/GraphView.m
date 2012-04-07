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
    CGPoint originPoint = CGPointMake( self.origin.x + rect.size.width / 2.0, self.origin.y + rect.size.height / 2.0);
    
    NSLog(@"GraphView drawRect(%f x %f), at originPoint(%f,%f) with scale of %f", rect.size.width, rect.size.height, originPoint.x, originPoint.y, self.scale);
    
    [AxesDrawer drawAxesInRect: rect originAtPoint: originPoint scale: self.scale];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGPoint midPoint; // center of our bounds in our coordinate system
//    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
//    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];

    CGFloat x = 0;
    
    CGContextMoveToPoint(context, x, [self.datasource yValueFor: x - rect.size.width/2]);

    for (; x < rect.size.width; x++)
        CGContextAddLineToPoint(context, x, rect.size.height / 2.0 - [self.datasource yValueFor:x - rect.size.width/2]);
    
    CGContextStrokePath(context);

}

@end
