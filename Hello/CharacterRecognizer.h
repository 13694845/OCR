//
//  Test.h
//  Hello
//
//  Created by QSH on 16/5/31.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterRecognizer : NSObject

- (int)distanceBetweenImage:(NSString *)imageA andImage:(NSString *)imageB;
- (NSString *)characterForImage:(NSString *)image;

@end
