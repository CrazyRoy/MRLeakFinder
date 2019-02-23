//
//  NSObject+MRLeaks.h
//  MRLeakFinderDemo
//
//  Created by Roy on 2019/2/23.
//  Copyright © 2019年 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MRLeaks)

/**
 swizzle 方法

 @param originalSelector 原始方法
 @param swizzledSelector 交换方法
 */
+ (void)swizzleOriginalSEL:(SEL)originalSelector withSwizzledSEL:(SEL)swizzledSelector;

/**
 即将析构方法
 */
- (void)willDealloc;

@end
