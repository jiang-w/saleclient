//
//  CaseDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/12/1.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CaseDetailProductCell.h"
#import "OSNCaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaseDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *crowdName;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *tag;
@property (weak, nonatomic) IBOutlet UILabel *building;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UITableView *productTable;

@property (nonatomic, strong) NSMutableArray *productList;

@end

@implementation CaseDetailViewController

static NSString * const cellReuseIdentifier = @"productCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productList = [NSMutableArray array];
    
    self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
    [self.backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.cornerRadius = 5;
    
    self.productTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTable.bounces = NO;
    self.productTable.dataSource = self;
    [self.productTable registerClass:[CaseDetailProductCell class] forCellReuseIdentifier:cellReuseIdentifier];
    
    [self loadCaseDetailData];
}

- (void)loadCaseDetailData {
    if (self.exhibitionId) {
        dispatch_queue_t queue = dispatch_queue_create("loadCaseDetail", nil);
        dispatch_async(queue, ^{
            OSNCaseManager *manager = [[OSNCaseManager alloc] init];
            NSDictionary *dic = [manager getCaseDetailWithExhibitionId:self.exhibitionId];
            if (dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.name.text = dic[@"caseDetail"][@"exhibitionName"];
                    [self.personImage sd_setImageWithURL:[NSURL URLWithString:dic[@"caseDetail"][@"personImagePath"]]];
                    self.personName.text = dic[@"caseDetail"][@"personName"];
                    self.crowdName.text = dic[@"caseDetail"][@"crowdName"];
                    
                    NSMutableString *tags = [NSMutableString stringWithFormat:@"%@ %@ %@", dic[@"caseDetail"][@"roomName"], dic[@"caseDetail"][@"styleName"], dic[@"caseDetail"][@"houseTypeName"]];
                    [self string:tags replaceString:@"&nbsp;" withString:@""];
                    self.tag.text = tags;
                    self.building.text = dic[@"caseAssocBuilding"][@"buildingName"];
                    
                    NSString *caseImageUrl = [[dic[@"caseImageList"] firstObject] objectForKey:@"imagePath"];
                    [self.caseImage sd_setImageWithURL:[NSURL URLWithString:caseImageUrl]];
                    [self.image2 sd_setImageWithURL:[NSURL URLWithString:caseImageUrl]];
                    
                    NSString *image1Url = [[dic[@"caseImageList"] firstObject] objectForKey:@"twoDMaxPath"];
                    [self.image1 sd_setImageWithURL:[NSURL URLWithString:image1Url]];
                    
                    [self.productList addObjectsFromArray:dic[@"caseAssocProduct"]];
                    [self.productTable reloadData];
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

#pragma mark - event

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseDetailProductCell *cell = (CaseDetailProductCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];

    NSDictionary *dic = self.productList[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    cell.name.text = [NSString stringWithFormat:@"%@ %@", dic[@"ocnProductCode"], dic[@"ocnProductName"]];
    cell.code.text = [NSString stringWithFormat:@"产品型号：%@", dic[@"ocnProductCode"]];
    cell.size.text = [NSString stringWithFormat:@"产品规格：%@", dic[@"ocnSpecificationName"]];
    return cell;
}

@end
