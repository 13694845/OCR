//
//  Test.m
//  Hello
//
//  Created by QSH on 16/5/31.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "Test.h"
#include "pHash.h"

@implementation Test

- (int)similarityOfImage:(NSString *)imageA andImage:(NSString *)imageB {
    NSLog(@"\n\n Image A : %@", imageA);
    ulong64 hash1;
    const char *path1 = [imageA UTF8String];
    ph_dct_imagehash(path1, hash1);
    
    NSLog(@"\n\n Image B : %@", imageB);
    ulong64 hash2;
    const char *path2 = [imageB UTF8String];
    ph_dct_imagehash(path2, hash2);
    
    int distance = -1;
    distance = ph_hamming_distance(hash1, hash2);
    NSLog(@"\n\n distance : %d", distance);
    
    return distance;
}

@end
