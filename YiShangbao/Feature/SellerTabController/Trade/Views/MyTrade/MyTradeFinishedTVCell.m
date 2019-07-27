//
//  MyTradeFinishedTVCell.m
//  YiShangbao
//
//  Created by simon on 17/1/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MyTradeFinishedTVCell.h"


@implementation MyTradeFinishedTVCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepareForReuse
{
    
    [super prepareForReuse];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleTypeLab.textColor = UIColorFromRGB(69.f, 164.f, 232.f);

    
    self.starView = [[FMLStarView alloc] initWithFrame:CGRectMake(0, 0, 103, 16)  numberOfStars:5 isTouchable:NO index:100];
    self.starContainerView.backgroundColor = [UIColor whiteColor];
    [self.starContainerView addSubview:self.starView];
    self.starView.totalScore = 10.f;
    
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));

    }];
    
    self.contentLab.rectInsets = NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 0, -10, 0));

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:self.evaluateBtn.frame.size];
    [self.evaluateBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    self.evaluateBtn.layer.masksToBounds = YES;
    self.evaluateBtn.layer.cornerRadius = self.evaluateBtn.frame.size.height/2.f;
    
    self.evaluatedBtn.layer.masksToBounds = YES;
    self.evaluatedBtn.layer.cornerRadius = self.evaluatedBtn.frame.size.height/2.f;
    self.evaluatedBtn.layer.borderWidth = 0.5;
    self.evaluatedBtn.layer.borderColor = [UIColor colorWithHex:0xB1B1B1].CGColor;
}

- (void)setData:(id)data
{
    
    MYTradeUnderwayModel *model = (MYTradeUnderwayModel *)data;
    [self.headBtn sd_setImageWithURL:[data URL] forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
    
    self.nickNameLab.text = model.userName;
    self.companyLab.text = model.companyName;
    if (IS_IPHONE_5)
    {
        self.companyLab.hidden = YES;
    }
    self.isLookedLab.text = [data btnTitle];
    self.isLookedLab.hidden = ![[data btnType]boolValue];

    self.timeLabel.text = model.replyTime;
    self.titleLab.text =[NSString stringWithFormat:@"%@",model.title];
    self.titleTypeLab.text = model.tradeTypeTitle;

    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.buyerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
 
    [self layoutIfNeeded];
    
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo (size.height);
        make.width.mas_equalTo(size.width);
        
    }];

    
    self.contentLab.text = [data content];

  
    if (model.evluateBtnModel.buttonType ==0)
    {
        self.evaluateBtn.hidden = NO;
        self.evaluatedBtn.hidden = YES;
        self.starContainerView.hidden = YES;
    }
    else
    {
        self.evaluateBtn.hidden = YES;
        self.evaluatedBtn.hidden = NO;
        self.starContainerView.hidden = YES;
        self.starView.currentScore = 5;
        self.starView.currentScore = [model.evluateBtnModel.buttonTitle integerValue];
    }
}

- (void)updateConstraints
{
    
    [super updateConstraints];
}


@end
