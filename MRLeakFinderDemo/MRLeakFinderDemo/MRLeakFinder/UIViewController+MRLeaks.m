//
//  UIViewController+MRLeaks.m
//  MRLeakFinderDemo
//
//  Created by Roy on 2019/2/23.
//  Copyright © 2019年 Roy. All rights reserved.
//

#import "UIViewController+MRLeaks.h"
#import "NSObject+MRLeaks.h"
#import <objc/runtime.h>

// 用于标记是否已经出栈
const void * const kMRLeaksFinderPoppedKey = @"kMRLeakFinderPoppedKey";

@implementation UIViewController (MRLeaks)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleOriginalSEL:@selector(viewWillAppear:)
                 withSwizzledSEL:@selector(swizzled_viewWillAppear:)];
        [self swizzleOriginalSEL:@selector(viewDidDisappear:)
                 withSwizzledSEL:@selector(swizzled_viewDidDisappear:)];
        [self swizzleOriginalSEL:@selector(dismissViewControllerAnimated:completion:)
                 withSwizzledSEL:@selector(swizzled_dismissViewControllerAnimated:completion:)];
    });
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    
    // 设置标记为入栈
    objc_setAssociatedObject(self, kMRLeaksFinderPoppedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

- (void)swizzled_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self swizzled_dismissViewControllerAnimated:flag completion:completion];
    
    // 标记为已经出栈
    objc_setAssociatedObject(self, kMRLeaksFinderPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
}

- (void)swizzled_viewDidDisappear:(BOOL)animated {
    [self swizzled_viewDidDisappear:animated];
    
    // 判断标记为出栈
    if([objc_getAssociatedObject(self, kMRLeaksFinderPoppedKey) boolValue] == YES) {
        
        // 判断是否被销毁
        [self willDealloc];
    }
}

@end
