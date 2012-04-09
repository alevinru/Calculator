//
//  GraphingViewController.m
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingViewController.h"
#import "Processor.h"

@interface GraphingViewController ()

@property (nonatomic, readonly) NSUserDefaults * defaults;

@end

@implementation GraphingViewController

@synthesize titleLabel = _titleLabel;
@synthesize toolbar = _toolbar;
@synthesize graphView = _graphView, program = _program;
@synthesize defaultScale = _defaultScale, defaultOrigin = _defaultOrigin;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void) setProgram:(NSArray *) newProgram {
    if (![newProgram isEqualToArray: _program]) {
        _program = newProgram ? [newProgram copy]: nil;
        [self.graphView setNeedsDisplay];
        [self.titleLabel setText: [Processor descriptionOfProgram: newProgram]];
    }
}

- (NSUserDefaults*) defaults {
    return [NSUserDefaults standardUserDefaults];
}


- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    if (!self.graphView && [self.view isKindOfClass: [GraphView class]])
        self.graphView = (GraphView*) self.view;
    
    if (!self.graphView.datasource)
        self.graphView.datasource = self;
}

- (double) yValueFor:(double)xValue {
    //NSLog(@"GraphingViewController yValyeFor program: %@", [Processor descriptionOfProgram: self.program]);
    return [Processor runProgram: self.program
             usingVariableValues: [NSDictionary dictionaryWithObject: [NSNumber numberWithDouble: xValue] forKey: @"x"]];
}

- (CGFloat) defaultScale {
    CGFloat scale =  [self.defaults doubleForKey: @"defaultScale"];
    
    return scale > 0 ? scale : 1;
    
}

- (void) setDefaultScale: (CGFloat) newScale {
    [self.defaults setDouble: newScale forKey: @"defaultScale"];
}

- (CGPoint) defaultOrigin {
    
    if (!CGPointEqualToPoint(CGPointZero, _defaultOrigin))
        return _defaultOrigin;
    
    NSString * value = [self.defaults valueForKey: @"defaultOrigin"];
    
    _defaultOrigin = (value ? CGPointFromString(value) : CGPointZero);
    
    return _defaultOrigin;

}

- (void) setDefaultOrigin:(CGPoint)defaultOrigin {
    
    _defaultOrigin = defaultOrigin;
    
    [self.defaults setValue: NSStringFromCGPoint(_defaultOrigin)
                                             forKey: @"defaultOrigin"];
}


- (void) viewDidDisappear:(BOOL)animated {
    [self setDefaultScale: self.graphView.scale];
    [self setDefaultOrigin: self.graphView.origin];
    
    [self.defaults synchronize];
    
    NSLog(@"GraphingViewController viewDidDisappear: %@", NSStringFromCGPoint(self.graphView.origin));
    
}


- (void) viewDidUnload
{
    [self setToolbar:nil];
    [super viewDidUnload];

    [self setProgram:nil];

    // Release any retained subviews of the main view.
    
    [self setGraphView:nil];
    [self setTitleLabel:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (IBAction)userDidPinch:(UIPinchGestureRecognizer *) gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.graphView.scale *= gesture.scale;
        //NSLog(@"Pinched: %f %f", self.graphView.scale, gesture.scale );
        gesture.scale =1.0;
    }
}

- (IBAction)userDidPan:(UIPanGestureRecognizer *) gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
        [self.graphView setOrigin: CGPointMake(self.graphView.origin.x + translation.x, self.graphView.origin.y + translation.y)];
        [gesture setTranslation: CGPointZero inView: self.graphView];
    }
}

- (IBAction)userDidTap:(UITapGestureRecognizer *) gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        [self.graphView setOrigin: CGPointApplyAffineTransform([gesture locationInView: self.graphView], CGAffineTransformMakeTranslation(-self.graphView.bounds.size.width/2, -self.graphView.bounds.size.height/2))];
    }
}

- (IBAction)userWantsZoomIn:(UIGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self.graphView setScale: self.graphView.scale * 2.0];
}

- (IBAction)userWantsZoomOut:(id)sender {
    [self.graphView setScale: self.graphView.scale / 2.0];
}

@end
