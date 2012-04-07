//
//  GraphingViewController.h
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphingViewController : UIViewController <GraphViewDatasource>

@property (weak, nonatomic) IBOutlet GraphView * graphView;

@property (nonatomic) CGFloat scale; 

@property (strong, nonatomic) NSArray* program;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)userDidPinch:(UIPinchGestureRecognizer *) gesture;

- (IBAction)userDidPan:(UIPanGestureRecognizer *)gesture;

- (double) yValueFor:(double)xValue;

@end
