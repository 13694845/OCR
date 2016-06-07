//
//  Test.m
//  Hello
//
//  Created by QSH on 16/5/31.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "CharacterRecognizer.h"
#import "SampleBook.h"
#include "pHash.h"

@implementation CharacterRecognizer

- (int)distanceBetweenImage:(NSString *)imageA andImage:(NSString *)imageB {
    int distance = -1;
    ulong64 hash1;
    const char *path1 = [imageA UTF8String];
    ph_dct_imagehash(path1, hash1);
    ulong64 hash2;
    const char *path2 = [imageB UTF8String];
    ph_dct_imagehash(path2, hash2);
    distance = ph_hamming_distance(hash1, hash2);
    return distance;
}

- (NSString *)characterForImage:(NSString *)image {
    NSString *character = @"?";
    int nearest = 26;
    for (NSDictionary *sample in [[SampleBook sharedBook] allSamples]) {
        int distance = [self distanceBetweenImage:image andImage:[[NSBundle mainBundle] pathForResource:sample[@"image"] ofType:nil]];
        if (distance < nearest) {
            nearest = distance;
            character = sample[@"character"];
        }
    }
    return character;
}

@end
