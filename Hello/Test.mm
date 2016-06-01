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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"circle.png" ofType:nil];    // f1.jpg
    
    NSLog(@"\n\n path : %@", path);
    
    const char *s = [path UTF8String];
    
    
    

    
    ulong64 tmphash1;
    ph_dct_imagehash(s, tmphash1);
    
    ulong64 hash1 = tmphash1;
    
    
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"square.png" ofType:nil];   // m0.jpg
    
    NSLog(@"\n\n path2 : %@", path2);
    
    const char *s2 = [path2 UTF8String];

    ulong64 tmphash2;

    ph_dct_imagehash(s2, tmphash2);
    ulong64 hash2 = tmphash2;
    
    int distance = -1;
    distance = ph_hamming_distance(hash1, hash2);
    
    NSLog(@"\n\n hello hashing Image %d", distance);
}




void sort_names(char **names, int L1){
    
    for (int i=0;i<L1;i++){
        int min = i;
        for (int j=i+1;j<L1;j++){
            if (strcmp(names[j], names[min]) <= 0)
                min = j;
        }
        if (i != min){
            char *swap = names[i];
            names[i] = names[min];
            names[min] = swap;
        }
        
    }
    
}

- (void)hashImageAgain {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01.jpg" ofType:nil];
    
    NSLog(@"\n\n path : %@", path);
    
    const char *s = [path UTF8String];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"f1.jpg" ofType:nil];
    
    NSLog(@"\n\n path2 : %@", path2);
    
    const char *s2 = [path2 UTF8String];

    const char *dirname1 = s;
    const char *dirname2 = s2;
    
    int alpha = 2;
    int level = 1;
    
    int nbfiles1;
    char **files1 = ph_readfilenames(dirname1, nbfiles1);
    sort_names(files1,nbfiles1);
    
    int nbfiles2;
    char **files2 = ph_readfilenames(dirname2, nbfiles2);
    sort_names(files2,nbfiles2);
    
    if (nbfiles1 != nbfiles2){
        printf("number files in both directories not equal\n");
        exit(1);
    }
    
    uint8_t **hash1 = (uint8_t**)malloc(nbfiles1*sizeof(uint8_t*));
    uint8_t *hash2 = NULL;
    int hashlen1=0, hashlen2=0;
    double dist = 0;
    printf("intra distances\n");
    printf("***************\n");
    for (int i=0;i<nbfiles1;i++){
        printf("file1: %s\n", files1[i]);
        hash1[i] = ph_mh_imagehash(files1[i], hashlen1, alpha, level);
        if (hash1 == NULL)
            continue;
        printf("file2: %s\n", files2[i]);
        hash2 = ph_mh_imagehash(files2[i], hashlen2, alpha, level);
        if (hash2 == NULL)
            continue;
        
        dist = ph_hammingdistance2(hash1[i], hashlen1, hash2, hashlen2);
        printf("distance = %f\n", dist);
        printf("-------------\n");
        free(hash2);
    }
    printf("\n\n");
    printf("--hit any key--\n");
 //   getchar();
    printf("inter distances\n");
    for (int i=0;i<nbfiles1;i++){
        for (int j=i+1;j<nbfiles1;j++){
            dist = ph_hammingdistance2(hash1[i], hashlen1, hash1[j], hashlen1);
            printf(" %d %d dist = %f\n", i, j, dist);
            printf("----------------\n");
        }
    }
    printf("done\n");
    
    for(int i = 0; i < nbfiles1; ++i)
    {
        free(files1[i]);
        free(files2[i]);
        free(hash1[i]);
    }
    free(files1);
    free(files2);
    free(hash1);
}

@end
