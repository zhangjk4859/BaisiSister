//
//  JKTextField.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/27.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTextField.h"
#import <objc/runtime.h>
static NSString * const JKplaceholderLabelColor = @"_placeholderLabel.textColor";


@interface JKTextField ()


@end


@implementation JKTextField

+(void)initialize
{
    //[self getProperties];
    //[self getIvars];
}


+(void)getProperties
{
    
    unsigned int count = 0;
    //指向数组第一个元素的指针 类型是那种类型的
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i < count; i++)
    {
        //objc_property_t property = *(properties+i);
        objc_property_t property = properties[i];
        printf("%s   <-------->   %s\n",property_getAttributes(property),              property_getName(property));
    }
    
    free(properties);
    
}

+(void)getIvars
{
    
    unsigned int count = 0;
    //指向数组第一个元素的指针 类型是那种类型的
    Ivar *Ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i < count; i++)
    {
        //objc_property_t property = *(properties+i);
        Ivar ivar = Ivars[i];
        printf("%s   <-------->   %s\n",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    
    free(Ivars);
    
}



//用set方法实现内部颜色的改变，公开一个接口
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKeyPath:JKplaceholderLabelColor];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置光标颜色
        self.tintColor = self.textColor;
        
        //设置默认文字颜色为灰色
        [self resignFirstResponder];
    }
    return self;
}

//在awake from nib 里面操作 进行初始化
-(void)awakeFromNib
{

    
    //设置光标颜色
    self.tintColor = self.textColor;
    
    //设置默认文字颜色为灰色
    [self resignFirstResponder];

}



//聚焦的时候把文字变成白色
-(BOOL)becomeFirstResponder
{
     [self setValue:self.textColor forKeyPath:JKplaceholderLabelColor];
    
    return [super becomeFirstResponder];
   
}

//离开的时候变成灰色
-(BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:JKplaceholderLabelColor];
    
    return [super resignFirstResponder];
    
}

@end
