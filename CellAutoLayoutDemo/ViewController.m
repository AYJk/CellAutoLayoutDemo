//
//  ViewController.m
//  CellAutoLayoutDemo
//
//  Created by Andy on 16/3/15.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "ViewController.h"
#import "AYTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSources;
@end
static NSString *cellID = @"chatCell";
@implementation ViewController

- (NSMutableArray *)dataSources {
    
    if (_dataSources == nil) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CellAutoLayoutDemo";
    [self configData];
    [self configSubViews];
}

- (void)configData {
    
    for (NSUInteger index = 0; index < 10; index++) {
        UserModel *model = [[UserModel alloc] init];
        model.title = @"测试标题，测试标题，测试标题，测试标题，测试标题，测试标题，测试标题，";
        model.content = @"描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，描述内容，";
        model.picture = @"2";
        [self.dataSources addObject:model];
    }
}

- (void)configSubViews {
    
    UITableView *chatTableView = ({
        UITableView *tableView = [UITableView new];
        [self.view addSubview:tableView];
        [tableView registerClass:[AYTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserModel *model = self.dataSources[indexPath.row];
    return [AYTableViewCell getHeightWidthModel:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AYTableViewCell *chatCell = ({
        AYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.indexPath = indexPath;
        cell.block = ^(NSIndexPath *cellIndexPath) {
            
            [tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        UserModel *model = self.dataSources[indexPath.row];
        [cell configCellWithModel:model];
        cell;
    });
    return chatCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
