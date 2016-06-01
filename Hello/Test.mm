//
//  Test.m
//  Hello
//
//  Created by QSH on 16/5/31.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Test.h"
#include "pHash.h"
// #include "Magick++.h"
// #include "MagickCore/MagickCore.h"
#include "jpeglib.h"


//data structure for a hash and id
struct ph_imagepoint{
    ulong64 hash;
    char *id;
};


@implementation Test

- (void)hashImage {
    NSLog(@"\n\n hello hashing Image");
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01.jpg" ofType:nil];
    
    NSLog(@"\n\n path : %@", path);
    
    const char *s = [path UTF8String];
    
    
    

    
    ulong64 tmphash1;
   ph_dct_imagehash(s, tmphash1);
    
    ulong64 hash1 = tmphash1;
    
    
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"f2.jpg" ofType:nil];
    
    NSLog(@"\n\n path2 : %@", path2);
    
    const char *s2 = [path2 UTF8String];

    ulong64 tmphash2;

    ph_dct_imagehash(s2, tmphash2);
    ulong64 hash2 = tmphash2;
    
    int distance = -1;
    distance = ph_hamming_distance(hash1, hash2);
    
    NSLog(@"\n\n hello hashing Image %d", distance);
}

@end
