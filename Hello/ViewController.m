//
//  ViewController.m
//  Hello
//
//  Created by QSH on 16/5/25.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsProcessor.h"


#import "Test.h"

#import "SRAxis.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *grayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bwImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sliceImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"vin"];
    self.imageView.image = image;
    
    UIImage *grayImage = [[GraphicsProcessor sharedProcessor] grayImage:image];
    self.grayImageView.image = grayImage;
    
    UIImage *binaryImage = [[GraphicsProcessor sharedProcessor] binaryImage:image];
    self.bwImageView.image = binaryImage;
    [[GraphicsProcessor sharedProcessor] logImage:binaryImage];
}



- (void)axisOfImage:(UIImage *)image {
}

- (NSArray *)shadowsOfAxis:(NSArray *)axis {
    return nil;
}

- (NSArray *)sliceImage:(UIImage *)image alongAxis:(NSArray *)axis {
    return nil;
}



- (void)shadowOfImage:(UIImage *)image {
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 *pixels;
    pixels = (UInt32 *)calloc(width * height, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    #define Mask8(x) ( (x) & 0xFF )
    #define R(x) ( Mask8(x) )
    #define G(x) ( Mask8(x >> 8 ) )
    #define B(x) ( Mask8(x >> 16) )
    
    NSUInteger xShadow[width], yShadow[height];
    memset(xShadow, 0, width * sizeof(NSUInteger));
    memset(yShadow, 0, height * sizeof(NSUInteger));
    
    UInt32 *currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            // printf("%3.0f ", (float)averageColor);
            
            if (averageColor == 0) {
                xShadow[i]++;
                yShadow[j]++;
            }
            if (averageColor == 255) {
            }
            currentPixel++;
        }
    }
    free(pixels);
    
    for (NSUInteger i = 0; i < width; i++) {
        // printf("%d ", xShadow[i]);
    }
    printf("\n");
    for (NSUInteger j = 0; j < height; j++) {
        // printf("%d ", yShadow[j]);
    }
    
    int flag = 0;
    for (NSUInteger j = 0; j < height; j++) {
        if (yShadow[j] == 0 && flag == 1) {
            printf(" > ");
            flag = 0;
        }
        if (yShadow[j] != 0 && flag == 0) {
            printf(" < ");
            flag = 1;
        }
        printf("%d ", yShadow[j]);
    }
    
    printf("\n\n");
    for (NSUInteger i = 0; i < width; i++) {
        if (xShadow[i] == 0 && flag == 1) {
            printf(" > ");
            flag = 0;
        }
        
        if (xShadow[i] != 0 && flag == 0) {
            printf(" < ");
            flag = 1;
        }
        printf("%d ", xShadow[i]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
