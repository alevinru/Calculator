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

- (void) setFunctionLabel;

@end

@implementation GraphingViewController

@synthesize titleLabel = _titleLabel;
@synthesize toolbar = _toolbar, navbar = _navbar;
@synthesize graphView = _graphView, program = _program;
@synthesize defaultScale = _defaultScale, defaultOrigin = _defaultOrigin;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;


- (void) setFunctionLabel{
    NSString * title = self.program ? [NSString stringWithFormat:@"y = %@", [Processor descriptionOfProgram: self.program]] : @"Define a function using left panel";
    if (self.titleLabel)
        [self.titleLabel setText: title];
    else if (self.navbar)
        [self.navbar.topItem setTitle: title];
    
}


- (void) setProgram:(NSArray *) newProgram {
    if (![newProgram isEqualToArray: _program]) {
        _program = newProgram ? [newProgram copy]: nil;
        [self setFunctionLabel];
        [self.graphView setNeedsDisplay];
    }
}


- (NSUserDefaults*) defaults {
    return [NSUserDefaults standardUserDefaults];
}


- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{   
    if (self.toolbar) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
    } else if (self.navbar) {
        [self.navbar.topItem setLeftBarButtonItem: splitViewBarButtonItem];
    }
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
    
    [self setFunctionLabel];
    
    
    NSMutableDictionary * storyBoardRecognizers = [[NSMutableDictionary alloc] init];
    
    [self.graphView.gestureRecognizers enumerateObjectsUsingBlock: ^(id recognizer, NSUInteger idx, BOOL *stop) {
        if ([recognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
            [storyBoardRecognizers setObject: recognizer forKey: @"pan"];
        } else if ([recognizer isKindOfClass: [UIPinchGestureRecognizer class]]) {
            [storyBoardRecognizers setObject: recognizer forKey: @"pinch"];
        } else if ([recognizer isKindOfClass: [UITapGestureRecognizer class]]) {
            if ([recognizer numberOfTapsRequired] == 2) {
                if ([recognizer numberOfTouchesRequired] == 2) 
                    [storyBoardRecognizers setObject: recognizer forKey: @"twofingerdoubletap"];
                else
                    [storyBoardRecognizers setObject: recognizer forKey: @"doubletap"];
            } else if ([recognizer numberOfTapsRequired] == 3) {
                [storyBoardRecognizers setObject: recognizer forKey: @"tripletap"];
            }
        }
    }];
    

    if (![storyBoardRecognizers objectForKey: @"pan"]) {
        [self.graphView addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(userDidPan:)]];
        NSLog(@"GraphingViewController did load and found no pan recognizer");
    }
    
    if (![storyBoardRecognizers objectForKey: @"pinch"]) {
        [self.graphView addGestureRecognizer: [[UIPinchGestureRecognizer alloc] initWithTarget: self action:@selector(userDidPinch:)]];
        NSLog(@"GraphingViewController did load and found no pinch recognizer");
    }
    
    if (![storyBoardRecognizers objectForKey: @"doubletap"]) {
        UITapGestureRecognizer * recognizer = [UITapGestureRecognizer alloc];
        [self.graphView addGestureRecognizer: [recognizer initWithTarget: self action:@selector(userWantsZoomIn:)]];
        recognizer.numberOfTapsRequired = 2;
        NSLog(@"GraphingViewController did load and found no doubletap recognizer");
    }
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
