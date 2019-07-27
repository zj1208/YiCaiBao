//
//  TradeDetailMyCommitCell.m
//  YiShangbao
//
//  Created by simon on 17/1/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeDetailMyCommitCell.h"

#define PhotoMargin 15  //间距
#define ContentWidth LCDW-20
@interface TradeDetailMyCommitCell ()

@end

@implementation TradeDetailMyCommitCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.contentLab.isNeedCopy = YES;//长按复制功能
    
    self.photoContainerView.backgroundColor = [UIColor whiteColor];
    //创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = NO;
    photoView.photoMaxCount = 9;
    photoView.photosMaxColoum = 4;
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (ContentWidth-PhotoMargin*3)/photoView.photosMaxColoum;
    photoView.photoHeight = photoView.photoWidth;
    self.photosView = photoView;
    //设置边框
    photoView.photoModelItemViewBlock = ^(UIView *itemView)
    {
        [itemView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    [self.photoContainerView addSubview:self.photosView];
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.photoContainerView).with.insets(UIEdgeInsetsMake(5, 0, 5,0));
    }];
}


- (void)setData:(id)data
{
    TradeMyCommintModel *model = (TradeMyCommintModel *)data;

    self.replyTimeLab.text = model.replyTime;
    self.sellGoodsTypeLab.text = model.sellGoodsType;
    self.goodsPriceLab.text = model.goodsPrice;
    self.orderCountBegainLab.text = model.orderBeginCount;
    self.contentLab.text =model.replyContent;
   
    NSMutableArray *picMArray = [NSMutableArray array];
    [model.photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicModel *picModel = (AliOSSPicModel *)obj;
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picURL];
        NSURL *thumbnail_pic = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:picModel.picURL];
        photo.thumbnail_pic = thumbnail_pic.absoluteString;
        photo.width = picModel.width;
        photo.height = picModel.height;
        [picMArray addObject:photo];
        
    }];
    self.photosView.photoModelArray = picMArray;
    
    //动态显示起订量containerView（包括分割线，间隔），回复内容containerView
    self.orderBegainContainerView.hidden = self.orderCountBegainLab.text.length ==0?YES:NO;
    self.contentContainerView.hidden = self.contentLab.text.length==0?YES:NO;
    self.contentContainerView.layer.borderWidth = 0.5;
    self.contentContainerView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"E2E2E2"].CGColor;


}


- (void)layoutSubviews
{
    [super layoutSubviews];
 

    
    if (self.photosView.photoModelArray.count>0)
    {
        CGSize size  = [self.photosView sizeWithPhotoCount:self.photosView.photoModelArray.count photosState:ZXPhotosViewStateDidCompose];
        [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(LCDW, size.height+10));
        }];

    }
    else
    {
        [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(LCDW, 0));
        }];

    }
    
    if (self.contentLab.text.length==0)
    {
        [self.contentContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(@0);
            
        }];
    }
    
    if (self.orderCountBegainLab.text.length ==0)
    {
        [self.orderBegainContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }

    //无描述，无图片
    if (self.contentLab.text.length==0 && self.photosView.photoModelArray.count == 0) {
       
        [self.autophotoview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);

        }];
    }
    //无描述，有图片
    if (self.contentLab.text.length==0 && self.photosView.photoModelArray.count > 0) {
        
        [self.autolabeltopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
            
        }];

    }
    
}


- (CGFloat)getCellHeightWithContentData:(id)data
{
    if (!data)
    {
        return 0.f;
    }
    [self.contentLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.contentLab layoutIfNeeded];
    self.contentLab.text = [data replyContent];
    [self.contentView layoutIfNeeded];
    //这个高度，是content容器计算过contentLab里的真实文本后的高度＋top＋bottom ＝ 总高度；即使运行过layoutSubview，调整过其它控件的高度；
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGFloat height = size.height+1.0f-90;

    NSArray *picMArray =[data photosArray];
    if (picMArray.count>0)
    {
        CGSize photosViewSize  = [self.photosView sizeWithPhotoCount:picMArray.count photosState:ZXPhotosViewStateDidCompose];
        height = height +photosViewSize.height + 10;
    }
    //利用containerView包括间隔，控件，线条，有利用整体控制高度及是否显示；
    //如果约束不是基于contentView布局的，系统方法则不会自动计算到；只会计算你添加的containerView的 label／button等控件高度为0之后，余下的整个高度；
    //所以自定义添加containerView中ledge边距高度还是需要你自己减去，不然永远会存在；
    if (self.contentLab.text.length==0)
    {
        height = height-10*2;
    }
    if ([data orderBeginCount].length==0)
    {
        height = height -45;
    }
    //
    if (self.contentLab.text.length==0 && picMArray.count == 0) {
        height = height -20;
    }
    if (self.contentLab.text.length==0 && picMArray.count > 0) {
        height = height -12;
    }

    return height;
}


@end
