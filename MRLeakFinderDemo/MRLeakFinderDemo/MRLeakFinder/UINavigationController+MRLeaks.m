//
//  UINavigationController+MRLeaks.m
//  MRLeakFinderDemo
//
//  Created by Roy on 2019/2/23.
//  Copyright © 2019年 Roy. All rights reserved.
//

#import "UINavigationController+MRLeaks.h"
#import "NSObject+MRLeaks.h"
#import <objc/runtime.h>

@implementation UINavigationController (MRLeaks)

+ (void)load {
    [self swizzleOriginalSEL:@selector(popViewControllerAnimated:)
             withSwizzledSEL:@selector(swizzled_popViewControllerAnimated:)];
}

- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *viewController = [self swizzled_popViewControllerAnimated:animated];
    
    // 标记为已经出栈
    extern const void * const kMRLeaksFinderPoppedKey;
    objc_setAssociatedObject(viewController, kMRLeaksFinderPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    
    return viewController;
}

@end
