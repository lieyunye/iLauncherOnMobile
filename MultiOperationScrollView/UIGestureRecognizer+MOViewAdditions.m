//
//  UIGestureRecognizer+MOViewAdditions.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/6/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//
//

#import "UIGestureRecognizer+MOViewAdditions.h"

@implementation UIGestureRecognizer (MOViewAdditions)

- (void)end
{
    BOOL currentStatus = self.enabled;
    self.enabled = NO;
    self.enabled = currentStatus;
}

- (BOOL)hasRecognizedValidGesture
{
    return (self.state == UIGestureRecognizerStateChanged || self.state == UIGestureRecognizerStateBegan);
}

@end
