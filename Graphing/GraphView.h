//
//  GraphView.h
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDatasource <NSObject>

- (double) yValueFor: (double) xValue;

@end

@interface GraphView : UIView

@property (weak, nonatomic) IBOutlet id <GraphViewDatasource> datasource;

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@end
