//
//  MakeBillGoodNameView.m
//  YiShangbao
//
//  Created by light on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillGoodNameView.h"

@interface MakeBillGoodNameView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *historyList;

@end

@implementation MakeBillGoodNameView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:@"tankuang"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(100, 100, 100, 100);
        image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        [imageView setImage:image];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        _tableView = [[UITableView alloc]init];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MakeBillGoodsNameCell"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(22);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.bottom.equalTo(self).offset(-8);
        }];
    }
    return self;
}

- (void)updateData:(NSArray *)historyList{
    self.historyList = historyList;
    [self.tableView reloadData];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeBillGoodsNameCell" forIndexPath:indexPath];
    cell.textLabel.text = self.historyList[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHex:0x868686];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedGoodsName:)]) {
        [self.delegate selectedGoodsName:self.historyList[indexPath.row]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
