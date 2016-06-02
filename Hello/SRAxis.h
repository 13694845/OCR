//
//  SRAxis.h
//  Hello
//
//  Created by QSH on 16/6/2.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRAxis : NSObject

- (instancetype)initWithValues:(const UInt32[])values count:(NSUInteger)count;
- (NSUInteger)count;
- (UInt32)valueAtIndex:(NSUInteger)index;

@end
