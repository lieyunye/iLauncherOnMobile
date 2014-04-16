//
//  MOView.h
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/5/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#define kMOImageViewWidth 160
#define kMOImageViewHight 154
#define kMOImageViewInterval 0

#import <UIKit/UIKit.h>
#import "MOStrategy.h"
#import "MOImageView.h"

@interface MOView : UIView<UIGestureRecognizerDelegate,MOItemViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    int num;
    MOStrategy *moStrategy;
    MOImageView *_moImageView;
    UIView *mainView;
    UIPanGestureRecognizer *pan;
    UILongPressGestureRecognizer *longPress;
    int curMovingIndex;
    CGPoint movingCenter;
    CGRect movingFrame;
    NSMutableArray *viewArray;
    NSMutableArray *viewFrameArray;
    UIView *tmpDeletedView;
    int clickIndex;
    UIView *overView;
    int currentPage;
    CGFloat beginLocation;
    CGPoint curLocation;
    MOImageView *moExchangedMovingImageView;
    int lastToIndex;
    CGPoint lastPosion;

    
    NSTimer *checkStateTimer;
    int _fromIndex;
    int _toIndex;
    
    UILabel *pageLabel;
    
}
@property (nonatomic, retain) UIView *mainView;
-  (void) addNewItemView;

@end
