//
//  WYEvaluateSellerTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYEvaluateBuyerTableViewCell.h"
#import "CCStarSelectedControl.h"

NSString *const WYEvaluateBuyerTableViewCellID = @"WYEvaluateBuyerTableViewCellID";

@interface WYEvaluateBuyerTableViewCell () <UITextViewDelegate>

@property (nonatomic, strong) CCStarSelectedControl *starControl;//星星选择

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *starNameLabel;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;

@property(nonatomic, strong) MyEvaluateModel *model;
@end

@implementation WYEvaluateBuyerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _starControl = [[CCStarSelectedControl alloc]init];
    _starControl.starWidth = 16.0;
    [self.contentView addSubview:_starControl];
    [_starControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(90.0);
        make.centerY.equalTo(self.starNameLabel);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
    }];
    [_starControl addTarget:self action:@selector(starControlStatusChange:) forControlEvents:UIControlEventValueChanged];
    
    self.headImageView.layer.cornerRadius = 15.0;
    self.headImageView.layer.masksToBounds = YES;
    self.textView.placeholderColor = [UIColor colorWithHex:0xC2C2C2];
    self.textView.placeholder = @"采购的求购是否详细，事后的沟通是否有回复？";
    self.inputView.layer.cornerRadius = 2.0;
    self.inputView.layer.borderWidth = 0.5;
    self.inputView.layer.borderColor = [UIColor colorWithHex:0xE1E2E3].CGColor;
    
    self.textView.delegate = self;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(MyEvaluateModel *)model{
    self.model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.buyer.userIcon] placeholderImage:AppPlaceholderImage];
    self.sellerNameLabel.text = model.buyer.nickname;
    self.starControl.selectedControlIndex = model.buyer.defaultScore.integerValue / 2;
    [self starControlStatusChange:self.starControl];
}

#pragma mark- CCStarSelectedControlStatusChange

- (void)starControlStatusChange:(CCStarSelectedControl *)control{
    self.score = @(control.selectedControlIndex * 2);
    if (self.model.sm.count >= 5 && control.selectedControlIndex > 0){
        self.starNameLabel.text = self.model.sm[control.selectedControlIndex - 1];
    }else{
        self.starNameLabel.text = @"";
    }
}

#pragma mark- UITextFieldDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length <= 0) {
        return YES;
    }
    NSMutableString *textFieldString = [NSMutableString stringWithString:textView.text];
    [textFieldString replaceCharactersInRange:range withString:text];
    NSString *str = [NSString stringWithFormat:@"%@",textFieldString];
    
    UITextRange *selectedRange = [textView markedTextRange];
    NSString * newText = [textView textInRange:selectedRange];
    if (str.length < 1 || str.length > 100 + newText.length){
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange == nil) {
        if (textView.text.length > 100){
            textView.text = [textView.text substringToIndex:100];
        }
        self.textCountLabel.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
        self.evaluateString = textView.text;
    }
}

@end
