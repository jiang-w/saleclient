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
#import "NavigationBarView.h"
#import "OSNCaseManager.h"
#import "AutoLayoutTagView.h"

@interface ProductDetailViewController () <AutoLayoutTagViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navBackground;
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
@property (nonatomic, strong) NavigationBarView *navBar;
@property (nonatomic, strong) NSMutableArray *caseList;

@property (nonatomic, strong) NSArray *roomTagDataList;
@property (nonatomic, strong) NSArray *styleTagDataList;
@property (nonatomic, strong) AutoLayoutTagView *roomTagSelectView;
@property (nonatomic, strong) AutoLayoutTagView *styleTagSelectView;
@property (nonatomic, strong) UIView *tagShowBlock;
@property (nonatomic, strong) NSArray *caseAllDataList;
@property (nonatomic, strong) AutoLayoutTagView *typeSelectView;

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
    [self updateCustomerReceptionRecord];
    [self loadCaseTagData];
}


#pragma mark - private

- (void)setSubviewLayoutAndStyle {
    [self.navBackground addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navBackground);
    }];
    
    [self.view addSubview:self.roomTagSelectView];
    [self.roomTagSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.caseListView);
        make.height.mas_offset(40);
    }];
    
    [self.view addSubview:self.styleTagSelectView];
    [self.styleTagSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.caseListView);
        make.height.mas_offset(40);
    }];
    
    [self.view addSubview:self.tagShowBlock];
    [self.tagShowBlock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.caseListView.mas_top).offset(-10);
        make.left.equalTo(self.caseListView).offset(400);
        make.width.mas_offset(300);
        make.height.mas_offset(30);
    }];
    
    [self.view addSubview:self.typeSelectView];
    [self.typeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.caseListView.mas_top).offset(-4);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_offset(360);
        make.height.mas_offset(42);
    }];
    [self.typeSelectView addTagWithTitle:@"空间"];
    [self.typeSelectView addTagWithTitle:@"风格"];
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
                    self.size.text = dic[@"productEntity"][@"ocnSpecificationID"];
                    self.price.text = [NSString stringWithFormat:@"¥ %@", dic[@"productEntity"][@"ocnProductPrice"]];
                    self.special.text = dic[@"productEntity"][@"productCharacteristic"];
                    self.scene.text = dic[@"productEntity"][@"applyScope"];
                    NSMutableString *style = [NSMutableString stringWithString:dic[@"productEntity"][@"productStyleDesc"]];
                    [self string:style replaceString:@"&nbsp;" withString:@" "];
                    self.style.text = style;
                    self.info.text = dic[@"productEntity"][@"productDesc"];
                    self.caseAllDataList = dic[@"productCaseList"];
                    
                    [self refreshCaseListView];
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

- (void)updateCustomerReceptionRecord {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
            paramters[@"customerId"] = receptionId;
            paramters[@"receptionType"] = @"OcnProduct";
            paramters[@"goodsId"] = self.productId;
            OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
            [manager updateCustomerReceptionRecordWithParamters:paramters];
        });
    }
}

- (void)loadCaseTagData {
    __weak __typeof__(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCaseManager *manager = [[OSNCaseManager alloc] init];
        NSArray *TagGroups = [manager getCaseTagList];
        NSMutableArray *tags = [NSMutableArray arrayWithArray:[[TagGroups objectAtIndex:0] list]];
        if (tags.count > 0) {
            [tags removeObjectAtIndex:0];
        }
        weakSelf.roomTagDataList = tags;
        tags = [NSMutableArray arrayWithArray:[[TagGroups objectAtIndex:1] list]];
        if (tags.count > 0) {
            [tags removeObjectAtIndex:0];
        }
        weakSelf.styleTagDataList = tags;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.roomTagDataList && weakSelf.roomTagDataList.count > 0) {
                [weakSelf.roomTagDataList enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
                    [weakSelf.roomTagSelectView addTagWithTitle:tag.name];
                }];
            }
            
            if (weakSelf.styleTagDataList && weakSelf.styleTagDataList.count > 0) {
                [weakSelf.styleTagDataList enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
                    [weakSelf.styleTagSelectView addTagWithTitle:tag.name];
                }];
            }
        });
    });
}

- (void)refreshCaseListView {
    if (self.caseAllDataList) {
        if (self.caseList) {
            [self.caseList removeAllObjects];
        }
        else {
            self.caseList = [NSMutableArray array];
        }
        
        NSInteger selectedRoomTagIndex = self.roomTagSelectView.selectedIndex;
        NSInteger selectedStyleTagIndex = self.styleTagSelectView.selectedIndex;
        
        for (NSDictionary *dic in self.caseAllDataList) {
            if (selectedRoomTagIndex != -1) {
                OSNTag *roomTag = self.roomTagDataList[selectedRoomTagIndex];
                if (![dic[@"roomId"] isEqualToString:roomTag.enumId]) {
                    continue;
                }
            }
            
            if (selectedStyleTagIndex != -1) {
                OSNTag *styleTag = self.styleTagDataList[selectedStyleTagIndex];
                if (![dic[@"styleId"] isEqualToString:styleTag.enumId]) {
                    continue;
                }
            }
            
            [self.caseList addObject:dic];
        }
        [self.caseListView reloadData];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.typeSelectView.selectedIndex = -1;
}


#pragma mark - event

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

- (void)autoLayoutTagView:(AutoLayoutTagView *)view didSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    if (view == self.typeSelectView) {
        switch (self.typeSelectView.selectedIndex) {
            case 0:
                self.roomTagSelectView.hidden = NO;
                break;
            case 1:
                self.styleTagSelectView.hidden = NO;
                break;
            default:
                break;
        }
    }
    else {
        [self showSelectTags];
    }
}

- (void)autoLayoutTagView:(AutoLayoutTagView *)view disSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    if (view == self.typeSelectView) {
        switch (index) {
            case 0:
                self.roomTagSelectView.hidden = YES;
                break;
            case 1:
                self.styleTagSelectView.hidden = YES;
                break;
            default:
                break;
        }
    }
    else {
        if (view.selectedIndex == -1) {
            [self showSelectTags];
        }
    }
}

- (void)showSelectTags {
    for (UIView *view in self.tagShowBlock.subviews) {
        [view removeFromSuperview];
    }
 
    if (self.roomTagSelectView.selectedIndex != -1 || self.styleTagSelectView.selectedIndex != -1) {
        UILabel *title = [[UILabel alloc] init];
        title.text = @"已选择：";
        title.font = [UIFont systemFontOfSize:12];
        [self.tagShowBlock addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagShowBlock);
            make.left.equalTo(self.tagShowBlock).offset(10);
        }];
        
        UIView *prevView = title;
        if (self.roomTagSelectView.selectedIndex != -1) {
            OSNTag *tag = self.roomTagDataList[self.roomTagSelectView.selectedIndex];
            UIButton *tagButton = [self createTagButtonWithName:tag.name];
            tagButton.tag = 100;
            [self.tagShowBlock addSubview:tagButton];
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevView.mas_right).offset(10);
                make.centerY.equalTo(self.tagShowBlock);
            }];
            prevView = tagButton;
        }
        
        if (self.styleTagSelectView.selectedIndex != -1) {
            OSNTag *tag = self.styleTagDataList[self.styleTagSelectView.selectedIndex];
            UIButton *tagButton = [self createTagButtonWithName:tag.name];
            tagButton.tag = 200;
            [self.tagShowBlock addSubview:tagButton];
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevView.mas_right).offset(10);
                make.centerY.equalTo(self.tagShowBlock);
            }];
        }
    }
    
    [self refreshCaseListView];
}

- (UIButton *)createTagButtonWithName:(NSString *)name {
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tagButton setTitle:name forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
    tagButton.contentEdgeInsets = UIEdgeInsetsMake(6, 8, 6, 30);
    tagButton.layer.borderColor = [UIColor orangeColor].CGColor;
    tagButton.layer.borderWidth = 1;
    
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.text = @"╳";
    closeLabel.font = [UIFont systemFontOfSize:10];
    closeLabel.textColor = [UIColor orangeColor];
    [tagButton addSubview:closeLabel];
    [closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tagButton).offset(-10);
        make.centerY.equalTo(tagButton);
    }];
    
    [tagButton addTarget:self action:@selector(clickCloseTagButton:) forControlEvents:UIControlEventTouchUpInside];
    return tagButton;
}

- (void)clickCloseTagButton:(UIButton *)sender {
    if (sender.tag == 100) {
        self.roomTagSelectView.selectedIndex = -1;
    }
    if (sender.tag == 200) {
        self.styleTagSelectView.selectedIndex = -1;
    }
}


#pragma mark - property

- (NavigationBarView *)navBar {
    if (!_navBar) {
        _navBar = [[NavigationBarView alloc] init];
    }
    return _navBar;
}

- (UIView *)tagShowBlock {
    if (!_tagShowBlock) {
        _tagShowBlock = [[UIView alloc] init];
    }
    return  _tagShowBlock;
}

- (AutoLayoutTagView *)roomTagSelectView {
    if (!_roomTagSelectView) {
        _roomTagSelectView = [[AutoLayoutTagView alloc] init];
        _roomTagSelectView.backgroundColor = RGB(225, 230, 235);
        _roomTagSelectView.tagSpace = 10;
        _roomTagSelectView.delegate = self;
        _roomTagSelectView.hidden = YES;
        
        [_roomTagSelectView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = [UIColor clearColor];
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 18, 6, 18);
            button.layer.borderWidth = 0;
        }];
    }
    return _roomTagSelectView;
}

- (AutoLayoutTagView *)styleTagSelectView {
    if (!_styleTagSelectView) {
        _styleTagSelectView = [[AutoLayoutTagView alloc] init];
        _styleTagSelectView.backgroundColor = RGB(225, 230, 235);
        _styleTagSelectView.tagSpace = 10;
        _styleTagSelectView.delegate = self;
        _styleTagSelectView.hidden = YES;
        
        [_styleTagSelectView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = [UIColor clearColor];
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 18, 6, 18);
            button.layer.borderWidth = 0;
        }];
    }
    return _styleTagSelectView;
}

- (AutoLayoutTagView *)typeSelectView {
    if (!_typeSelectView) {
        _typeSelectView = [[AutoLayoutTagView alloc] init];
        _typeSelectView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _typeSelectView.tagSpace = 2;
        _typeSelectView.delegate = self;
        
        [_typeSelectView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            button.frame = CGRectMake(0, 0, 160, 42);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            button.backgroundColor = [UIColor yellowColor];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 0;
        }];
    }
    return _typeSelectView;
}

@end
