//
//  ProductListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductListViewController.h"
#import "OSNProductManager.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self.view setFrame:frame];
        self.view.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OSNProductManager *manager = [[OSNProductManager alloc] init];
    [manager getProductTagList];
}


@end
