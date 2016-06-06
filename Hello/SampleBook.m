//
//  SampleBook.m
//  Hello
//
//  Created by QSH on 16/6/6.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "SampleBook.h"

@interface SampleBook ()

@property (strong, nonatomic) NSDictionary *samples;

@end

@implementation SampleBook

+ (instancetype)sharedBook {
    static SampleBook *sampleBook = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sampleBook = [[self alloc] initWithContentsOfJson];
    });
    return sampleBook;
}

- (instancetype)initWithContentsOfJson {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"samplebook" ofType:@"json"];
        _samples = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    }
    return self;
}

- (NSArray *)allSamples {
    return [self.samples[@"samples"] copy];
}

@end
