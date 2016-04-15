//
//  JKMeCell.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/4/6.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKMeCell.h"

@implementation JKMeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];

        
        self.backgroundView = imageView;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 25;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.height*0.5;
    
   // self.textLabel.backgroundColor = [UIColor redColor];
    
    //标签的X值 等于 图片的X值加10
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + JKTopicCellMargin;
}

//-(void)setFrame:(CGRect)frame
//{  //让第一个Y值往上挪25
//    frame.origin.y -= (35 - JKTopicCellMargin);
//    
//    
//    [super setFrame:frame];
//}

@end
