//
//  CustomerReceptionRecordViewController.m
//  saleclient
//
//  Created by Frank on 15/12/11.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerReceptionRecordViewController.h"
#import "ProductDetailViewController.h"
#import "CaseDetailViewController.h"
#import "OSNCustomerManager.h"
#import "RecordImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomerReceptionRecordViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *recordListView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recordTypeSelect;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, assign) NSUInteger selectTypeIndex;

@end

@implementation CustomerReceptionRecordViewController

static NSString * const reuseIdentifier = @"recordImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviewLayoutAndStyle];

    [self.recordTypeSelect addTarget:self action:@selector(changeRecordType:) forControlEvents:UIControlEventValueChanged];
    self.recordListView.dataSource = self;
    self.recordListView.delegate = self;
    [self.recordListView registerClass:[RecordImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self loadRecordData];
}

- (void)setSubviewLayoutAndStyle {
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
    [self.backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.backButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.backButton.layer.borderWidth = 1;
    self.backButton.layer.cornerRadius = 5;
    
    self.recordListView.backgroundColor = RGB(244, 244, 244);
}

- (void)loadRecordData {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
            paramters[@"customerId"] = receptionId;
            if (self.recordTypeSelect.selectedSegmentIndex == 1) {
                paramters[@"receptionType"] = @"OcnProduct";
            }
            else {
                paramters[@"receptionType"] = @"Exhibition";
            }
            OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
            NSArray *dataArr = [manager getCustomerReceptionRecordListWithParamters:paramters];
            [self.recordList removeAllObjects];
            
            if (dataArr && dataArr.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.recordList addObjectsFromArray:dataArr];
                    [self.recordListView reloadData];
                });
            }
        });
    }
}

- (void)changeRecordType:(UIGestureRecognizer *)gesture {
    if (self.recordTypeSelect.selectedSegmentIndex != self.selectTypeIndex) {
        self.selectTypeIndex = self.recordTypeSelect.selectedSegmentIndex;
        [self loadRecordData];
    }
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordImageCell *cell = (RecordImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.recordList[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    if (self.recordTypeSelect.selectedSegmentIndex == 0) {
        cell.name.text = dic[@"exhibitionName"];
        cell.recordId = dic[@"exhibitionId"];
    }
    else {
        cell.name.text = dic[@"ocnProductName"];
        cell.recordId = dic[@"ocnProductId"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordImageCell *cell = (RecordImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.recordTypeSelect.selectedSegmentIndex == 0) {
        CaseDetailViewController *caseDetail = [[CaseDetailViewController alloc] init];
        caseDetail.exhibitionId = cell.recordId;
        [self.navigationController pushViewController:caseDetail animated:NO];
    }
    else {
        ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
        productDetail.productId = cell.recordId;
        [self.navigationController pushViewController:productDetail animated:NO];
    }
}

#pragma mark - event

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)recordList {
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

@end
