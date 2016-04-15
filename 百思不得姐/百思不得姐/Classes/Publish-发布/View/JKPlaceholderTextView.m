//
//  JKPlaceholderTextView.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/7.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKPlaceholderTextView.h"
@interface JKPlaceholderTextView()

@property(nonatomic,strong)UILabel *placeholderLabel;

@end

@implementation JKPlaceholderTextView


- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];
        label.x = 3;
        label.y = 7;
        label.numberOfLines = 0;
        //label.backgroundColor = [UIColor yellowColor];
        _placeholderLabel =label;
    }
    return _placeholderLabel;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //开启弹簧效果
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeholder = @"默认占位文字";
        [JKNoteCenter addObserver:self selector:@selector(didChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

//label的算尺寸
-(void)updatePlaceholderSize
{
    CGSize size = CGSizeMake(JKScreenW - self.placeholderLabel.x * 2, 500);
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    size = [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    self.placeholderLabel.size = size;
    
}

-(void)didChanged
{
    self.placeholderLabel.hidden = self.hasText;
}


//字体的变更
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self updatePlaceholderSize];
    
}
//内容的变更
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderSize];
    
}
//颜色的变更
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

//通过字符串赋值的内容需要手动开启通知
-(void)setText:(NSString *)text
{
    [super setText:text];
    [self didChanged];
    
}
////为了完善，添加上富文本
//-(void)setAttributedText:(NSAttributedString *)attributedText
//{
//    [super setAttributedText:attributedText];
//    
//}

//移除通知中心
-(void)dealloc
{
    [JKNoteCenter removeObserver:self];
}

@end
