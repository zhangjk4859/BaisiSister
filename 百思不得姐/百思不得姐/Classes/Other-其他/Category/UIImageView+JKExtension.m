//
//  UIImageView+JKExtension.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "UIImageView+JKExtension.h"
#import <UIImageView+WebCache.h>
#import "UIImage+JKExtension.h"

@implementation UIImageView (JKExtension)
-(void)setHeader:(NSString *)url
{
    //头像切割成圆角
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage: placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       self.image = image?[image circleImage]:placeholder;
        
    }];
}
@end
