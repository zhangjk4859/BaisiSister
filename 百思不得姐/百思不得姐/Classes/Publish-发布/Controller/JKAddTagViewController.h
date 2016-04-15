//
//  JKAddTagViewController.h
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKAddTagViewController : UIViewController
/**
 *  用block把数组传出去
 */
@property(nonatomic,copy)void(^tagsBlock)(NSArray *tags);

@property(nonatomic,strong)NSArray *tags;
@end
