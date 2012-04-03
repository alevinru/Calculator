//
//  Processor.m
//  Calculator
//
//  Created by Levin Alexander on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Processor.h"

typedef double(^formula_t)(double arg);

@interface PrimitiveFunction : NSObject

    @property NSUInteger dimensionality;
    @property NSUInteger priority;
    @property (strong) formula_t formula;

@end

@interface Processor ()

    @property (strong, nonatomic) NSMutableArray * operandStack;

@end

@implementation PrimitiveFunction

    @synthesize dimensionality, priority, formula = _formula;

    - (PrimitiveFunction *) initWithDimensionality: (NSUInteger) d
                                          priority: (NSUInteger) p {
        self.dimensionality = d;
        self.priority = p;
        return self;
    }

    + (PrimitiveFunction *) ofDimensionality: (NSUInteger) d 
                                    priority: (NSUInteger) p {
        return [[PrimitiveFunction alloc] initWithDimensionality:d 
                                                        priority:p];
    }

    + (PrimitiveFunction *) ofDimensionality: (NSUInteger) d 
                                    priority: (NSUInteger) p
                                    formula: (formula_t) f{
        
        PrimitiveFunction * pf = [[PrimitiveFunction alloc] 
                                  initWithDimensionality:d 
                                                priority:p];
        pf.formula = f;
        
        return pf;
        
    }

@end

@implementation Processor

    @synthesize operandStack = _operandStack;

    static NSDictionary * functions;

    - (id) program {
        return [self.operandStack copy];
    }


    - (NSMutableArray *) operandStack {
        return _operandStack ? _operandStack : ( _operandStack = [[NSMutableArray alloc] init] );
    }


    - (void) setOperandStack:(NSMutableArray *) theArray {
        _operandStack = theArray;
    }


    + (NSDictionary *) calculatorFunctions {
        
        return functions ? functions : (functions = [NSDictionary dictionaryWithObjectsAndKeys:
                
            [PrimitiveFunction ofDimensionality: 0
                                       priority: 0
                                        formula: ^(double arg) {
                                            return M_PI; 
                                        }
             ], @"π", 
            [PrimitiveFunction ofDimensionality: 1 
                                       priority: 0
                                        formula: ^(double arg) {
                                            return sqrt(arg);
                                        }
             ], @"sqrt", 
            [PrimitiveFunction ofDimensionality: 1 
                                       priority: 0
                                        formula: ^(double arg) { 
                                            return sin(arg); 
                                        }
             ], @"sin", 
            [PrimitiveFunction ofDimensionality: 1 
                                       priority: 0
                                        formula: ^(double arg) { 
                                           return cos(arg); 
                                        }
            ], @"cos", 
            [PrimitiveFunction ofDimensionality: 1
                                       priority: 0
                                        formula: ^(double arg) {
                                            return - arg;
                                        }
             ], @"+-", 
            [PrimitiveFunction ofDimensionality: 2 priority: 3], @"+", 
            [PrimitiveFunction ofDimensionality: 2 priority: 3], @"-", 
            [PrimitiveFunction ofDimensionality: 2 priority: 2], @"/", 
            [PrimitiveFunction ofDimensionality: 2 priority: 2], @"*", 
                
            nil
        ]);
    }


    + (NSSet *) supportedFunctions {
        return [NSSet setWithArray: [[self calculatorFunctions] allKeys]];
    }


    - (double) performOperation: (NSString *) theOperation{
        double result = 0;
        
        [self.operandStack addObject:theOperation];
        
        result = [[self class] runProgram:self.program];

        return result;
    }


    - (void) pushOperand: (double) theOperand {
        [self.operandStack addObject: [NSNumber numberWithDouble: theOperand]];
    }



    - (void) clear {
        [self.operandStack removeAllObjects];
    }

    - (void) pop {
        [self.operandStack removeLastObject];
    }

    + (double) popOperandOffProgramStack: (NSMutableArray*) stack{
        
        double result = 0;
        
        id topOfStack = [stack lastObject];
        if (topOfStack) [stack removeLastObject];
        
        if ([topOfStack isKindOfClass:[NSNumber class]])
        {
            result = [topOfStack doubleValue];
        }
        else if ([topOfStack isKindOfClass:[NSString class]])
        {
            NSString *operation = topOfStack;
            
            if ([operation isEqualToString:@"+"]) {
                
                result = [self popOperandOffProgramStack:stack] +
                [self popOperandOffProgramStack:stack];
                
            } else if ([@"*" isEqualToString:operation]) {
                
                result = [self popOperandOffProgramStack:stack] *
                [self popOperandOffProgramStack:stack];
                
            } else if ([operation isEqualToString:@"-"]) {
                
                result = - [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
                
            } else if ([operation isEqualToString:@"/"]) {
                
                double divisor = [self popOperandOffProgramStack:stack];
                if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
                
            } else {
                
                PrimitiveFunction * f = [[[self class] calculatorFunctions] objectForKey: operation];
                
                if (f) {
                    double arg = f.dimensionality ? [self popOperandOffProgramStack:stack] : 0;
                    
                    result = f.formula (arg);
                }
            }
        }
        
        return result;
    }


    + (double)runProgram:(id)program {
        
        NSMutableArray *stack;
        
        if ([program isKindOfClass:[NSArray class]]) {
            stack = [program mutableCopy];
        }
        
        return [self popOperandOffProgramStack:stack];
        
    }


    + (double) runProgram: (id) program 
      usingVariableValues: (NSDictionary *) variableValues {
        
        NSMutableArray * stack;
        
        if ([program isKindOfClass:[NSArray class]]) {
            stack = [program mutableCopy];
        }
        
        for (int i = 0; i < [stack count]; i++) {
            
            NSObject * operand = [stack objectAtIndex: i];
            NSObject * variableValue;
            
            if ([operand isKindOfClass: [NSString class]]) {
                variableValue = [variableValues objectForKey: operand];
                if (variableValue)
                    [stack replaceObjectAtIndex:i withObject: variableValue];
            }
        }    
        
        return [self runProgram: stack];
        
    }


    + (NSSet *)variablesUsedInProgram:(id)program {
        
        NSMutableSet * result = [[NSMutableSet alloc] init];
        NSSet * funcs = [self supportedFunctions];
        
        for (id block in program)
            if ([block isKindOfClass: [NSString class]])
                if (![funcs containsObject: block] && ![result containsObject:block])
                        [result addObject:block];
        
        if ([result count] > 0)
            return [result copy];
        else 
            return nil;
        
    }


    + (NSUInteger) operationDimensionality: (NSString *) operationKey {
        
        PrimitiveFunction * f = [[self calculatorFunctions] objectForKey: operationKey];
        
        return f ? f.dimensionality : 0;
    }

    + (NSString *) describeProgram: (NSMutableArray *) stack {

        return [self describeProgram: stack inContextOf: nil];

    }

    + (NSString *) describeProgram: (NSMutableArray *) stack 
                       inContextOf: (PrimitiveFunction*) caller {
        
        NSString * result;
        
        id topOfStack = [stack lastObject];
        
        if (topOfStack) {
            
            [stack removeLastObject];
            
            if ([topOfStack isKindOfClass: [NSNumber class]]) {
                
                result = [topOfStack stringValue]; 
                
            } else {
                
                PrimitiveFunction * f = [[self calculatorFunctions] objectForKey: topOfStack];
                
                if (f && f.dimensionality > 0) {
                    
                    NSString * a1 = [self describeProgram: stack
                                              inContextOf: f];
                    
                    if (f.dimensionality == 1) {
                        
                        result = [NSString stringWithFormat: @"%@(%@)", topOfStack, a1];
                        
                    } else if (f.dimensionality == 2) {
                        
                        NSString * fmt = @"%@ %@ %@";                    
                        NSString * a2 = [self describeProgram: stack 
                                                  inContextOf: f];
                        
                        if (caller && caller.dimensionality > 1 && f.priority > caller.priority) {
                            fmt = [NSString stringWithFormat: @"(%@)", fmt];
                        }
                        
                        result = [NSString stringWithFormat: fmt, a2, topOfStack, a1];
                        
                    }
                    
                } else {
                    
                    result = topOfStack;
                    
                }
            }
            
        }
        
        if (caller == nil && [stack count] > 0) 
            result = [NSString stringWithFormat: @"%@, %@", result, [self describeProgram: stack]];
        
        return result;
        
    }


    + (NSString *) descriptionOfProgram: (id) program {
        
        NSMutableArray *stack;
        
        if ([program isKindOfClass:[NSArray class]]) {
            stack = [program mutableCopy];
        }
        
        return [self describeProgram :stack];
    }


@end
