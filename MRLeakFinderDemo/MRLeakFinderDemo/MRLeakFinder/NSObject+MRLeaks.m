//
//  NSObject+MRLeaks.m
//  MRLeakFinderDemo
//
//  Created by Roy on 2019/2/23.
//  Copyright © 2019年 Roy. All rights reserved.
//

#import "NSObject+MRLeaks.h"
#import <objc/runtime.h>

@implementation NSObject (MRLeaks)

+ (void)swizzleOriginalSEL:(SEL)originalSelector withSwizzledSEL:(SEL)swizzledSelector {
    
    Class class = [self class];
    
    // 获取原始方法和交换方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 添加新方法调用交换方法 originalSel ---> swizzledMethod, 如果originalSel存在，则会添加失败，不存在添加方法成功
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    // 之前不存在originalSel, 添加方法成功
    if(didAddMethod) {
        // 上面 A -> B IMP 已经指向好，那么需要完成 B -> A IMP，所以指定一下 sel 和 imp
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        // 之前存在originalSel, 添加方法失败; 那么直接交换两个方法的IMP
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 利用延时三秒之后判断self是否还存在判断当前对象是否被销毁，若销毁了weakSelf = nil, 那么不会调用assertNotDealloc方法，反之会调用
 */
- (void)willDealloc {
    
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [weakSelf assertNotDealloc];
    });
}

// 当前对象没有释放的断言方法
- (void)assertNotDealloc {
    
    NSLog(@"MRLeakFinder info: Class %@ is Leaks.",NSStringFromClass([self class]));
}

@end
