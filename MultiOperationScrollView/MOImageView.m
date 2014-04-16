//
//  MOImageView.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/6/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import "MOImageView.h"
@implementation MOImageView
@synthesize moItemView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        moItemView = [[MOItemView alloc] initWithFrame:self.bounds];
        [self addSubview:moItemView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) dealloc
{
    [super dealloc];
    [moItemView release];
}




@end
