//
//  ProductTagTable.h
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTagSection.h"

@class ProductTagTable;
@protocol ProductTagTableDelegate <NSObject>

- (void)productTagTable:(ProductTagTable *)table didChangeSelectedTag:(OSNTag *)tag;

@end

@interface ProductTagTable : UITableViewController <ProductTagSectionDelegate>

@property(nonatomic, weak) id<ProductTagTableDelegate> delegate;

@end
