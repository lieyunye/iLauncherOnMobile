//
//  MOView.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/5/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#define animateDuration 0.2

#import "MOView.h"
#import "UIGestureRecognizer+MOViewAdditions.h"
static const UIViewAnimationOptions kDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

@implementation MOView
@synthesize mainView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        viewArray = [[NSMutableArray alloc] init];
        viewFrameArray = [[NSMutableArray alloc] init];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        overView = [[UIView alloc] initWithFrame:self.bounds];
        overView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        currentPage = 0;
        
        pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height - 64 - 40, _scrollView.frame.size.width, 40)];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:pageLabel];
        pageLabel.text = @"0";
        [self bringSubviewToFront:pageLabel];
        
        moStrategy = [[MOStrategy alloc] init];
        moStrategy.pageSize = CGSizeMake(self.frame.size.width, kMOImageViewHight * 3);
        moStrategy.itemCol = 2;
        moStrategy.itemNumber = 6;
        
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_scrollView addGestureRecognizer:pan];
        pan.delegate = self;
        
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sortingLongPressGestureUpdated:)];
        longPress.numberOfTouchesRequired = 1;
        longPress.delegate = self;
        [_scrollView addGestureRecognizer:longPress];
        
        
        UIPanGestureRecognizer *panGestureRecognizer = nil;
        if ([_scrollView respondsToSelector:@selector(panGestureRecognizer)]) // iOS5 only
        {
            panGestureRecognizer = _scrollView.panGestureRecognizer;
        }
        else
        {
            for (UIGestureRecognizer *gestureRecognizer in _scrollView.gestureRecognizers)
            {
                if ([gestureRecognizer  isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")])
                {
                    panGestureRecognizer = (UIPanGestureRecognizer *) gestureRecognizer;
                }
            }
        }
        [panGestureRecognizer setMaximumNumberOfTouches:1];
        [panGestureRecognizer requireGestureRecognizerToFail:pan];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentPage = scrollView.contentOffset.x / self.frame.size.width;
    pageLabel.text = [NSString stringWithFormat:@"%d",currentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
//    NSLog(@"%s",__FUNCTION__);
    currentPage = scrollView.contentOffset.x / self.frame.size.width;
    pageLabel.text = [NSString stringWithFormat:@"%d",currentPage];
}

-  (void) addNewItemView
{
    MOImageView *moImageView = [[MOImageView alloc] initWithFrame:CGRectMake(num*(kMOImageViewWidth+kMOImageViewInterval), 0, kMOImageViewWidth, kMOImageViewHight)];
    [moImageView.moItemView.button setTitle:[NSString stringWithFormat:@"%d",num] forState:UIControlStateNormal];
    moImageView.moItemView.delegate = self;
    moStrategy.itemSize = moImageView.moItemView.button.frame.size;
    [_scrollView addSubview:moImageView];
    [viewArray addObject:moImageView];
    num++;
    int index = [viewArray indexOfObject:moImageView];
    int row = index / 2;
    int mod = index % 2;
    int pages = index / 6;
//    NSLog(@"index==%d------row==%d--------mod==%d----pages==%d",index,row,mod,pages);
    _scrollView.contentSize = CGSizeMake((pages + 1) * self.frame.size.width, self.frame.size.height);
    
    CGRect positionFrame = CGRectMake(mod*kMOImageViewWidth + pages * self.frame.size.width, row*kMOImageViewHight-pages*3*kMOImageViewHight, kMOImageViewWidth, kMOImageViewHight);
    moImageView.frame = positionFrame;
    [viewFrameArray addObject:NSStringFromCGRect(moImageView.frame)];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL valid = YES;
    //    BOOL isScrolling = scrollView.isDragging || scrollView.isDecelerating;
    
    //    if (gestureRecognizer == longPress)
    //    {
    //        valid = !isScrolling;
    //    }
    if (gestureRecognizer == pan)
    {
        valid = (_moImageView != nil && [longPress hasRecognizedValidGesture]);
    }
    
    return valid;
}


- (void)sortingLongPressGestureUpdated:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self addSubview:overView];
            CGPoint location = [longPressGesture locationInView:_scrollView];
            [self itemDidMovingWithPosition:location];
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGPoint location = [longPressGesture locationInView:_scrollView];
            [self itemDidEndMovingWithPosition:location];
            [overView removeFromSuperview];
            break;
        }
        default:
            break;
    }
}


- (void)pan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint locationInScroll = [panGesture locationInView:_scrollView];
    curLocation = locationInScroll;
    CGPoint selectedLocation = [panGesture locationInView:overView];
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
            [checkStateTimer invalidate];
            [self swapItemDidEndPosition:locationInScroll];
            break;
        case UIGestureRecognizerStateCancelled:
            [checkStateTimer invalidate];
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
        case UIGestureRecognizerStateFailed:
        {
            [checkStateTimer invalidate];
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            checkStateTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkGestureState) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:checkStateTimer forMode:NSRunLoopCommonModes];
            beginLocation = locationInScroll.x;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            moExchangedMovingImageView.layer.position = selectedLocation;
            if (locationInScroll.x < beginLocation) {//left direction
                if (locationInScroll.x < currentPage * self.frame.size.width + 20 && locationInScroll.x > 0) {
                    currentPage --;
                    [_scrollView scrollRectToVisible:CGRectMake((currentPage) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                    [self swapItemPosition:locationInScroll];
                    break;
                }
                if (locationInScroll.x > (currentPage + 1) * self.frame.size.width - 20) {
                    currentPage ++;
                    [_scrollView scrollRectToVisible:CGRectMake((currentPage) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                    [self swapItemPosition:locationInScroll];
                    break;
                }
            }else {
                if (locationInScroll.x > (currentPage + 1) * self.frame.size.width - 20) {
                    currentPage ++;
                    [_scrollView scrollRectToVisible:CGRectMake((currentPage) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                    [self swapItemPosition:locationInScroll];
                    break;
                }
                if (locationInScroll.x < currentPage * self.frame.size.width + 20 && locationInScroll.x > 0) {
                    currentPage --;
                    [_scrollView scrollRectToVisible:CGRectMake((currentPage) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                    [self swapItemPosition:locationInScroll];
                    break;
                }
            }
//            [self swapItemPosition:locationInScroll];
            break;
        }
        default:
            break;
    }
}


- (void)checkGestureState
{
    CGPoint selectedLocation = [pan locationInView:overView];
//    NSLog(@"%@",NSStringFromCGPoint(selectedLocation));
    
    if (lastPosion.x != selectedLocation.x || lastPosion.y != selectedLocation.y) {
    }else {
        //not moving
        [self swapItemPosition:curLocation];
        [self swapItemPositionAnimation];
    }
    
    lastPosion = selectedLocation;
}

- (void) swapItemPositionAnimation
{
    if (_fromIndex < 0 || _toIndex >= [viewArray count]) {
        return;
    }
    if (_fromIndex < _toIndex) {
        for (int i = _fromIndex; i < _toIndex; i++) {
            CGRect toMoImageViewFrame = CGRectFromString([viewFrameArray objectAtIndex:i]);
            MOImageView *fromMoImageView = [viewArray objectAtIndex:i+1];
            [UIView animateWithDuration:animateDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 fromMoImageView.frame = toMoImageViewFrame;
                             }
                             completion:^(BOOL finished){
                                 
                                 if (i == _toIndex - 1) {
                                     [self swapItemDidEndPositionAnimation:_toIndex];
                                     _fromIndex = _toIndex;
//                                     lastToIndex = _toIndex;
                                 }
                                 
                                 
                             }];
        }
    }else if (_fromIndex > _toIndex) {
        for (int i = _fromIndex; i > _toIndex; i--) {
            CGRect toMoImageViewFrame = CGRectFromString([viewFrameArray objectAtIndex:i]);
            MOImageView *fromMoImageView = [viewArray objectAtIndex:i-1];
            [UIView animateWithDuration:animateDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 fromMoImageView.frame = toMoImageViewFrame;
                             }
                             completion:^(BOOL finished){
                                 if (i == _toIndex + 1) {
                                     [self swapItemDidEndPositionAnimation:_toIndex];
                                     _fromIndex = _toIndex;
//                                     lastToIndex = _toIndex;
                                 }
                             }];
        }
    }
}


- (void) swapItemPosition:(CGPoint)position
{
    int toIndex = [moStrategy itemIndexFromPosition:position];
    _toIndex = toIndex;
    if (toIndex >= [viewArray count]) {
        return;
    }
}

- (void) swapItemDidEndPosition:(CGPoint)position
{
//    int toIndex = [moStrategy itemIndexFromPosition:position];
//    NSLog(@"lastToIndex==%dtoIndex==%d",lastToIndex,toIndex);
//    if (toIndex >= [viewArray count]) {
//        toIndex = lastToIndex;
//        [self swapItemDidEndPositionAnimation:toIndex];
//        return;
//    }
//    [self swapItemDidEndPositionAnimation:toIndex];
    
    [moExchangedMovingImageView removeFromSuperview];
    [moExchangedMovingImageView.moItemView setShake:NO];
    [_scrollView addSubview:_moImageView];
    
}

- (void) swapItemDidEndPositionAnimation:(int)toIndex
{
    NSLog(@"fromIndex=%d-----toIndex=%d----lastToIndex=====%d",_fromIndex,_toIndex,lastToIndex);
    CGRect toMoImageViewFrame = CGRectFromString([viewFrameArray objectAtIndex:toIndex]);
//    moExchangedMovingImageView.frame = toMoImageViewFrame;
    _moImageView.frame = toMoImageViewFrame;

    
    if (_fromIndex < toIndex) {
        //  重新排序
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < _fromIndex; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        for (int i = _fromIndex+1; i <= toIndex; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        [tempArray addObject:[viewArray objectAtIndex:_fromIndex]];
        
        for (int i = toIndex+1; i < [viewArray count]; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        
        [viewArray removeAllObjects];
        [viewArray addObjectsFromArray:tempArray];
    }else if (_fromIndex > toIndex){

        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < toIndex; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        
        [tempArray addObject:[viewArray objectAtIndex:_fromIndex]];
        
        for (int i = toIndex; i < _fromIndex; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        
        for (int i = _fromIndex + 1; i < [viewArray count]; i++) {
            [tempArray addObject:[viewArray objectAtIndex:i]];
        }
        
        [viewArray removeAllObjects];
        [viewArray addObjectsFromArray:tempArray];
    }
//    NSLog(@"fromIndex=%d-----toIndex=%d----%@",_fromIndex,_toIndex,viewArray);
}

- (void) exchageItemAtIndex:(NSUInteger)toIndex withItemAtIndex:(NSUInteger)fromIndex
{
    [viewArray exchangeObjectAtIndex:toIndex withObjectAtIndex:fromIndex];
}

- (void) itemDidMovingWithPosition:(CGPoint)point
{
    _fromIndex = [moStrategy itemIndexFromPosition:point];
    _toIndex = _fromIndex;
    if (_fromIndex >= [viewArray count]) {
        return;
    }
//    clickIndex = curMovingIndex;
    _moImageView = [viewArray objectAtIndex:_fromIndex];
    [_moImageView removeFromSuperview];
    
    CGRect exchangedFrame = [_scrollView convertRect:_moImageView.frame toView:overView];
    moExchangedMovingImageView = [[MOImageView alloc] initWithFrame:exchangedFrame];
    [moExchangedMovingImageView.moItemView setShake:YES];
    [overView addSubview:moExchangedMovingImageView];
    
}

- (void) itemDidEndMovingWithPosition:(CGPoint)point
{
    [moExchangedMovingImageView removeFromSuperview];
    [moExchangedMovingImageView.moItemView setShake:NO];
    [_scrollView addSubview:_moImageView];
    
}

- (void) itemDidDeletedWith:(UIButton *)delButton
{
    tmpDeletedView = [[delButton superview] superview];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [actionSheet showInView:self];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             tmpDeletedView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [tmpDeletedView removeFromSuperview];
                             int index = [viewArray indexOfObject:tmpDeletedView];
                             __block CGPoint center = tmpDeletedView.center;
                             
                             void (^layoutBlock)(void) = ^{
                                 for (int i = index+1; i < [viewArray count]; i++) {
                                     MOImageView *tmpMOImageView = [viewArray objectAtIndex:i];
                                     CGPoint nextCenter = tmpMOImageView.center;
                                     tmpMOImageView.center = center;
                                     center = nextCenter;
                                 }
                                 
                             };
                             [UIView animateWithDuration:0.3
                                                   delay:0
                                                 options:kDefaultAnimationOptions
                                              animations:^{
                                                  layoutBlock();
                                              }
                                              completion:^(BOOL finished){
                                                  [viewArray removeObject:tmpDeletedView];
                                                  num--;
                                                  int page = num/4;
                                                  int mod = num%4;
                                                  [UIView animateWithDuration:0.3
                                                                   animations:^{
                                                                       _scrollView.contentSize = CGSizeMake(self.bounds.size.width*page+(kMOImageViewWidth+10)*mod, 180);
                                                                   }completion:nil];
                                                  
                                              }
                              ];
                         }];
    }
}
@end
