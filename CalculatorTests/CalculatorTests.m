//
//  CalculatorTests.m
//  CalculatorTests
//
//  Created by Levin Alexander on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorTests.h"
#import "Processor.h"

@interface CalculatorTests()

    @property (strong, nonatomic) Processor * p ;

@end




@implementation CalculatorTests

    @synthesize p = _p;


    - (void)setUp
    {
        [super setUp];
        
        self.p = [[Processor alloc] init];
    }

    - (void)tearDown
    {        
        [super tearDown];
    }



    - (void)testSimpleOperation
    {
        
        [self.p pushOperand:3];
        [self.p pushOperand:4];
        
        STAssertEqualsWithAccuracy(0.75, [self.p performOperation: @"/"], 0.00001,@"Division error");
        
    }

    - (void)testFunction
    {
        
        [self.p pushOperand: M_PI_2];
        
        STAssertEquals(1.0, [self.p performOperation: @"sin"], @"Sin doesnt work");
        
        STAssertEquals(
           100.0,
           [Processor runProgram: [NSArray arrayWithObject: [NSNumber numberWithInt:100]] 
             usingVariableValues: [NSDictionary dictionaryWithObject: @"" forKey:@"x"]],
           @"Const program"
        );
    }


    - (void)testProgram
    {
        
        NSArray * prg = [NSArray arrayWithObjects: 
            [NSNumber numberWithDouble: 3],
            [NSNumber numberWithDouble: 4],
            @"/", nil
        ];
        
        STAssertEquals(0.75, [Processor runProgram: prg], @"Division via program error");
        
        STAssertNil ([Processor variablesUsedInProgram: prg], @"");

    }


    - (void)testProgramDescription {
        
        NSMutableArray * prg = [NSMutableArray arrayWithObjects: 
            [NSNumber numberWithDouble: 3],
            @"sin",
            nil
        ];
        
        STAssertEqualObjects( @"sin(3)", [Processor descriptionOfProgram: prg], @"Simple brackets positioning");

        [prg insertObjects: [NSArray arrayWithObjects: 
                             [NSNumber numberWithDouble: 5],
                             @"x",
                             [NSNumber numberWithDouble: 7],
                             @"+",
                             @"*",
                             @"-",
                             nil]
                 atIndexes: [NSIndexSet 
                             indexSetWithIndexesInRange: NSMakeRange(1, 6)]
        ];
        
        STAssertEqualObjects( @"sin(3 - 5 * (x + 7))", [Processor descriptionOfProgram: prg], @"Complex brackets");
        
        prg 
        = [NSMutableArray arrayWithObjects: 
           @"a", @"pi", @"*", @"b", @"b", @"*", @"+", @"sqrt", nil]
        ;
        
        STAssertEqualObjects( @"sqrt(a * pi + b * b)", [Processor descriptionOfProgram: prg], @"Complex brackets 2");

        prg = [NSMutableArray arrayWithObjects: 
               [NSNumber numberWithDouble: 3],
               [NSNumber numberWithDouble: 5],
               @"+",
               [NSNumber numberWithDouble: 6],
               [NSNumber numberWithDouble: 7],
               @"*",
               [NSNumber numberWithDouble: 9],
               @"sqrt", nil
               ];
        
        STAssertEqualObjects( @"sqrt(9), 6 * 7, 3 + 5", [Processor descriptionOfProgram: prg], @"Multiple things on the stack");
    
    }


    - (void)testProgramVariable
    {
        
        NSMutableArray * prg = [NSMutableArray arrayWithObjects: 
            [NSNumber numberWithDouble: 3],
            @"x",
            @"+",nil
        ];
        
        NSDictionary * vars = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:4], @"x", nil
        ];
        
        STAssertEquals(7.0, [Processor runProgram:prg usingVariableValues:vars], @"Variable program does not work");
        
        STAssertEquals(3.0, [Processor runProgram:prg], @"Variable program does not work as a static program");
        
        STAssertTrue([[Processor variablesUsedInProgram: prg] isKindOfClass:[NSSet class]], @"Shoud be NSSet");
        
        STAssertEquals(1, (int) [[Processor variablesUsedInProgram: prg] count], @"");
        
        [prg addObject: @"x"];
        [prg addObject: @"+"];

        [prg addObject: @"y"];
        [prg addObject: @"+"];
        
        STAssertEquals(2, (int) [[Processor variablesUsedInProgram: prg] count], @"");
        
    }

@end
