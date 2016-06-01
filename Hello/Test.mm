//
//  Test.m
//  Hello
//
//  Created by QSH on 16/5/31.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Test.h"
#include "pHash.h"
#include "Magick++.h"


@implementation Test

- (void)hashImage {
    NSLog(@"\n\n hello hashing Image");
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"f.jpg" ofType:nil];
    
    NSLog(@"\n\n path : %@", path);
    
    const char *s = [path UTF8String];
    
    ulong64 tmphash;
    ph_dct_imagehash(s, tmphash);
    
    
    
    NSLog(@"\n\n hello hashing Image");
}

@end
