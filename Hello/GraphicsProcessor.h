//
//  GraphicsProcessor.h
//  Hello
//
//  Created by QSH on 16/6/2.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicsProcessor : NSObject

+ (instancetype)sharedProcessor;

- (void)logImage:(UIImage *)image;
- (UIImage *)grayImage:(UIImage *)image;
- (UIImage *)binaryImage:(UIImage *)image;
- (NSArray *)divideImage:(UIImage *)image;

@end
