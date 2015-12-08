//
//  HouseTypeDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "HouseTypeDetailViewController.h"
#import "NavigationBarView.h"
#import <Masonry.h>
#import "OSNBuildingManager.h"
#import "HouseTypeCaseCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "CaseDetailViewController.h"

@interface HouseTypeDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBackground;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *openingTime;
@property (weak, nonatomic) IBOutlet UILabel *buildingDate;
@property (weak, nonatomic) IBOutlet UILabel *buildingArea;
@property (weak, nonatomic) IBOutlet UILabel *constructionArea;
@property (weak, nonatomic) IBOutlet UILabel *salesAddress;
@property (weak, nonatomic) IBOutlet UILabel *developersName;
@property (weak, nonatomic) IBOutlet UIView *roomTagBackground;
@property (weak, nonatomic) IBOutlet UICollectionView *caseCollectionView;

@property (nonatomic, strong) NavigationBarView *navBar;
@property (nonatomic, strong) AutoLayoutTagView *roomTagView;
@property (nonatomic, strong) NSMutableArray *roomTabList;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, assign) NSInteger selectedRoomTabIndex;
@property (nonatomic, strong) NSMutableArray *caseList;

@end

@implementation HouseTypeDetailViewController

static NSString * const reuseIdentifier = @"houseTypeCaseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedRoomTabIndex = 0;
    self.roomId = @"all";
    self.roomTabList = [NSMutableArray array];
    self.caseList = [NSMutableArray array];
    
    [self.caseCollectionView registerClass:[HouseTypeCaseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.caseCollectionView.backgroundColor = [UIColor whiteColor];
    self.caseCollectionView.dataSource = self;
    self.caseCollectionView.delegate = self;
    
    [self setSubviewStyleAndLayout];
    [self loadviewData];
}

- (void)setSubviewStyleAndLayout {
    [self.navBackground addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navBackground);
    }];
    
    [self.roomTagBackground addSubview:self.roomTagView];
    [self.roomTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.roomTagBackground);
        make.left.right.equalTo(self.roomTagBackground);
    }];
}


#pragma mark - property

- (NavigationBarView *)navBar {
    if (!_navBar) {
        _navBar = [[NavigationBarView alloc] init];
    }
    return _navBar;
}

- (AutoLayoutTagView *)roomTagView {
    if (!_roomTagView) {
        _roomTagView = [[AutoLayoutTagView alloc] init];
        [_roomTagView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            button.frame = CGRectMake(0, 0, 80, 30);
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 0;
            
            if (index != 0) {
                UIView *split = [[UIView alloc] init];
                split.backgroundColor = [UIColor blackColor];
                [button addSubview:split];
                [split mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(button);
                    make.top.equalTo(button).offset(6);
                    make.bottom.equalTo(button).offset(-6);
                    make.width.mas_equalTo(1);
                }];
            }
        }];
        _roomTagView.delegate = self;
    }
    return _roomTagView;
}

- (void)loadviewData {
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadViewData", nil);
    dispatch_async(queue, ^{
        OSNBuildingManager *manager = [[OSNBuildingManager alloc] init];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"buildingId"] = weakSelf.buildingId;
        paramters[@"modelId"] = weakSelf.modelId;
        paramters[@"roomId"] = weakSelf.roomId;
        NSDictionary *dataDic = [manager getHouseTypeDetailWithParamters:paramters];
        if (dataDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.image sd_setImageWithURL:[NSURL URLWithString:dataDic[@"buildingModelEntity"][@"imagePath"]]];
                weakSelf.name.text = dataDic[@"buildingModelEntity"][@"modelName"];
                weakSelf.openingTime.text = dataDic[@"buildingEntity"][@"openingTime"];
                weakSelf.buildingDate.text = dataDic[@"buildingEntity"][@"buildingDate"];
                weakSelf.buildingArea.text = dataDic[@"buildingEntity"][@"buildingArea"];
                weakSelf.constructionArea.text = dataDic[@"buildingEntity"][@"constructionArea"];
                weakSelf.salesAddress.text = dataDic[@"buildingEntity"][@"salesAddress"];
                weakSelf.developersName.text = dataDic[@"buildingEntity"][@"developersName"];
                
//                [weakSelf.roomTabList removeAllObjects];
//                [weakSelf.roomTagView removeAllTags];
                if (weakSelf.roomTabList.count == 0) {
                    [weakSelf.roomTabList addObjectsFromArray:dataDic[@"roomTabList"]];
                    if (weakSelf.roomTabList.count > 0) {
                        [weakSelf.roomTabList insertObject:@{@"roomId": @"all", @"roomName": @"全部样板"} atIndex:0];
                        for (NSDictionary *dic in weakSelf.roomTabList) {
                            [weakSelf.roomTagView addTagWithTitle:dic[@"roomName"]];
                        }
                        if (weakSelf.selectedRoomTabIndex < weakSelf.roomTabList.count) {
                            weakSelf.roomTagView.selectedIndex = weakSelf.selectedRoomTabIndex;
                        }
                    }
                }
                
                [weakSelf.caseList removeAllObjects];
                [weakSelf.caseList addObjectsFromArray:dataDic[@"caseList"]];
                [weakSelf.caseCollectionView reloadData];
            });
        }
    });
}


#pragma mark - <AutoLayoutTagViewDelegate>

- (void)autoLayoutTagView:(AutoLayoutTagView *)view didSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    self.selectedRoomTabIndex = index;
    self.roomId = self.roomTabList[index][@"roomId"];
    [self loadviewData];
}

- (void)autoLayoutTagView:(AutoLayoutTagView *)view disSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    button.layer.borderColor = [UIColor blackColor].CGColor;
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HouseTypeCaseCell *cell = (HouseTypeCaseCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.caseList[indexPath.row];
    cell.exhibitionId = dic[@"exhibitionId"];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    cell.name.text = dic[@"exhibitionName"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HouseTypeCaseCell *cell = (HouseTypeCaseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AppDelegate *appDelegate = OSNMainDelegate;
    if ([appDelegate.mainNav isContainViewControllerForClass:[CaseDetailViewController class]]) {
        NSLog(@"Contain CaseDetailViewController");
        [appDelegate.mainNav popViewControllerForClass:[CaseDetailViewController class]];
    }
    CaseDetailViewController *caseDetail = [[CaseDetailViewController alloc] init];
    caseDetail.exhibitionId = cell.exhibitionId;
    [appDelegate.mainNav pushViewController:caseDetail animated:NO];
}

@end
