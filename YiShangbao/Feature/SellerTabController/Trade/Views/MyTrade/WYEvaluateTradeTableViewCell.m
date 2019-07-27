//
//  WYEvaluateTradeTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYEvaluateTradeTableViewCell.h"
#import "CCStarSelectedControl.h"

#import "WYCollectionView.h"
#import "WYEvaluateTagsCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

NSString *const WYEvaluateTradeTableViewCellID = @"WYEvaluateTradeTableViewCellID";

@interface WYEvaluateTradeTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) WYCollectionView *tagsCollectionView;
@property (nonatomic, strong) UICollectionViewLeftAlignedLayout *flowLayout;
@property (nonatomic, strong) CCStarSelectedControl *starControl;//星星选择

@property (weak, nonatomic) IBOutlet UILabel *starNameLabel;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopValue;

@property(nonatomic, strong) MyEvaluateModel *model;
@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation WYEvaluateTradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _starControl = [[CCStarSelectedControl alloc]init];
    [self.contentView addSubview:_starControl];
    [_starControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(120.0);
        make.centerY.equalTo(self.starNameLabel);
        make.width.equalTo(@150);
        make.height.equalTo(@39);
    }];
    [_starControl addTarget:self action:@selector(starControlStatusChange:) forControlEvents:UIControlEventValueChanged];
    
    self.constraintTopValue.constant = 15;
    WS(weakSelf)
    self.tagsCollectionView.heightChangeBlock = ^(CGFloat height) {
        if (height < CGRectGetHeight(weakSelf.tagsCollectionView.frame)){
            return ;
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            //collection 大小变化时Block
            if (weakSelf.heightChangeBlock && weakSelf.constraintTopValue.constant != height + 25) {
                weakSelf.heightChangeBlock(height);
            }
            weakSelf.constraintTopValue.constant = height + 25;
//            [weakSelf setNeedsLayout];
//        });
    };
    
    self.textView.placeholderColor = [UIColor colorWithHex:0xC2C2C2];
    self.textView.placeholder = @"请留下您的宝贵建议（内容不展示，可放心填写）";
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
    self.selectedArray = [NSMutableArray array];
    
    self.model = model;
    self.tagsArray = model.labels;
    self.starControl.selectedControlIndex = model.score.integerValue / 2;
    [self starControlStatusChange:self.starControl];
    [self.tagsCollectionView reloadData];
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
    
#pragma mark -CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYEvaluateTagsCollectionViewCell* cell = (WYEvaluateTagsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:WYEvaluateTagsCollectionViewCellID forIndexPath:indexPath];
    EvatipModel *model = self.tagsArray[indexPath.item];
    [cell setData:model.name];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYEvaluateTagsCollectionViewCell* cell = (WYEvaluateTagsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    EvatipModel *model = self.tagsArray[indexPath.item];
    
    if (cell.isSelected){
        [self.selectedArray addObject:model.value];
    }else{
        NSArray * array = [NSArray arrayWithArray:self.selectedArray];
        for (NSString * name in array) {
            if ([name isEqualToString:model.value]) {
                [self.selectedArray removeObject:name];
            }
        }
    }
}

#pragma mark -SetterAndGetter

- (WYCollectionView *)tagsCollectionView{
    if (!_tagsCollectionView) {
        _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.estimatedItemSize = CGSizeMake(50, 29);
        _tagsCollectionView = [[WYCollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:_flowLayout];
        _tagsCollectionView.backgroundColor = [UIColor whiteColor];
        _tagsCollectionView.delegate = self;
        _tagsCollectionView.dataSource = self;
//        _tagsCollectionView.alwaysBounceVertical = YES;//当数据不足，也能滑动
//        _tagsCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//收缩键盘
        
        [_tagsCollectionView registerClass:[WYEvaluateTagsCollectionViewCell class] forCellWithReuseIdentifier:WYEvaluateTagsCollectionViewCellID];
        [self.contentView addSubview:_tagsCollectionView];
        
        [_tagsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(65);
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.bottom.mas_equalTo(self.inputView.mas_top);
        }];
    }
    return _tagsCollectionView;
}

@end
