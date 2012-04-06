//
//  Processor.h
//  Calculator
//
//  Created by Levin Alexander on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Processor : NSObject

    @property (nonatomic, readonly) id program;


    + (double) runProgram: (id) program;

    + (double) runProgram: (id) program usingVariableValues: (NSDictionary *) variableValues;

    + (NSString *)descriptionOfProgram:(id)program;

    + (NSSet *) variablesUsedInProgram:(id) program;

    + (NSSet *) supportedFunctions;


    - (void) pushOperand: (double) anOperand;

    - (void) pushVariable: (NSString *) name;

    - (void) pop;

    // Если передана неизвестная операция, то результат будет 0

    - (double) performOperation: (NSString *) anOperation;

    - (void) clear;


@end
