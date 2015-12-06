//
//  ProductDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OSNProductManager.h"
#import "CaseDependCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *style;
@property (weak, nonatomic) IBOutlet UILabel *special;
@property (weak, nonatomic) IBOutlet UILabel *scene;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UICollectionView *caseListView;

@property (nonatomic, strong) NSMutableArray *caseList;

@end

@implementation ProductDetailViewController

static NSString * const reuseIdentifier = @"caseDependCellCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviewLayoutAndStyle];
    
    [self.caseListView registerClass:[CaseDependCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.caseListView.dataSource = self;
    
    self.caseList = [NSMutableArray array];
    [self loadProductDetailData];
}

- (void)setSubviewLayoutAndStyle {
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
    [self.backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.backButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.backButton.layer.borderWidth = 1;
    self.backButton.layer.cornerRadius = 5;
}

- (void)loadProductDetailData {
    if (self.productId) {
        dispatch_queue_t queue = dispatch_queue_create("loadCaseDetail", nil);
        dispatch_async(queue, ^{
            OSNProductManager *manager = [[OSNProductManager alloc] init];
            NSDictionary *dic = [manager getProductDetailWithId:self.productId];
            if (dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *productImageUrl = dic[@"productEntity"][@"imagePath"];
                    [self.image sd_setImageWithURL:[NSURL URLWithString:productImageUrl]];
                    self.name.text = [NSString stringWithFormat:@"【%@】", dic[@"productEntity"][@"ocnProductName"]];
                    self.code.text = dic[@"productEntity"][@"ocnProductCode"];
                    self.size.text = dic[@"productEntity"][@"ocnProductSpec"];
                    self.price.text = [NSString stringWithFormat:@"¥ %@", dic[@"productEntity"][@"ocnProductPrice"]];
                    self.special.text = dic[@"productEntity"][@"productCharacteristic"];
                    self.scene.text = dic[@"productEntity"][@"applyScope"];
                    NSMutableString *style = [NSMutableString stringWithString:dic[@"productEntity"][@"productStyleDesc"]];
                    [self string:style replaceString:@"&nbsp;" withString:@" "];
                    self.style.text = style;
                    self.info.text = dic[@"productEntity"][@"productDesc"];
                    
                    [self.caseList removeAllObjects];
                    [self.caseList addObjectsFromArray:dic[@"productCaseList"]];
                    [self.caseListView reloadData];
                });
            }
        });

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseDependCell *cell = (CaseDependCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.caseList[indexPath.row];
    cell.name.text = dic[@"exhibitionName"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    return cell;
}

- (void)string:(NSMutableString *)str replaceString:(NSString *)old withString:(NSString *)new {
    NSRange substr = [str rangeOfString:old];
    while (substr.location != NSNotFound) {
        [str replaceCharactersInRange:substr withString:new];
        substr = [str rangeOfString:old];
    }
}

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
