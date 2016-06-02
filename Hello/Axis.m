//
//  Axis.m
//  Hello
//
//  Created by QSH on 16/6/2.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Axis.h"

@interface Axis ()

@property (strong, nonatomic) NSMutableArray *values;

@end

@implementation Axis

- (instancetype)initWithValues:(const UInt32[])values count:(NSUInteger)count {
    self = [super init];
    if (self) {
        _values = [NSMutableArray array];
        for (NSUInteger i = 0; i < count; i++) {
            [_values addObject:[NSNumber numberWithUnsignedLong:values[i]]];
        }
    }
    return self;
}

- (NSUInteger)count {
    return self.values.count;
}

- (UInt32)valueAtIndex:(NSUInteger)index {
    return [[self.values objectAtIndex:index] unsignedLongValue];
}

@end
