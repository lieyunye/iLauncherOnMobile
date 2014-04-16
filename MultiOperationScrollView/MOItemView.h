//
//  MOItemView.h
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/7/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MOItemViewDelegate<NSObject>
- (void) itemDidDeletedWith:(UIButton *)delButton;
@end
@interface MOItemView : UIView
{
    UIButton *button;
    id<MOItemViewDelegate> delegate;

}
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, assign)id<MOItemViewDelegate> delegate;
- (void) setShake:(BOOL)on;

@end
