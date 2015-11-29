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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    OSNProductManager *manager = [[OSNProductManager alloc] init];
    [manager getProductTagList];
}


@end
