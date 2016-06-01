//
//  ViewController.m
//  Hello
//
//  Created by QSH on 16/5/25.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *grayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bwImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"vin"];
    self.imageView.image = image;
    // [self logPixelsOfImage:image];
    
    UIImage *grayImage = [self grayImage:image];
    self.grayImageView.image = grayImage;
    // [self logPixelsOfImage:grayImage];
    
    UIImage *bwImage = [self bwImage:grayImage];
    self.bwImageView.image = bwImage;
    // [self logPixelsOfImage:bwImage];
    
    [self shadowOfImage:bwImage];
    
    Test *test = [[Test alloc] init];
    [test similarityOfImage:[[NSBundle mainBundle] pathForResource:@"font.jpg" ofType:nil]
                   andImage:[[NSBundle mainBundle] pathForResource:@"slice.jpg" ofType:nil]];
}

- (NSArray *)sliceImage:(UIImage *)image {
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
            printf("|| ");
            flag = 0;
        }
        if (yShadow[j] != 0 && flag == 0) {
            printf("|| ");
            flag = 1;
        }
        printf("%d ", yShadow[j]);
    }
    
    printf("\n\n");
    for (NSUInteger i = 0; i < width; i++) {
        if (xShadow[i] == 0 && flag == 1) {
            printf("|| ");
            flag = 0;
        }
        
        if (xShadow[i] != 0 && flag == 0) {
            printf("|| ");
            flag = 1;
        }
        printf("%d ", xShadow[i]);
    }
}

- (UIImage *)bwImage:(UIImage *)image {
    UInt32 *inputPixels;
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    #define Mask8(x) ( (x) & 0xFF )
    #define R(x) ( Mask8(x) )
    #define G(x) ( Mask8(x >> 8 ) )
    #define B(x) ( Mask8(x >> 16) )
    #define A(x) ( Mask8(x >> 24) )
    #define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
    
    for (NSUInteger j = 0; j < inputHeight; j++) {
        for (NSUInteger i = 0; i < inputWidth; i++) {
            UInt32 *currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            // printf("%3.0f ", (float)averageColor);
            
            if (averageColor < 120) averageColor = 0;
            if (averageColor > 120) averageColor = 255;
            
            *currentPixel = RGBAMake(averageColor, averageColor, averageColor, A(color));
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:newCGImage];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(inputPixels);
    
    return processedImage;
}

- (UIImage *)grayImage:(UIImage *)image {
    CGRect imageRect = {CGPointZero, image.size};
    NSInteger inputWidth = CGRectGetWidth(imageRect);
    NSInteger inputHeight = CGRectGetHeight(imageRect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, inputWidth, inputHeight,
                                    8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return finalImage;
}

- (void)logPixelsOfImage:(UIImage *)image {
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
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    #define Mask8(x) ( (x) & 0xFF )
    #define R(x) ( Mask8(x) )
    #define G(x) ( Mask8(x >> 8 ) )
    #define B(x) ( Mask8(x >> 16) )
    
    UInt32 *currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            currentPixel++;
        }
        printf("\n");
    }
    free(pixels);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
