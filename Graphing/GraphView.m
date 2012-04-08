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


- (void) setOrigin: (CGPoint) newOrigin
{
    if (!CGPointEqualToPoint(newOrigin, _origin)) {
        _origin = newOrigin;
        [self setNeedsDisplay];
    }
}


- (void) setScale: (CGFloat) newScale
{
    if (newScale != _scale) {
        _scale = newScale;
        [self setNeedsDisplay];
    }
}


- (void) awakeFromNib
{
    self.contentMode = UIViewContentModeRedraw;
    
    CGPoint defaults = [self.datasource defaultOrigin];
    
    self.origin = CGPointMake(defaults.x, defaults.y);
    self.scale = [self.datasource defaultScale];
}


- (void) drawRect: (CGRect) toBeRedrawn
{
    CGRect rect = self.bounds;
    
    CGPoint originPoint = CGPointMake(self.bounds.size.width/2 + self.origin.x, self.bounds.size.height/2 + self.origin.y);
    
    //NSLog(@"GraphView drawRect(%f x %f), at originPoint(%f,%f) with scale of %f", rect.size.width, rect.size.height, originPoint.x, originPoint.y, self.scale);
    
    [AxesDrawer drawAxesInRect: rect 
                 originAtPoint: originPoint
                         scale: self.scale];

    CGContextRef context = UIGraphicsGetCurrentContext();
        
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];

    CGFloat x = 0;
    
    double (^y) (double) = ^(double x) {
        return originPoint.y - [self.datasource yValueFor: (x - originPoint.x) / self.scale] * self.scale;
    };
    
    CGContextMoveToPoint(context, x, y(x));

    while (x <= rect.size.width)
        CGContextAddLineToPoint(context, x, y(x++));
    
    CGContextStrokePath(context);

}

@end
