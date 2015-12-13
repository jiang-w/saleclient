//
//  ProductImageList.h
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagPadView.h"
#import "ProductTagTable.h"

@interface ProductImageList : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ProductTagTableDelegate, OSNTagPadViewDelegate>

- (void)searchWithKeyword:(NSString *)keyword;

@end
