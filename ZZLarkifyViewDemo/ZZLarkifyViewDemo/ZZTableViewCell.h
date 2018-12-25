//
//  ZZTableViewCell.h
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZCellModel;
@interface ZZTableViewCell : UITableViewCell

- (void)bindData:(ZZCellModel *)model frame:(CGRect)frame;

@end
