//
//  PurACommendTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/5/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurACommendTableViewCell.h"
#import "PurAStoreCollectionViewCell.h"

NSString *const PurACommendTableViewCellID = @"PurACommendTableViewCellID";

@interface PurACommendTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reBatchButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sellerArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commendHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation PurACommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(id)model isType:(NSInteger)type{
    self.sellerArray = model;
    if (self.sellerArray.count > 0){
        self.commendHeight.constant = 225.5;
        self.backView.hidden = NO;
    }else{
        self.commendHeight.constant = 0;
        self.backView.hidden = YES;
    }
    [self setNameByType:type];
    [self.collectionView reloadData];
}

- (void)updatePoint{
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
}

- (void)attentionButtonAction:(UIButton *)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:position];
    if (self.delegate && [self.delegate  respondsToSelector:@selector(attentionStoreIndex:)]){
        [self.delegate attentionStoreIndex:indexPath.item];
    }
}

- (IBAction)reNewBatchAction:(id)sender {
    if (self.delegate && [self.delegate  respondsToSelector:@selector(reNewBatch)]){
        [self.delegate reNewBatch];
    }
}


#pragma mark ------UICollectionViewDataSource------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sellerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PurAStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PurAStoreCollectionViewCellID forIndexPath:indexPath];
    [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell updateData:self.sellerArray[indexPath.item]];
    return cell;
    
}

//
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return NO;
    }
    return YES;
}

#pragma mark ------UICollectionViewDelegate------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(goStoreIndex:)]){
        [self.delegate goStoreIndex:indexPath.item];
    }
}

#pragma mark ------Private------

- (void)setUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(130, 185);
//    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PurAStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PurAStoreCollectionViewCellID];
}

- (void)setNameByType:(NSInteger)type{
    switch (type) {
        case 0:
            self.nameLabel.text = NSLocalizedString(@"为您精选的口碑供应商", @"");
            break;
        case 1:
            self.nameLabel.text = NSLocalizedString(@"为您推荐上新勤快的供应商", @"");
            break;
        case 2:
            self.nameLabel.text = NSLocalizedString(@"为您推荐热销供应商", @"");
            break;
        case 3:
            self.nameLabel.text = NSLocalizedString(@"为您推荐库存较多的供应商", @"");
            break;
        default:
            break;
    }
}

@end
