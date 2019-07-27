//
//  WYMakeBillListTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillListTableViewCell.h"

NSString *const WYMakeBillListTableViewCellID = @"WYMakeBillListTableViewCellID";

@interface WYMakeBillListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic) NSInteger index;

@end

@implementation WYMakeBillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deleteButton.layer.cornerRadius = 12.5;
    self.deleteButton.layer.borderColor = [UIColor colorWithHex:0xE8E8E8].CGColor;
    self.deleteButton.layer.borderWidth = 0.5;
    self.deleteButton.layer.masksToBounds = YES;
    
    self.previewButton.layer.cornerRadius = 12.5;
    self.previewButton.layer.borderColor = [UIColor colorWithHex:0xFE744A].CGColor;
    self.previewButton.layer.borderWidth = 0.5;
    self.previewButton.layer.masksToBounds = YES;
    
    self.editButton.layer.cornerRadius = 12.5;
    self.editButton.layer.borderColor = [UIColor colorWithHex:0xFE744A].CGColor;
    self.editButton.layer.borderWidth = 0.5;
    self.editButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(MakeBillHomeInfoModel *)model index:(NSInteger)index{
    self.index = index;
    self.customerNameLabel.text = model.customerName;
    self.countLabel.text = model.totalNum;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.totalMoney];
    self.dateLabel.text = model.billTime;
    
    if (model.payStatus.integerValue == WYBillPayStatusTypeNot){
        self.stateLabel.text = @"未收款";
        self.stateLabel.textColor = [UIColor colorWithHex:0x45A4E8];
    }else if (model.payStatus.integerValue == WYBillPayStatusTypePart) {
        self.stateLabel.text = @"部分收款";
        self.stateLabel.textColor = [UIColor colorWithHex:0xFFB315];
    }else if (model.payStatus.integerValue == WYBillPayStatusTypeAll) {
        self.stateLabel.text = @"全部收款";
        self.stateLabel.textColor = [UIColor colorWithHex:0xFF5434];
    }else{
        self.stateLabel.text = @"";
    }
}

#pragma mark- ButtonAction
- (IBAction)deleteButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]){
        [self.delegate selectedType:MakeBillOperationTypeDelete index:self.index];
    }
}

- (IBAction)previewButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]){
        [self.delegate selectedType:MakeBillOperationTypePreview index:self.index];
    }
}

- (IBAction)editButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]){
        [self.delegate selectedType:MakeBillOperationTypeEdit index:self.index];
    }
}

@end
