//
//  WYCommentProductTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYCommentProductTableViewCell.h"


#import "JLStartView.h"

@interface WYCommentProductTableViewCell ()<JLStartViewDelegate>

@end
@implementation WYCommentProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    JLStartView*starcommentView = [[JLStartView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
//    starcommentView.delegate = self;
//    [_startcontentView addSubview:starcommentView];

    _jlstartview.isCanZero = NO;
    _jlstartview.delegate = self;

    
    
    self.textView.placeholderColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //	角色 2-采购商 4-供应商
    
        self.textView.placeholder = @"写一写与买家的交易过程中对买家的印象";
        _jlstartview.isSeller = YES;

    }else{
        self.textView.placeholder = @"产品是否符合您的预期，性价比是否合适，说说你的看法吧";
    }
    
    WS(weakSelf);
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
       
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jl_WYCommentProductTableViewCell:commitInfoChangeStart:textfildText:)]) {
            
            [weakSelf.delegate jl_WYCommentProductTableViewCell:weakSelf commitInfoChangeStart:[NSString stringWithFormat:@"%ld",(NSInteger)weakSelf.jlstartview.curryScore] textfildText:weakSelf.textView.text];
        }
    }];
    
 
    self.IMV.layer.masksToBounds = YES;
    self.IMV.layer.cornerRadius = 3.f;
}

-(void)jl_JLStartView:(JLStartView *)JLStartView didClcikWithScore:(NSInteger)score
{
    if (self.startTitleList.count>4) {
        self.startDescLabel.text = self.startTitleList[score-1];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYCommentProductTableViewCell:commitInfoChangeStart:textfildText:)]) {
        [self.delegate jl_WYCommentProductTableViewCell:self commitInfoChangeStart:[NSString stringWithFormat:@"%ld",score] textfildText:self.textView.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
