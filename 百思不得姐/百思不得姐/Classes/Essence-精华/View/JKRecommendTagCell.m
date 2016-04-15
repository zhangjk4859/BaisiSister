//
//  JKRecommendTagCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/26.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKRecommendTagCell.h"
#import <UIImageView+WebCache.h>

@interface  JKRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

@implementation JKRecommendTagCell

//初始化模型的方法
-(void)setTagModel:(JKRecommendTagModel *)tagModel
{
    _tagModel = tagModel;
    self.nameLabel.text= tagModel.theme_name;
    [self.headImageView setHeader:tagModel.image_list];
    
    
    NSString *subNumber = nil;
    
    if (tagModel.sub_number < 10000)
    {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",tagModel.sub_number];
    }else
    {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",tagModel.sub_number / 10000.0];
    }
    
    
    self.subLabel.text = subNumber;
    
}

//CEL更改大小调用的是这个函数  tableview会调用这个函数，把XY设置为零
-(void)setFrame:(CGRect)frame
{
    //JKLog(@"setFrame-------%@",NSStringFromCGRect(frame));
    //外面传进来是多少我不管，我拦截更改掉，传给父类，
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
