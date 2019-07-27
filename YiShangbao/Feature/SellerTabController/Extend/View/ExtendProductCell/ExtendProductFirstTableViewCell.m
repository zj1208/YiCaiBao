//
//  ExtendProductFirstTableViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendProductFirstTableViewCell.h"

@interface ExtendProductFirstTableViewCell ()
@property(nonatomic)NSInteger remainCount;
@end

@implementation ExtendProductFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    self.textBackgroundView.layer.masksToBounds = YES;
//    self.textBackgroundView.layer.borderWidth = 0.5f;
//    self.textBackgroundView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"E1E1E1"].CGColor;
    
}
-(void)setNumWordsOfcountLabel:(NSInteger)numWordsOfcountLabel
{
    _numWordsOfcountLabel = numWordsOfcountLabel;
    
    self.countLabel.text = [NSString stringWithFormat:@"(0/%ld)",self.numWordsOfcountLabel];
    
//    self.textView.text = nil;
//    self.textView.placeholder = @"向采购商推销下自己的产品吧";
    WS(weakSelf);
    [self.textView setMaxCharacters:self.numWordsOfcountLabel textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        
        //        NSLog(@"%ld",remainCount);
        weakSelf.countLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",(weakSelf.numWordsOfcountLabel-remainCount),weakSelf.numWordsOfcountLabel];
        weakSelf.remainCount = remainCount;
    }];
    if (self.remainCount) { //刷新tableview字符个数显示
        [self updataCountLabel];
    }
}
-(void)updataCountLabel
{
    self.countLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",(self.numWordsOfcountLabel-_remainCount),self.numWordsOfcountLabel];
}
- (IBAction)selectedClass:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_clcikExtendProductFirstTableViewCellChoseClassbtn:classLabel:)]){
        
        [self.delegate jl_clcikExtendProductFirstTableViewCellChoseClassbtn:self classLabel:self.classLabel];

    }
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
