//
//  Font.h
//  Hello
//
//  Created by QSH on 16/6/6.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Font : NSObject

+ (instancetype)sharedFont;

- (NSArray *)allCharacters;

@end
