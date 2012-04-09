//
//  GraphingViewController.h
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphingViewController : UIViewController <GraphViewDatasource, SplitViewBarButtonItemPresenter>


@property (weak, nonatomic) IBOutlet GraphView * graphView;

@property (strong, nonatomic) NSArray* program;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)userDidPinch:(UIPinchGestureRecognizer *) gesture;

- (IBAction)userDidPan:(UIPanGestureRecognizer *)gesture;

- (IBAction)userDidTap:(UITapGestureRecognizer *)sender;

- (IBAction)userWantsZoomIn:(UIGestureRecognizer*) gesture;

- (IBAction)userWantsZoomOut:(id)sender;

// Datasource implementation

- (double) yValueFor:(double)xValue;

@property (nonatomic) CGFloat defaultScale;

@property (nonatomic) CGPoint defaultOrigin;

@end
