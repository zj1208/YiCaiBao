//
//  NTESProductMessageView.m
//  YiShangbao
//
//  Created by light on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESProductMessageView.h"
#import "NTESAttachment.h"
#import "NTESSendProductLinkAttachment.h"
#import "UIImage+NIMKit.h"

static  CGFloat titleTextFont = 14.f;
static  CGFloat recommandTextFont = 15.f;

@implementation NTESProductMessageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initSessionMessageContentView
{
    self = [super initSessionMessageContentView];
    if (self) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = [UIFont systemFontOfSize:titleTextFont];
        _titleLab.numberOfLines = 2;
        //        _titleLab.backgroundColor = [UIColor orangeColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:recommandTextFont];
        _priceLabel.numberOfLines = 1;
        
        _titleLab.textColor = [UIColor colorWithHex:0x333333];
        _priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
        
        [self addSubview:_titleLab];
        [self addSubview:_priceLabel];
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _button = [[UIButton alloc]initWithFrame:CGRectZero];
        [_button setTitle:@"发送宝贝" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_button setTintColor:[UIColor colorWithHex:0xF58F23]];
        _button.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
        _button.layer.borderWidth = 0.5f;
        _button.layer.cornerRadius = 13.0f;
        _button.layer.masksToBounds = YES;
        
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
//        _detailLab = [[UILabel alloc] init];
//        _detailLab.text = @"点击查看详情";
//        _detailLab.textColor = [UIColor colorWithHexString:@"42B5FF"];
//        _detailLab.font = [UIFont systemFontOfSize:14];
//        _rowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_>_gr"]];
//        //        _rowImgView.contentMode = UIViewContentModeScaleToFill;
//
//        [self addSubview:_lineView];
//        [self addSubview:_detailLab];
//        [self addSubview:_rowImgView];
        
        
        [self addSubview:_imageView];
        [self addSubview:_button];
    }
    return self;
}


- (void)refresh:(NIMMessageModel*)data
{
    [super refresh:data];
    
    
    
    NIMCustomObject *object = data.message.messageObject;
    id attachment = object.attachment;
    [_priceLabel sizeToFit];
//    [_rowImgView sizeToFit];
    
    if([attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
    {
        NTESSendProductLinkAttachment *attach = (NTESSendProductLinkAttachment *)attachment;
        NTESSendProductLinkModel *model = attach.model;
        self.titleLab.text = model.name;//model.title;
        self.priceLabel.text = model.price;
        
//        self.lineView.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
        
        
//        if(![NSString zhIsBlankString:model.pic])
//        {
//            _imageView.hidden = NO;
            NSURL *url = [NSURL URLWithString:model.pic];
            [self.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
//        }
//        else
//        {
//            _imageView.hidden = YES;
//        }
    }
    
    
    if(self.model.message.isOutgoingMsg)
    {
        [self.bubbleImageView setImage:[self bubbleImage:UIControlStateNormal]];
        [self.bubbleImageView setHighlightedImage:[self bubbleImage:UIControlStateHighlighted]];
        [self setNeedsLayout];
    }
    [self.bubbleImageView setImage:nil];
    [self.bubbleImageView setHighlightedImage:nil];
    [self setNeedsLayout];
    self.backgroundColor = [UIColor whiteColor];
}

- (UIImage *)bubbleImage:(UIControlState)state;{
    return nil;
    //    UIEdgeInsets insets = UIEdgeInsetsMake(30, 25, 10, 25);
    //    return [[UIImage nim_imageInKit:@"pic_duihuakuang2"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.model){
        return;
    }
    CGSize contentSize = [self.model contentSize:CGRectGetWidth(self.frame)];
    
    CGFloat padding = 10;
    CGFloat originX = 15;
    CGFloat topPadding = 12.f;
    CGFloat picWidth = 55.f;
    CGFloat priceLabelHeight = 15.f;
    CGFloat buttonWidth = 100.f;
    CGFloat buttonHeight = 26.f;
    
    NIMCustomObject *object = self.model.message.messageObject;
    id attachment = object.attachment;
    if([attachment isKindOfClass:[NTESSendProductLinkAttachment class]]){
        //        NTESAttachment *attach = (NTESAttachment *)attachment;
        //        NTESCustomProductLinkModel *model = attach.model;
        
        
        self.imageView.frame = CGRectMake(originX, topPadding, picWidth, picWidth);
        CGFloat height = [NSString zhGetBoundingSizeOfString:self.titleLab.text WithSize:CGSizeMake(contentSize.width-2*padding-CGRectGetMaxX(self.imageView.frame), self.titleLab.font.lineHeight*2+3) font:self.titleLab.font].height;
        self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+padding, topPadding, contentSize.width - padding * 2 - CGRectGetMaxX(self.imageView.frame), height);
        
        self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+padding,CGRectGetMaxY(self.imageView.frame) - priceLabelHeight, contentSize.width - padding * 2 - CGRectGetMaxX(self.imageView.frame), priceLabelHeight);
        
        self.button.frame = CGRectMake((contentSize.width - buttonWidth) / 2.0,CGRectGetMaxY(self.priceLabel.frame) + 7, buttonWidth, buttonHeight);
        
    }
    
}

- (void)buttonAction:(id)sender{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapSendProduct;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

- (void)onTouchUpInside:(id)sender{
//    NIMKitEvent *event = [[NIMKitEvent alloc] init];
//    event.eventName = NIMKitEventNameTapProductPicTextLink;
//    event.messageModel = self.model;
//    [self.delegate onCatchEvent:event];
}

@end
