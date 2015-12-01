//
//  CaseDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/12/1.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "OSNCaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaseDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *crowdName;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@end

@implementation CaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
    [self.backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.cornerRadius = 5;
    
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
                    
                    NSString *caseImageUrl = [[dic[@"caseImageList"] firstObject] objectForKey:@"imagePath"];
                    [self.caseImage sd_setImageWithURL:[NSURL URLWithString:caseImageUrl]];
                    [self.image2 sd_setImageWithURL:[NSURL URLWithString:caseImageUrl]];
                    
                    NSString *image1Url = [[dic[@"caseImageList"] firstObject] objectForKey:@"twoDMaxPath"];
                    [self.image1 sd_setImageWithURL:[NSURL URLWithString:image1Url]];
                });
            }
        });
    }
}

#pragma mark - event

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
