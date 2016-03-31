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
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "OSNCustomerManager.h"
#import "NavigationBarView.h"
#import "OSNWebViewController.h"

@interface CaseDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBackground;
@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
//@property (weak, nonatomic) IBOutlet UIImageView *personImage;
//@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *crowdName;
@property (weak, nonatomic) IBOutlet UILabel *tag;
@property (weak, nonatomic) IBOutlet UILabel *building;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UITableView *productTable;
@property (weak, nonatomic) IBOutlet UIButton *u3dButton;
@property (nonatomic, strong) NavigationBarView *navBar;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSString *u3dPath;
@property (nonatomic, strong) NSString *exhibitionCode;

@end

@implementation CaseDetailViewController

static NSString * const cellReuseIdentifier = @"productCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviewLayoutAndStyle];
    
    self.productTable.dataSource = self;
    self.productTable.delegate = self;
    [self.productTable registerClass:[CaseDetailProductCell class] forCellReuseIdentifier:cellReuseIdentifier];
    
    self.productList = [NSMutableArray array];
    [self loadCaseDetailData];
    [self updateCustomerReceptionRecord];
}


#pragma mark - private

- (void)setSubviewLayoutAndStyle {
    [self.navBackground addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navBackground);
    }];
    
    self.productTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTable.bounces = NO;
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
//                    [self.personImage sd_setImageWithURL:[NSURL URLWithString:dic[@"caseDetail"][@"personImagePath"]]];
//                    self.personName.text = dic[@"caseDetail"][@"personName"];
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
                    
                    self.u3dPath = dic[@"caseDetail"][@"ipadU3DPath"];
                    if (!IS_EMPTY_STRING(self.u3dPath)) {
                        [self.u3dButton setImage:[UIImage imageNamed:@"u3d.png"] forState:UIControlStateNormal];
                    }
                    else {
                        [self.u3dButton setImage:[UIImage imageNamed:@"u3d_wait.png"] forState:UIControlStateNormal];
                    }
                    
                    self.exhibitionCode = dic[@"caseDetail"][@"exhibitionCode"];
                    
                    [self.productList addObjectsFromArray:dic[@"caseAssocProduct"]];
                    [self.productTable reloadData];
                });
            }
        });
    }
}

- (void)updateCustomerReceptionRecord {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
            paramters[@"customerId"] = receptionId;
            paramters[@"receptionType"] = @"Exhibition";
            paramters[@"goodsId"] = self.exhibitionId;
            OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
            [manager updateCustomerReceptionRecordWithParamters:paramters];
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

- (IBAction)collectButtonClick:(id)sender {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"customerId"] = receptionId;
        paramters[@"collectType"] = @"Exhibition";
        paramters[@"goodsId"] = self.exhibitionId;
        OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
        NSString *result = [manager customerCollectGoodsWithParameters:paramters];
        if ([result isEqualToString:@"alreadyCollect"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已添加此收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        if ([result isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"案例收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前还未接待客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)u3dButtonClick:(id)sender {
    OSNWebViewController *webView = [[OSNWebViewController alloc] init];
    webView.url = @"http://120.27.195.28:6600/lib/krpano/krpano.html?xml=examples/mvtpano/krpano_vr.xml&html5=only&id=id4A62FC4D5A79F03EFBF224F2BAB8D7";
    [self.navigationController pushViewController:webView animated:YES];
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
    cell.productId = dic[@"productId"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseDetailProductCell *cell = (CaseDetailProductCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *productId = cell.productId;
    AppDelegate *appDelegate = OSNMainDelegate;
    if ([appDelegate.mainNav isContainViewControllerForClass:[ProductDetailViewController class]]) {
        NSLog(@"Contain ProductDetailViewController");
        [appDelegate.mainNav popViewControllerForClass:[ProductDetailViewController class]];
    }
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
    productDetail.productId = productId;
    [appDelegate.mainNav pushViewController:productDetail animated:NO];
}


#pragma mark - property

- (NavigationBarView *)navBar {
    if (!_navBar) {
        _navBar = [[NavigationBarView alloc] init];
    }
    return _navBar;
}

@end
