//
//  MOImageView.h
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/6/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOItemView.h"


@interface MOImageView : UIView
{
    MOItemView *moItemView;
}
@property (nonatomic, retain) MOItemView *moItemView;
@end
