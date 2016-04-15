//
//  JKTopicModel.m
//  百思不得姐
//
//  Created by 张俊凯 on 16/3/29.
//  Copyright © 2016年 张俊凯. All rights reserved.
//

#import "JKTopicModel.h"
#import <MJExtension.h>
#import "JKCommentModel.h"
#import "JKUserModel.h"


@implementation JKTopicModel
{
    CGFloat _cellHeight;
}

//切换服务器返回名字
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"small_image":@"image0",
             @"large_image":@"image1",
             @"middle_image":@"image2",
             @"ID":@"id",
             @"top_cmt":@"top_cmt[0]",
             @"username":@"top_cmt[0].user.username"
             };
}


//模型本身的属性中有一个数组类型，数组里面有字典，就可以直接转换成模型
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"top_cmt":@"JKCommentModel"};
}

-(NSString *)create_time
{
    //现在开始处理时间 用一个日历来处理
    
    
    NSString * dealedString = nil;
    
    
    //起始时间 用时间格式化器把字符串格式化成时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate =[fmt dateFromString:_create_time];
    //NSDate *createDate =[fmt dateFromString:@"2016-03-30 11:16:50"];
    
    
    if ([createDate isThisYear])
    {
        if ([createDate isThisToday])
        {
            //今天怎么显示       1分钟内
            //            刚刚
            //            一小时内
            //            XX分钟前
            //            其他
            //            XX小时前
            NSDateComponents *comp = [[NSDate date] deltaFrom:createDate];
            if (comp.hour > 0)
            {
                dealedString = [NSString stringWithFormat:@"%zd小时前",comp.hour];
            }else if (comp.minute >0)
            {
                dealedString = [NSString stringWithFormat:@"%zd分钟前",comp.minute];
            }else
            {
                dealedString = @"刚刚";
            }
            
        }
        else if ([createDate isThisYestoday])
        {
            //昨天显示 昨天多少分多少秒
            //            NSDateComponents *comp = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:createDate];
            //            self.timeLabel.text = [NSString stringWithFormat:@"昨天%zd:%zd:%zd",comp.hour,comp.minute,comp.second];
            fmt.dateFormat = @"昨天 HH:mm:ss";
            dealedString = [fmt stringFromDate:createDate];
        }
        else
        {
            //            //昨天之前显示一个月内显示多少天前，一个月以上显示多少月以前
            //            NSDateComponents *comp =  [calendar components:NSCalendarUnitMonth |NSCalendarUnitDay fromDate:createDate toDate:nowDate options:0];
            //
            //            if (comp.month > 0)
            //            {
            //                self.timeLabel.text = [NSString stringWithFormat:@"%zd个月前",comp.month];
            //            }else
            //            {
            //                self.timeLabel.text = [NSString stringWithFormat:@"%zd天前",comp.day];
            //            }
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            dealedString = [fmt stringFromDate:createDate];
            
            
        }
    }
    else
    {
        dealedString = _create_time;
    }
    
    return dealedString;
    
}

-(CGFloat)cellHeight
{
    
    if (!_cellHeight)
    {
        
        //NSLog(@"\nbegin-----\n%@\n%@\n%@\nend-----",self.small_image,self.middle_image,self.large_image);
        //文字最大尺寸
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width-40;
        CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
        //文字高度
        CGFloat textH = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        //cell高度
        _cellHeight = JKTopicCellTextY+textH+JKTopicCellMargin;
        //根据帖子类型计算高度
        if (self.type == JKTopicTypePicture)//图片帖子
        {
            
            if (self.width != 0 && self.height != 0) {
                CGFloat pictureW =maxWidth;
                
                CGFloat pictureH = pictureW * self.height /self.width;
                
                //判断长图 就只给250的高度
                if (pictureH >= JKTopicCellPictureMaxH)
                {
                    pictureH = JKTopicCellPictureNormalH;
                    self.bigPicture = YES;//大图
                }
                _cellHeight += pictureH + JKTopicCellMargin;
                
                CGFloat pictureX = JKTopicCellMargin;
                //文字的Y 加上 文字的高度 加上 间距
                CGFloat pictureY = JKTopicCellTextY + textH + JKTopicCellMargin;
                
                _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            }
            
            
        }else if (self.type == JKTopicTypeVoice)//声音帖子
        {
            
            CGFloat voiceX  = JKTopicCellMargin;
            CGFloat voiceY  = JKTopicCellTextY + textH + JKTopicCellMargin;
            CGFloat voiceW  = maxWidth;
            CGFloat voiceH  = voiceW* self.height /self.width;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
             _cellHeight += voiceH + JKTopicCellMargin;
        }else if (self.type == JKTopicTypeVideo)//视频帖子
        {
            
            CGFloat videoX  = JKTopicCellMargin;
            CGFloat videoY  = JKTopicCellTextY + textH + JKTopicCellMargin;
            CGFloat videoW  = maxWidth;
            CGFloat videoH  = videoW* self.height /self.width;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + JKTopicCellMargin;
        }
        
        //如果有最热评论，就加一些高度
        JKCommentModel * commentModel = self.top_cmt;
        if (commentModel) {
            NSString *content = [NSString stringWithFormat:@"%@:%@",commentModel.user.username,commentModel.content];
           CGFloat contentH = [content boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
            _cellHeight += JKTopicCellTopcmtTitleH+contentH+JKTopicCellMargin;
        }
        
        _cellHeight += JKTopicCellBottomBar;
        _cellHeight += JKTopicCellMargin;
        
        
    }
    //这里不是cell的尺寸，是cell空间的尺寸，cell拿过去用，总会减去10，所以这里算出来正好的高度，要加上10 才是cell正好的高度
    
    return _cellHeight;
    
    
}

@end
