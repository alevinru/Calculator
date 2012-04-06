//
//  GraphView.h
//  Calculator
//
//  Created by Levin Alexander on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphView : UIView

@property (weak, nonatomic) IBOutlet id datasource;

@property (nonatomic) CGFloat scale;

@end
