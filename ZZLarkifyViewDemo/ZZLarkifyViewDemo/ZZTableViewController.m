//
//  ZZTableViewController.m
//  ZZLarkifyViewDemo
//
//  Created by Jungle on 2018/12/21.
//  Copyright (c) 2018 Jungle. All rights reserved.
//

#import "ZZTableViewController.h"
#import "ZZTableViewCell.h"
#import "ZZCellModel.h"
#import "ZZUtils.h"

@interface ZZTableViewController ()

@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, copy)   NSArray <ZZCellModel *> *cellList;

@end

@implementation ZZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZCellModel *model = self.cellList[indexPath.row];
    return [model cellHeight:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ZZTableViewCell";
    ZZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZCellModel *model = self.cellList[indexPath.row];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, [model cellHeight:indexPath.row]);
    [cell bindData:model frame:frame];
    return cell;
}

#pragma mark - datas

- (NSArray<ZZCellModel *> *)cellList
{
    if (!_cellList) {
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"datas" ofType:@"geojson"]];
        _cellList = [NSArray yy_modelArrayWithClass:[ZZCellModel class] json:jsonData];
    }
    return _cellList;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

@end
