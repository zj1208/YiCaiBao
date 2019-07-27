//
//  JLTextView.m
//  JLTextView
//
//  Created by 杨建亮 on 2018/4/26.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "JLTextView.h"

@interface JLTextView ()<UITextInput>
//使用等大JLTextView解决占位符问题.方便设置富文本、typingAttributes等时的字体重叠显示
@property (nonatomic, weak) UITextView *placeholderView;
@property (nonatomic, assign) BOOL scrollEnabledLock;//当使用sizeToFitHight=YES时scrollEnabled外部设置无效

@property (nonatomic, assign) CGFloat lastTextHeight;
@property (nonatomic, assign) CGFloat curryLineSpacing;

@property (nonatomic, copy) JLTextChangedHandler textHandler; // 文本改变Block
@property (nonatomic, copy) JLTextHeightChangedHandler textHeightHandler; // 自适应高度调整后Block
@end
static CGFloat const defaultTextHeight = -1.f;
@implementation JLTextView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultData];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
    }
    return self;
}
- (void)initDefaultData
{
    _rowHeight = self.font.lineHeight;
    _curryLineSpacing = 0.f;
    _curryLines = 0;
    _minNumberOfLines = 1;
    _maxNumberOfLines = NSUIntegerMax;
    _maxLength = NSUIntegerMax;
    _sizeToFitHight = NO;
    _lastTextHeight = defaultTextHeight;
    _placeholderColor = [UIColor colorWithRed:194.f/255.0f green:194.f/255.0f blue:194.f/255.0f alpha:1.0];
    _scrollEnabledLock = NO;
    _textInsetAdjustBehavior = JLTextInsetAdjustmentNormal;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}
#pragma mark - placeholderView
- (UITextView *)placeholderView
{
    if (!_placeholderView ) {
        UITextView *placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.textColor = _placeholderColor;
        _placeholderView.backgroundColor = [UIColor clearColor];
        _placeholderView.font = self.font;
        _placeholderView.attributedText = self.attributedText;
        _placeholderView.textContainerInset = self.textContainerInset;
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderView.textColor = placeholderColor;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder) {
        self.placeholderView.text = placeholder;
    }else{
        [_placeholderView removeFromSuperview];
    }
}
-(void)setSizeToFitHight:(BOOL)sizeToFitHight
{
    _sizeToFitHight = sizeToFitHight;
    if (_sizeToFitHight) {
        self.scrollEnabledLock = NO;
        self.scrollEnabled = NO;
        self.scrollEnabledLock = YES;
    }else{
        self.scrollEnabledLock = NO;
        self.scrollEnabled = YES;
    }
    if (!self.text||[self.text isEqualToString:@""]) {
        [self sizeToFitMinLinesHightWhenNoText];
    }else{
        [self sizeToFitHightWhenNeed];
    }
}
-(CGFloat)minTextHeight
{
    if (self.minNumberOfLines == 0) {
        return 0.0;
    }
    CGFloat heightMIN = self.rowHeight * self.minNumberOfLines+self.curryLineSpacing* (self.minNumberOfLines-1) + self.textContainerInset.top + self.textContainerInset.bottom +self.contentInset.top+self.contentInset.bottom;
    return ceilf(heightMIN);
}
-(CGFloat)maxTextHeight
{
    CGFloat heightMAX = self.rowHeight* self.maxNumberOfLines+self.curryLineSpacing* (self.maxNumberOfLines-1) + self.textContainerInset.top + self.textContainerInset.bottom+self.contentInset.top+self.contentInset.bottom;
    return ceilf(heightMAX);
}
-(void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = maxLength;
    if (self.text.length > _maxLength) {
        self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
    }
}
#pragma mark - 自适应高度
-(void)sizeToFitMinLinesHightWhenNoText
{
    if (self.sizeToFitHight && self.text.length==0) {
        BOOL heightChange = self.frame.size.height!=self.minTextHeight;
        CGRect frame = self.frame;
        frame.size.height = self.minTextHeight;
        self.frame = frame;
        if (heightChange) {
            _lastTextHeight = self.minTextHeight;
            !_textHeightHandler ?: _textHeightHandler(self,self.minTextHeight);
        }
    }
}
-(void)sizeToFitHightWhenNeed
{
    if (self.sizeToFitHight) {
        
//        CGFloat heightText = [self jl_getTextHeightInTextView:self.text];
        CGFloat heightText  = [self calculateTextHeight];
        CGFloat height = [self jl_getTextViewHeightWithTextHeight:heightText];
        if (self.lastTextHeight != height)
        {
            //优化系统输入时跳动
            self.scrollEnabledLock = NO;
            self.scrollEnabled = NO;
            self.scrollEnabledLock = YES;

            if (height<=self.minTextHeight)
            {
                if (self.textInsetAdjustBehavior == JLTextInsetAdjustmentAutomatic) {
                    super.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsZero;
                    height = [self jl_getTextViewHeightWithTextHeight:heightText];
                }
                CGRect frame = self.frame;
                frame.size.height = self.minTextHeight;
                self.frame = frame;
                !_textHeightHandler ?: _textHeightHandler(self,self.minTextHeight);
            }
            else if (height>=self.maxTextHeight)
            {
                if (self.textInsetAdjustBehavior == JLTextInsetAdjustmentAutomatic) {
                    super.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsMake(0, 0, 6, 0);
                    height = [self jl_getTextViewHeightWithTextHeight:heightText];
                }
                //当高度大于自身高度时允许滚动
                self.scrollEnabledLock = NO;
                self.scrollEnabled = YES;
                self.scrollEnabledLock = YES;

                CGFloat H = self.maxTextHeight;
                CGRect frame = self.frame;
                frame.size.height = H;
                self.frame = frame;
              
                !_textHeightHandler ?: _textHeightHandler(self,H);
           
            }else{
                if (self.textInsetAdjustBehavior == JLTextInsetAdjustmentAutomatic) {
                    super.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsMake(0, 0, 5,0);
                    height = [self jl_getTextViewHeightWithTextHeight:heightText];
                }
                CGFloat H = height;
                CGRect frame = self.frame;
                frame.size.height = H;
                self.frame = frame;
                !_textHeightHandler ?: _textHeightHandler(self,H);

            }
            // 字符串高度改变时调整frame高度
            self.lastTextHeight = height;
        }
    }
}
//为了解决bug:设置行间距系统计算第一行会加上行间距，这不是我想要的结果
- (CGFloat )calculateTextHeight
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.typingAttributes];
    NSMutableParagraphStyle *attName =  [dictM objectForKey:NSParagraphStyleAttributeName];
    if (attName) {
        attName.lineSpacing = 0.f;
        [dictM setObject:attName forKey:NSParagraphStyleAttributeName];
    }
    
    CGFloat  width = [self jl_getTextViewContentTextWidth];
    CGFloat textHeight =  [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dictM context:nil].size.height;
    
    CGFloat Lines = textHeight/self.rowHeight;
    _curryLines = Lines;
    NSLog(@"jl_curryLines%f",Lines);
    
    textHeight = textHeight+self.curryLineSpacing*(Lines-1);
    NSLog(@"jl_textHeight%f",textHeight);
    return textHeight;
}
//限制字符输入
-(void)limitCharacterLengthWhenNeed
{
    [self jl_limitTextViewMaxLengthWhenDidChange:self.maxLength];
    // 回调文本改变的Block.
    !_textHandler ?: _textHandler(self,self.text.length);
}
-(void)setMinNumberOfLines:(NSUInteger)minNumberOfLines
{
    NSUInteger lastMinNumberOfLines = self.minNumberOfLines;
    _minNumberOfLines = minNumberOfLines<_maxNumberOfLines?minNumberOfLines:_maxNumberOfLines;
    if (self.minNumberOfLines!=lastMinNumberOfLines) {
        _lastTextHeight = defaultTextHeight;
        [self sizeToFitHightWhenNeed];
    }
}
- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    NSUInteger lastMaxNumberOfLines = self.maxNumberOfLines;
    _maxNumberOfLines = maxNumberOfLines>_minNumberOfLines?maxNumberOfLines:_minNumberOfLines;
    if (self.maxNumberOfLines!=lastMaxNumberOfLines) {
        _lastTextHeight = defaultTextHeight;
        [self sizeToFitHightWhenNeed];
    }
}
#pragma mark - NSNotification
- (void)textDidChange:(NSNotification *)notification
{    
    //隐藏placeholderView
    _placeholderView.hidden = self.text.length > 0?YES:NO;
    
    //限制字符输入
    [self limitCharacterLengthWhenNeed];
    
    //自适应高度
    [self sizeToFitHightWhenNeed];
}
-(void)addTextDidChangeHandler:(JLTextChangedHandler)textHandler
{
    _textHandler = [textHandler copy];
}
-(void)addTextHeightDidChangeHandler:(JLTextHeightChangedHandler)textHeightHandler
{
    _textHeightHandler = [textHeightHandler copy];
}
#pragma mark - 重写父类方法
-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (!self.scrollEnabledLock) {
        [super setScrollEnabled:scrollEnabled];
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_placeholderView setFont:font];
    NSMutableParagraphStyle *attName =  [self.typingAttributes objectForKey:NSParagraphStyleAttributeName];
    if (attName) {
        _rowHeight = font.lineHeight>_rowHeight?font.lineHeight:_rowHeight;
    }else{
        _rowHeight = font.lineHeight;
    }
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange:nil];
}
-(void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    [_placeholderView setTextContainerInset:textContainerInset];
    _lastTextHeight = defaultTextHeight;
    [self sizeToFitHightWhenNeed];
}
-(void)setTypingAttributes:(NSDictionary<NSString *,id> *)typingAttributes
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:typingAttributes];
    if (![typingAttributes objectForKey:NSFontAttributeName]&&self.font) {
        [dictM setObject:self.font forKey:NSFontAttributeName];
    }
    if (![typingAttributes objectForKey:NSForegroundColorAttributeName]&&self.textColor) {
        [dictM setObject:self.textColor forKey:NSForegroundColorAttributeName];
    }
    [super setTypingAttributes:dictM];
    _placeholderView.typingAttributes = dictM;
    _placeholderView.text = self.placeholder;
    _placeholderView.textColor = self.placeholderColor;

    NSMutableParagraphStyle *attName =  [typingAttributes objectForKey:NSParagraphStyleAttributeName];
    if (attName) {
        if (attName.minimumLineHeight<self.font.lineHeight) {
            _rowHeight = self.font.lineHeight;
        }else{
            _rowHeight = attName.minimumLineHeight;
        }
        _curryLineSpacing = attName.lineSpacing;
    }
    _lastTextHeight = defaultTextHeight;
    [self sizeToFitHightWhenNeed];
}
-(void)layoutSubviews
{
//    NSLog(@"JLTextView layoutSubviews");
    [super layoutSubviews];
    [self sizeToFitMinLinesHightWhenNoText];
    if (_placeholderView) {
        if (!CGRectEqualToRect(self.bounds, _placeholderView.frame)) {
            _placeholderView.frame = self.bounds;
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITextInput 修正光标在富文本中位置
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    NSMutableParagraphStyle *attName =  [self.typingAttributes objectForKey:NSParagraphStyleAttributeName];
    if (attName) {
        originalRect.origin.y = originalRect.origin.y+(_rowHeight-self.font.lineHeight);
    }
    NSNumber *baselineOffset = [self.typingAttributes objectForKey: NSBaselineOffsetAttributeName];
    if (baselineOffset) {
        originalRect.origin.y-= baselineOffset.floatValue;
    }
    originalRect.size.height = self.font.lineHeight;
    return originalRect;
}
//基于UITextView的typingAttributes富文本设置行高、字体
- (void)setTypingAttributesWithLineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing textFont:(nullable UIFont *)font textColor:(nullable UIColor *)color;
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;// 字体的行间距
    paragraphStyle.minimumLineHeight = lineHeight ;// 字体的行高
    UIFont *attFont = font?font:self.font;
    UIColor *attColor = color?color:self.textColor;
    CGFloat attLineHeight = lineHeight>attFont.lineHeight?lineHeight:attFont.lineHeight;
    NSNumber *attOffset = @((attLineHeight-attFont.lineHeight)/2.f);//居中
    NSDictionary *attr = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSBaselineOffsetAttributeName:attOffset
                                 };
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:attr];
    if (attFont) {
        [attributes setObject:attFont forKey:NSFontAttributeName];
    }
    if (attColor) {
        [attributes setObject:attColor forKey:NSForegroundColorAttributeName];
    }
    self.typingAttributes = attributes;
}
@end

@implementation UITextView (JLSizeCalculate)
- (void)jl_limitTextViewMaxLengthWhenDidChange:(NSUInteger)maxLength
{
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (self.text.length > maxLength) {
                self.text = [self.text substringToIndex:maxLength]; // 截取最大限制字符数.
                [self.undoManager removeAllActions]; // 达到最大字符数后清空所有undoaction, 以免undo操作(复制过来一个长度很长的字符串，粘贴过后，摇晃手机，点击撤销)造成crash. 注:在粘贴超出长度撤销操作触发字符串越界所致，若自定义实现超出字符串截断再粘贴，会自动丢失摇晃手机撤销功能。还是超出长度粘贴取消撤销功能这样较为简便
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (self.text.length > maxLength)
        {
            self.text = [ self.text substringToIndex:maxLength];
            [self.undoManager removeAllActions];
        }
    }
    
}
- (CGFloat)jl_getTextViewContentTextWidth
{
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    //内容需要除去显示的边框值
    CGFloat broadWith    = (  self.contentInset.left
                            + self.contentInset.right
                            + self.textContainerInset.left
                            + self.textContainerInset.right
                            + self.textContainer.lineFragmentPadding/*左边距*/
                            + self.textContainer.lineFragmentPadding/*右边距*/
                            );
    contentWidth -= broadWith;
    return contentWidth;
}
- (CGFloat)jl_getTextHeightInTextView:(NSString *)text
{
    CGFloat  width = [self jl_getTextViewContentTextWidth];
    CGSize InSize = CGSizeMake(width, MAXFLOAT);
    CGFloat textHeight =  [text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:self.typingAttributes context:nil].size.height;
    NSLog(@"textHeight=%f",textHeight);
    return textHeight;
}
- (CGFloat)jl_getTextViewHeightWithTextHeight:(CGFloat)textHeight
{
    CGFloat broadHeight  = (  self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);//+self.textContainer.lineFragmentPadding/*top*//*+self*//*there is no bottom padding*/);
    CGFloat height = textHeight+broadHeight;
    NSLog(@"height=%f",height);
    return height;
}
- (CGFloat)jl_getTextViewHeightInTextView:(NSString *)text
{
    CGFloat  textHeight = [self jl_getTextHeightInTextView:text];
    CGFloat broadHeight  = (  self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);//+self.textContainer.lineFragmentPadding/*top*//*+self*//*there is no bottom padding*/);
    CGFloat height = ceilf(textHeight+broadHeight);
    NSLog(@"height=%f",height);
    return height;
}
@end
