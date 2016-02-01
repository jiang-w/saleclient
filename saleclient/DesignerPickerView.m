//
//  DesignerPickerView.m
//  saleclient
//
//  Created by Frank on 16/2/1.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "DesignerPickerView.h"
#import <Masonry.h>

@interface DesignerPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) DesignerPickerViewModel *viewModel;

@end

@implementation DesignerPickerView

- (instancetype)initWithViewModel:(DesignerPickerViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        [self initAndLayoutSubview];
    }
    return self;
}

- (void)initAndLayoutSubview {
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.layer.borderColor = RGB(204, 204, 202).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.viewModel.designers.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dic = self.viewModel.designers[row];
    return dic[@"personName"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 7.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row < self.viewModel.designers.count) {
        if (self.didSelectBlock) {
            self.didSelectBlock(self, self.viewModel.designers[row]);
        }
    }
}


#pragma mark - Perporty

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
