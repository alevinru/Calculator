//
//  GraphingViewController.m
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingViewController.h"

@interface GraphingViewController ()

@end

@implementation GraphingViewController
@synthesize graphView, scale = _scale;


- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scale = 1.0;
    if ([self.view isKindOfClass: [GraphView class]])
        self.graphView = (GraphView*) self.view;
}

- (void) viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)userDidPinch:(UIPinchGestureRecognizer *) gesture {
    if (//(gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.graphView.scale *= gesture.scale; 
        NSLog(@"Pinched: %f %f", self.graphView.scale, gesture.scale );
        gesture.scale =1.0;
    }

}

@end
