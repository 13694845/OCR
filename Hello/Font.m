//
//  Font.m
//  Hello
//
//  Created by QSH on 16/6/6.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Font.h"

@interface Font ()

@property (strong, nonatomic) NSDictionary *font;

@end

@implementation Font

+ (instancetype)sharedFont {
    static Font *sharedFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFont = [[self alloc] init];
    });
    return sharedFont;
}

- (instancetype)initWithContentsOfJson {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"font" ofType:@"json"];
        _font = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    }
    return self;
}

- (NSArray *)allCharacters {
    return self.font[@"characters"];
}

@end
