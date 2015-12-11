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
#import "CaseDetailViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageShowView.h"
#import "LewPopupViewController.h"
#import "OSNCustomerManager.h"

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
    self.caseListView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProductImage:)];
    [self.image addGestureRecognizer:tap];
    self.image.userInteractionEnabled = YES;
    
    [self loadProductDetailData];
}


#pragma mark - private

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
                    
                    if (self.caseList) {
                        [self.caseList removeAllObjects];
                    }
                    else {
                        self.caseList = [NSMutableArray array];
                    }
                    [self.caseList addObjectsFromArray:dic[@"productCaseList"]];
                    [self.caseListView reloadData];
                });
            }
        });
    }
}

- (void)string:(NSMutableString *)str replaceString:(NSString *)old withString:(NSString *)new {
    NSRange substr = [str rangeOfString:old];
    while (substr.location != NSNotFound) {
        [str replaceCharactersInRange:substr withString:new];
        substr = [str rangeOfString:old];
    }
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseDependCell *cell = (CaseDependCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.caseList[indexPath.row];
    cell.name.text = dic[@"exhibitionName"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    cell.exhibitionId = dic[@"exhibitionId"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseDependCell *cell = (CaseDependCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AppDelegate *appDelegate = OSNMainDelegate;
    if ([appDelegate.mainNav isContainViewControllerForClass:[CaseDetailViewController class]]) {
        NSLog(@"Contain CaseDetailViewController");
        [appDelegate.mainNav popViewControllerForClass:[CaseDetailViewController class]];
    }
    CaseDetailViewController *caseDetail = [[CaseDetailViewController alloc] init];
    caseDetail.exhibitionId = cell.exhibitionId;
    [appDelegate.mainNav pushViewController:caseDetail animated:NO];
}


#pragma mark - event

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapProductImage:(UITapGestureRecognizer *)gesture {
    ImageShowView *imageShow = [[ImageShowView alloc] init];
    imageShow.imageView.image = self.image.image;
    imageShow.parentVC = self;
    
    [self lew_presentPopupView:imageShow animation:[LewPopupViewAnimationFade new] dismissed:nil];
}

- (IBAction)collectButtonClick:(id)sender {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"customerId"] = receptionId;
        paramters[@"collectType"] = @"OcnProduct";
        paramters[@"goodsId"] = self.productId;
        OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
        NSString *result = [manager customerCollectGoodsWithParameters:paramters];
        if ([result isEqualToString:@"alreadyCollect"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已添加此收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        if ([result isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"产品收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前还未接待客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)u3dButtonClick:(id)sender {
    
}

@end
