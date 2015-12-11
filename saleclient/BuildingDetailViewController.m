//
//  BuildingDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingDetailViewController.h"
#import "BuildingDetailCell.h"
#import "OSNBuildingManager.h"
#import "HouseTypeDetailViewController.h"
#import "NavigationBarView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@interface BuildingDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBackground;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *business;
@property (weak, nonatomic) IBOutlet UILabel *enterTime;
@property (weak, nonatomic) IBOutlet UILabel *buildingArea;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UICollectionView *buildingModelView;
@property (nonatomic, strong) NavigationBarView *navBar;

@property (nonatomic, strong) NSMutableArray *buildingModelList;

@end

@implementation BuildingDetailViewController

static NSString * const reuseIdentifier = @"buildingDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviewLayoutAndStyle];
    
     [self.buildingModelView registerClass:[BuildingDetailCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.buildingModelView.dataSource = self;
    self.buildingModelView.delegate = self;
    
    self.buildingModelList = [NSMutableArray array];
    [self loadBuildingDetailData];
}

- (void)setSubviewLayoutAndStyle {
    [self.navBackground addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navBackground);
    }];
}

- (void)loadBuildingDetailData {
    if (self.buildingId) {
        dispatch_queue_t queue = dispatch_queue_create("loadCaseDetail", nil);
        dispatch_async(queue, ^{
            OSNBuildingManager *manager = [[OSNBuildingManager alloc] init];
            NSDictionary *dic = [manager getBuildingDetailWithId:self.buildingId];
            if (dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *imageUrl = dic[@"buildingEntity"][@"imagePath"];
                    [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                    self.name.text = [NSString stringWithFormat:@"【%@】", dic[@"buildingEntity"][@"buildingName"]];
                    self.time.text = dic[@"buildingEntity"][@"openingTime"];
                    self.area.text = dic[@"buildingEntity"][@"constructionArea"];
                    self.address.text = dic[@"buildingEntity"][@"salesAddress"];
                    self.business.text = dic[@"buildingEntity"][@"developersName"];
                    self.enterTime.text = dic[@"buildingEntity"][@"buildingDate"];
                    self.buildingArea.text = dic[@"buildingEntity"][@"buildingArea"];
                    
                    [self.buildingModelList removeAllObjects];
                    [self.buildingModelList addObjectsFromArray:dic[@"buildingModelList"]];
                    [self.buildingModelView reloadData];
                });
            }
        });
    }
}


#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.buildingModelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BuildingDetailCell *cell = (BuildingDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.buildingModelList[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@", dic[@"modelName"], dic[@"modelTypeName"]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    cell.modelId = dic[@"modelId"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BuildingDetailCell *cell = (BuildingDetailCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HouseTypeDetailViewController *houseTypeDetail = [[HouseTypeDetailViewController alloc] init];
    houseTypeDetail.buildingId = self.buildingId;
    houseTypeDetail.modelId = cell.modelId;
    [self.navigationController pushViewController:houseTypeDetail animated:YES];
}


#pragma mark - property

- (NavigationBarView *)navBar {
    if (!_navBar) {
        _navBar = [[NavigationBarView alloc] init];
    }
    return _navBar;
}

@end
