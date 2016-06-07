//
//  GraphicsProcessor.m
//  Hello
//
//  Created by QSH on 16/6/2.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "GraphicsProcessor.h"

@implementation GraphicsProcessor

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

- (void)logImage:(UIImage *)image {
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    UInt32 *pixels = (UInt32 *)calloc(width * height, sizeof(UInt32));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UInt32 *currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            printf("%3.0f ", (R(color) + G(color) + B(color)) / 3.0);
            currentPixel++;
        }
        printf("\n");
    }
    free(pixels);
}

- (UIImage *)grayImage:(UIImage *)image {
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    CGImageRef outputCGImage = CGBitmapContextCreateImage(context);
    UIImage *outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(outputCGImage);
    return outputImage;
}

- (UIImage *)binaryImage:(UIImage *)image {
    const UInt32 threshold = 123;
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    UInt32 *pixels = (UInt32 *)calloc(height * width, sizeof(UInt32));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 *currentPixel = pixels + (j * width) + i;
            UInt32 color = *currentPixel;
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            averageColor = averageColor < threshold ? 0 : 255;
            *currentPixel = RGBAMake(averageColor, averageColor, averageColor, A(color));
        }
    }
    
    CGImageRef outputCGImage = CGBitmapContextCreateImage(context);
    UIImage *outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(outputCGImage);
    free(pixels);
    return outputImage;
}

- (NSArray *)divideImage:(UIImage *)image {
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    UInt32 *pixels = (UInt32 *)calloc(height * width, sizeof(UInt32));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    NSUInteger shadow[width];
    memset(shadow, 0, width * sizeof(NSUInteger));
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 *currentPixel = pixels + (j * width) + i;
            UInt32 color = *currentPixel;
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            if (averageColor == 0) {
                shadow[i]++;
            }
        }
    }
    
    NSMutableArray *slices = [NSMutableArray array];
    NSUInteger left = 0;
    NSUInteger right = 0;
    int flag = 0;
    for (NSUInteger i = 0; i < width; i++) {
        if (shadow[i] == 0 && flag == 1) {
//            printf(" > ");
            flag = 0;
            
            right = i;
//            printf(" { %d, %d } ", left, right);

            // ****************************
            if ((right - left) < 2) continue;
            // ****************************
            
            UIImage *slice = [self sliceImage:image inRect:CGRectMake(left, 0, right - left, height)];
            [slices addObject:slice];
        }
        if (shadow[i] != 0 && flag == 0) {
//            printf(" < ");
            flag = 1;
            
            left = i;
        }
//        printf("%d ", shadow[i]);
    }
    
//    NSLog(@"count : %d", slices.count);

    for (NSUInteger i = 0; i < slices.count; i++) {
        UIImage *slice = slices[i];
        NSLog(@"i : %d / %d", i, slices.count);
        slices[i] = [self trimImage:slice];
    }

    return slices;
}

- (UIImage *)sliceImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef inputCGImage = [image CGImage];
    CGImageRef outputCGImage = CGImageCreateWithImageInRect(inputCGImage, rect);
    UIImage *outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);
    return outputImage;
}

- (UIImage *)trimImage:(UIImage *)image {
    // NSLog(@"\n\n");
    // NSLog(@"%f", image.size.height);
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    UInt32 *pixels = (UInt32 *)calloc(height * width, sizeof(UInt32));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    NSUInteger shadow[height];
    memset(shadow, 0, height * sizeof(NSUInteger));
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 *currentPixel = pixels + (j * width) + i;
            UInt32 color = *currentPixel;
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            if (averageColor == 0) {
                shadow[j]++;
            }
        }
    }
    
    UIImage *slice;
    NSUInteger top = 0;
    NSUInteger bottom = 0;
    int flag = 0;
    for (NSUInteger j = 0; j < height; j++) {
        if (shadow[j] == 0 && flag == 1) {
            printf(" > ");
            flag = 0;
            
            bottom = j;
            printf(" { %d, %d } ", top, bottom);
            
            slice = [self sliceImage:image inRect:CGRectMake(0, top, width, bottom - top)];
        }
        
        
        // ***************************
        if (j == height - 1 && flag == 1) {
            printf(" > ");
            flag = 0;
            bottom = j;
            slice = [self sliceImage:image inRect:CGRectMake(0, top, width, bottom - top)];
        }
        // ***************************
        
        
        if (shadow[j] != 0 && flag == 0) {
            printf(" < ");
            flag = 1;
            
            top = j;
        }
        printf("%d ", shadow[j]);
    }
    // NSLog(@"%f", slice.size.height);
    return slice;
}

@end
