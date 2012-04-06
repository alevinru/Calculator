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

@end

@implementation GraphingViewController
@synthesize titleLabel = _titleLabel;

@synthesize graphView = _graphView, scale = _scale, program = _program;

- (void) setProgram:(NSArray *)newProgram {
    if (![newProgram isEqualToArray: _program]) {
        _program = newProgram;
        [self.view setNeedsDisplay];
        [self.titleLabel setText: [Processor descriptionOfProgram: newProgram]];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scale = 1.0;
    if (!self.graphView && [self.view isKindOfClass: [GraphView class]])
        self.graphView = (GraphView*) self.view;
    if (!self.graphView.datasource)
        self.graphView.datasource = self;
}

- (void) viewDidUnload
{
    [self setGraphView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)userDidPinch:(UIPinchGestureRecognizer *) gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.graphView.scale *= gesture.scale;
        NSLog(@"Pinched: %f %f", self.graphView.scale, gesture.scale );
        gesture.scale =1.0;
    }

}

- (double) yValueFor:(double)xValue {
    return [Processor runProgram: self.program
             usingVariableValues: [NSDictionary dictionaryWithObject: [NSNumber numberWithDouble: xValue] forKey: @"x"]];
}

@end
