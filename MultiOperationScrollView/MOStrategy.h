//
//  MOStrategy.h
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/6/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOStrategy : NSObject
{
    CGSize itemSize;
    UIEdgeInsets edgeInsets;
}
@property (nonatomic, assign) int itemNumber;
@property (nonatomic, assign) int itemCol;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
- (int) itemIndexFromPosition:(CGPoint)point;
@end
