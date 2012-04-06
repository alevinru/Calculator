//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Levin Alexander on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Processor.h"

@interface CalculatorViewController : UIViewController

    @property (strong, nonatomic) Processor * brain;

    @property (weak, nonatomic) IBOutlet UITextField *resultsDisplay;

    @property (weak, nonatomic) IBOutlet UILabel *inputDisplay;


    - (IBAction) digitPressed: (UIButton *) sender;

    - (IBAction) operationPressed: (UIButton *) sender;

    - (IBAction) enterPressed;

    - (IBAction) clearPressed;

    - (IBAction) backPressed;

    - (IBAction) signChangePressed;

    - (IBAction) displayProgram;
    
    - (IBAction) variablePressed:(UIButton *) sender;

@end
