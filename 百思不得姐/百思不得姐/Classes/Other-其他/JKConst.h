
#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const JKTitleViewH;

UIKIT_EXTERN CGFloat const JKTitleViewY;

//cell的一些常用高度
UIKIT_EXTERN CGFloat const JKTopicCellMargin;
UIKIT_EXTERN CGFloat const JKTopicCellBottomBar;
UIKIT_EXTERN CGFloat const JKTopicCellTextY;

//cell里面 图片显示的最大高度，
UIKIT_EXTERN CGFloat const JKTopicCellPictureMaxH;
//cell里面 图片显示的正常高度
UIKIT_EXTERN CGFloat const JKTopicCellPictureNormalH;
//cell里面 最热评论标题的高度
UIKIT_EXTERN CGFloat const JKTopicCellTopcmtTitleH;

//JKUserModel 性别属性值
UIKIT_EXTERN NSString *const JKUserSexMale;
UIKIT_EXTERN NSString *const JKUserSexFemale;

//建立一个全局的通知
UIKIT_EXTERN NSString *const JKTabBarDidSelectedNotification;
UIKIT_EXTERN NSString *const JKFooterViewHeightChangedNotification;

//标签的间距
UIKIT_EXTERN CGFloat const JKTagMargin;

//标签的高度
UIKIT_EXTERN CGFloat const JKTagH;

typedef enum {
    JKTopicTypeALL = 1,
    JKTopicTypeVideo = 41,
    JKTopicTypeVoice = 31,
    JKTopicTypePicture = 10,
    JKTopicTypeWord = 29
    
}JKTopicType;