//
//  Font.m
//  Hello
//
//  Created by QSH on 16/6/6.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Font.h"

@implementation Font

+ (instancetype)sharedFont {
    static Font *sharedFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFont = [[self alloc] init];
    });
    return sharedFont;
}

@end
