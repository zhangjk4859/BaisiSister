//
//  JKRecommedCategoryCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/24.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKRecommedCategoryCell.h"
#import "JKRecommedCategory.h"

@interface JKRecommedCategoryCell()

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end

@implementation JKRecommedCategoryCell

-(void)setCategoryModel:(JKRecommedCategory *)categoryModel
{
    _categoryModel = categoryModel;
    self.textLabel.text = categoryModel.name;
}




//进行一些自定义设置
- (void)awakeFromNib {
    self.backgroundColor = JKRGBColor(244, 244, 244);
    
    //设置指示器颜色和文字相同
    self.selectedIndicator.backgroundColor = JKRGBColor(219, 21, 26);
    
    //让cell选中的时候不变灰
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = view;
    
}


// 在布局里面把label的高度调整一下
-(void)layoutSubviews
{
    [super layoutSubviews];
    //重新调整内部label的高度和位置
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2*self.textLabel.y;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //JKLog(@"%@---------%d",self.categoryModel.name,selected);
    //当选中的时候文字显示红色
    
    //这是长代码显示效果
//    if (selected) {
//        self.textLabel.textColor = JKRGBColor(219, 21, 26);
//        self.selectedIndicator.hidden = NO;
//    }else
//    {
//        self.textLabel.textColor = JKRGBColor(78, 78, 78);
//        self.selectedIndicator.hidden = YES;
//    }
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected?self.selectedIndicator.backgroundColor:JKRGBColor(78, 78, 78);
}

@end
