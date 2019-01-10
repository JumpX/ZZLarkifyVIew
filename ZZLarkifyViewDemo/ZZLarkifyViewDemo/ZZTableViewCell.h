//
//  ZZTableViewCell.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZCellModel;

@protocol ZZCellProtocol <NSObject>

- (void)bindCell:(ZZCellModel *)model;
- (void)willDisplayCell;

@end

@interface ZZTableViewCell : UITableViewCell<ZZCellProtocol>

@end
