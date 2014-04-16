//
//  MOItemView.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/7/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import "MOItemView.h"
#import "UIView+MOViewAdditions.h"

@implementation MOItemView
@synthesize delegate;
@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
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
- (void) setShake:(BOOL)on
{
    if (on) {
        [self shakeStatus:YES];
    }else{
        [self shakeStatus:NO];
    }
}

- (void) buttonAction:(UIButton *)btn
{
    [delegate itemDidDeletedWith:btn];
}

- (void) dealloc
{
    [super dealloc];
    [button release];
}
@end
