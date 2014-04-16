//
//  TestViewController.m
//  MultiOperationScrollView
//
//  Created by lieyunye on 11/5/12.
//  Copyright (c) 2012 lieyunye. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [moView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    moView = [[MOView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height)];
    moView.mainView = self.navigationController.view;
    [self.view addSubview:moView];
    int n = 6 * 3;
    for (int i = 0; i < n; i++) {
        [moView addNewItemView];
    }

//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.backgroundColor = [UIColor blueColor];
//    scrollView.pagingEnabled = YES;
//    scrollView.contentSize = CGSizeMake(320*2, self.view.frame.size.height);
//    [self.view addSubview:scrollView];
//
//    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    fView.backgroundColor = [UIColor grayColor];
//    [scrollView addSubview:fView];
//    
//    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(320 + 100, 100, 100, 100)];
//    sView.backgroundColor = [UIColor grayColor];
//    [scrollView addSubview:sView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
