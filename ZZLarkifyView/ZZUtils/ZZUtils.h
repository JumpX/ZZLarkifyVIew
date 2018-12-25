//
//  ZZUtils.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+ZZ.h"
#import "NSArray+ZZ.h"
#import "NSDictionary+ZZ.h"
#import "UIView+ZZ.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define force_inline __inline__ __attribute__((always_inline))

#ifndef zz_dispatch_queue_async_safe
#define zz_dispatch_queue_async_safe(queue, block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(queue)) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif

#ifndef zz_dispatch_main_async_safe
#define zz_dispatch_main_async_safe(block) zz_dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

static force_inline NSString *trim(NSString *string)
{
    if (string == nil) return @"";
    if (![string isKindOfClass:[NSString class]]) {
        return string;
    }
    NSMutableString *bStr = [[NSMutableString alloc] init];
    [bStr setString:string];
    CFStringTrimWhitespace((CFMutableStringRef)bStr);
    return bStr;
}

static force_inline BOOL ValidString(NSString *string)
{
    BOOL result = NO;
    if (string && [string isKindOfClass:[NSString class]] && [string length]) {
        result = YES;
    }
    return result;
}

static force_inline BOOL ValidArray(NSArray *array)
{
    BOOL result = NO;
    if (array && [array isKindOfClass:[NSArray class]] && [array count]) {
        result = YES;
    }
    return result;
}

static force_inline BOOL ValidDictionary(NSDictionary *dictionary)
{
    BOOL result = NO;
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        result = YES;
    }
    return result;
}

static force_inline BOOL ValidSet(id set)
{
    if (set && [set isKindOfClass:[NSDictionary class]]) {
        return YES;
    } else if (set && [set isKindOfClass:[NSArray class]] && [(NSArray*)set count] > 0 ) {
        return YES;
    } else if (set && [set isKindOfClass:[NSString class]] && ![trim(set) isEqualToString:@""]) {
        return YES;
    }
    else {
        return NO;
    }
}
