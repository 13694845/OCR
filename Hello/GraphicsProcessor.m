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

+ (instancetype)sharedProcessor {
    static GraphicsProcessor *sharedProcessor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProcessor = [[self alloc] init];
    });
    return sharedProcessor;
}

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
    const UInt32 threshold = 120;
    
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
    free(pixels);
    
    return outputImage;
}

@end
