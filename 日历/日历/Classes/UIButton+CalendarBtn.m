//
//  UIButton+CalendarBtn.m
//  日历
//
//  Created by  王伟 on 16/8/16.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "UIButton+CalendarBtn.h"
#import <objc/runtime.h>

@implementation UIButton (CalendarBtn)
static const char btnKey;
- (void)buttonClick:(Click)click {
    if (click) {
        objc_setAssociatedObject(self, &btnKey, click, OBJC_ASSOCIATION_COPY);
    }
    
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    Click click = objc_getAssociatedObject(self, &btnKey);
    click();
}

@end
