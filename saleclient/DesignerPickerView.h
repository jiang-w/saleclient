//
//  DesignerPickerView.h
//  saleclient
//
//  Created by Frank on 16/2/1.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerPickerViewModel.h"

@class DesignerPickerView;

typedef void (^DesignerPickerViewDidSelectBlock)(DesignerPickerView *view, NSDictionary *designer);

@interface DesignerPickerView : UIView

@property (nonatomic, copy) DesignerPickerViewDidSelectBlock didSelectBlock;

- (instancetype)initWithViewModel:(DesignerPickerViewModel *)viewModel;

@end
