//
//  UIBarButtonItem+JKExtension.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/22.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JKExtension)

+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
