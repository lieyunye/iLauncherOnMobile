//
//  MOStrategy.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/6/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import "MOStrategy.h"

@implementation MOStrategy
@synthesize itemSize;
@synthesize edgeInsets;
- (int) itemIndexFromPosition:(CGPoint)point
{
    int pages = point.x / _pageSize.width;
    int row = point.y / itemSize.height;
    int col = (point.x-pages*_pageSize.width) / itemSize.width;
    int index = _itemCol * row + col + pages * _itemNumber;
//    NSLog(@"row==%d----col==%d-------index=%d",row,col,index);
    return index;
}
@end
