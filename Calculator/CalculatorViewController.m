//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Levin Alexander on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphingViewController.h"

@interface CalculatorViewController ()

    @property (nonatomic) BOOL userIsEntering;
    @property (nonatomic) BOOL decimalIsEntered;
    @property (nonatomic) BOOL isInteractive;

@end

@implementation CalculatorViewController

    @synthesize inputDisplay = _inputDisplay;
    @synthesize resultsDisplay = _resultsDisplay;

    @synthesize
        userIsEntering = _userIsInTheMiddleOfEnteringANumber, 
        brain = _brain, 
        decimalIsEntered = _decimalIsBeingEntered,
        isInteractive = _isInteractive
    ;


    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        [self.resultsDisplay setBorderStyle:UITextBorderStyleRoundedRect];

    }

    - (void)viewDidUnload
    {
        [self setResultsDisplay:nil];
        [self setInputDisplay:nil];
        [self setBrain:nil];
        
        [super viewDidUnload];
    }

    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }

    - (IBAction) displayProgram {
        self.inputDisplay.text = [Processor descriptionOfProgram: self.brain.program];
    }

    - (void) displayAsInput: (NSString*) data {
        
        self.inputDisplay.text = self.isInteractive ? [self.inputDisplay.text stringByAppendingFormat: @" %@", data] : data;
        
        self.isInteractive = YES;
        
    }

    - (Processor *) brain {
        return _brain ? _brain : (_brain = [[Processor alloc] init]);
    }


    - (IBAction)digitPressed:(UIButton *)sender {
        
        NSString *digit = [sender currentTitle];

        if ([digit isEqualToString: @"."]) {
            if (self.decimalIsEntered) return;
            self.decimalIsEntered = YES;
        }
        
        self.resultsDisplay.text = self.userIsEntering ? [self.resultsDisplay.text stringByAppendingString: digit] : digit;
        
        self.userIsEntering = YES;
        
    }

    - (IBAction) operationPressed: (UIButton *) sender {
        
        [self operate: sender.currentTitle];
        
    }

    - (IBAction) variablePressed: (UIButton *) sender {
        
        NSString * theOperation = sender.currentTitle;
        
        [self enterPressed];
        [self displayAsInput: theOperation];
        [self.brain pushVariable: (self.resultsDisplay.text = theOperation)]; 
        
    }

    - (void) operate: (NSString*) theOperation {
        [self enterPressed];
        [self displayAsInput: theOperation];
        
        self.resultsDisplay.text = [NSString stringWithFormat: @"%g", [self.brain performOperation: theOperation]];
        
    }

    - (IBAction) enterPressed {
        
        if (self.userIsEntering) {
            [self displayAsInput: self.resultsDisplay.text];
            
            [self.brain pushOperand: [self.resultsDisplay.text doubleValue]];
        }

        self.userIsEntering
        = self.decimalIsEntered
        = NO;

    }

    - (IBAction) clearPressed {
        
        self.userIsEntering
        = self.decimalIsEntered
        = self.isInteractive
        = NO;
        
        self.resultsDisplay.text = @"0";
        self.inputDisplay.text = @"";
        [self.brain clear];
        
    }

    - (IBAction)backPressed {
        
        if (self.userIsEntering) {
            NSString * newResult = [self.resultsDisplay.text copy];
            
            if ([newResult characterAtIndex: [newResult length] - 1] == '.') self.decimalIsEntered = NO;
            
            newResult = [newResult substringToIndex: newResult.length - 1];
            
            self.resultsDisplay.text = newResult.length ? newResult : @"0";
        } else {
            [self.brain pop];
            [self displayProgram];
        }
    }

    - (IBAction) signChangePressed {
        
        if (self.userIsEntering) {
            NSString * currentText = self.resultsDisplay.text;
            
            self.resultsDisplay.text = [currentText characterAtIndex:0] == '-' ? [currentText substringFromIndex: 1] : [@"-" stringByAppendingString: currentText];
        } else {
            [self operate: @"+-"];
        }
    }

    - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id) sender {
        if ([segue.identifier isEqualToString: @"Show the graph"])
            [self enterPressed];
            [segue.destinationViewController setProgram: self.brain.program];
            //NSLog(@"Preparing to: %@", segue.identifier);
        
    }

@end
