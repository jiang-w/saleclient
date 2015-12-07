//
//  MasterViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "MasterViewController.h"
#import "CaseListViewController.h"
#import "ProductListViewController.h"
#import "BuildingListViewController.h"
#import "CustomerListViewController.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *caseBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *clientBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *keywordText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation MasterViewController
{
    NSArray *_btnArr;
    NSMutableDictionary *_controllerDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnArr = @[self.caseBtn, self.areaBtn, self.productBtn, self.clientBtn];
    _controllerDic = [NSMutableDictionary dictionary];
    
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.frame);
    self.scrollView.contentSize = CGSizeMake(pageWidth * _btnArr.count, pageHeight);
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setCurrentDisplayViewWithIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeDisplayView:(id)sender {
    if (sender == self.homeBtn) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSInteger index = [_btnArr indexOfObject:sender];
        [self setCurrentDisplayViewWithIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    NSInteger index = scroll.contentOffset.x / scroll.frame.size.width;
    [self setCurrentDisplayViewWithIndex:index];
}

- (void)setCurrentDisplayViewWithIndex:(NSInteger)index {
    self.currentIndex = index;
    if (self.currentIndex == 1) {
        self.keywordText.hidden = YES;
        self.searchButton.hidden = YES;
    }
    else {
        self.keywordText.hidden = NO;
        self.searchButton.hidden = NO;
    }
    
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btn = [_btnArr objectAtIndex:index];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if (!_controllerDic[@(index)]) {
        [self addControllerWithIndex:index];
    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
}

- (void)addControllerWithIndex:(NSInteger)index {
    UIViewController *contr;
    switch (index) {
        case 0:
            contr = [[CaseListViewController alloc] init];
            break;
        case 1:
            contr = [[BuildingListViewController alloc] init];
            break;
        case 2:
            contr = [[ProductListViewController alloc] init];
            break;
        case 3:
            contr = [[CustomerListViewController alloc] init];
            break;
        default:
            return;
    }
    _controllerDic[@(index)] = contr;
    contr.view.frame = CGRectMake(index * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:contr.view];
}

@end
