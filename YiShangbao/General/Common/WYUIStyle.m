//
//  WYUIStyle.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/6.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYUIStyle.h"

@implementation WYUIStyle

+(WYUIStyle *)style{
    static dispatch_once_t once;
    static WYUIStyle *mInstance;
    dispatch_once(&once, ^{
        mInstance = [[WYUIStyle alloc] init];
    });
    return mInstance;
}



//绘制水平渐变图
-(UIImage *)imageWithStartColorHexString:(NSString *)startHexString EndColorHexString:(NSString *)endHexString WithSize:(CGSize)size
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:[UIColor colorWithHexString:startHexString] endColor:[UIColor colorWithHexString:endHexString]];
    return backgroundImage;
}
//-(NSArray*)HexStringExchangeToRGB:(NSString*)HexString
//{
//    NSString *colorString = [[HexString stringByReplacingOccurrencesOfString:@"#" withString:@""]  uppercaseString];
//    CGFloat alpha, red, blue, green;
//    switch ([colorString length]) {
//        case 3: // #RGB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 1];
//            green = [self colorComponentFrom: colorString start: 1 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
//            break;
//        case 4: // #ARGB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//            red   = [self colorComponentFrom: colorString start: 1 length: 1];
//            green = [self colorComponentFrom: colorString start: 2 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
//            break;
//        case 6: // #RRGGBB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 2];
//            green = [self colorComponentFrom: colorString start: 2 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
//            break;
//        case 8: // #AARRGGBB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//            red   = [self colorComponentFrom: colorString start: 2 length: 2];
//            green = [self colorComponentFrom: colorString start: 4 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
//            break;
//        default:
//            return nil;
//    }
//    return @[[NSString stringWithFormat:@"%f",red],[NSString stringWithFormat:@"%f",green],[NSString stringWithFormat:@"%f",blue]];
//
//}
//---------------------hex色值处理
-(UIColor *)colorWithHexString:(NSString *)hexString{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""]  uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
//以上-------------------hex色值处理
-(UIColor *)colorF3F3F3
{
    return [self colorWithHexString:@"#f3f3f3"];
}
-(UIColor *)colorMred{      //主色红色
    return [self colorWithHexString:@"#EE4F4F"];
}
//-(UIColor *)colorBtnred{      //按钮红
//    return [self colorWithHexString:@"#EE4F4F"];
//}
-(UIColor *)colorPink{      //粉色
    return [self colorWithHexString:@"#FE6767"];
}
-(UIColor *)colorSorange{   //辅色橙色
    return [self colorWithHexString:@"#ffb700"];
}
-(UIColor *)colorSblue{     //辅色蓝色
    return [self colorWithHexString:@"#00a3ee"];
}
-(UIColor *)colorMTblack{   //文字主要黑色
    return [self colorWithHexString:@"#222222"];
}
-(UIColor *)colorLTgrey{    //文字次要灰色
    return [self colorWithHexString:@"#666666"];
}
-(UIColor *)colorSTgrey{    //文字辅助灰色
    return [self colorWithHexString:@"#999999"];
}
-(UIColor *)colorBTgrey{    //文字背景灰
    return [self colorWithHexString:@"#cccccc"];
}
-(UIColor *)colorBWhite{    //背景白
    return [self colorWithHexString:@"#ffffff"];
}
-(UIColor *)colorBGgrey{    //背景灰
    return [self colorWithHexString:@"#f3f3f3"];
}
-(UIColor *)colorLinegrey{
    return [self colorWithHexString:@"#e0e0e0"];
}
-(UIColor *)colorBGyellow{
    return [self colorWithHexString:@"#FFF9E0"];
}
//分割线颜色－新
- (UIColor *)colorLineBGgrey
{
    return [self colorWithHexString:@"#E5E5E5"];
}

//----------------------规范字体
- (UIFont *)fontNormalWithSize:(CGFloat)size //普通【可在这更换字体】
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];//常规
    //ios9 默认 PingFangSC-Regular
}
//常规字体

-(UIFont *)fontWith36{
//    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
//        return [self fontNormalWithSize:(18*1.15)];
//    }else{
        return [self fontNormalWithSize:18];
//    }
}

-(UIFont *)fontWith32{
//    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
//        return [self fontNormalWithSize:(16*1.15)];
//    }else{
        return [self fontNormalWithSize:16];
//    }
    
}
-(UIFont *)fontWith30{
//    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
//        return [self fontNormalWithSize:(15*1.15)];
//    }else{
        return [self fontNormalWithSize:15];
//    }
    
}
-(UIFont *)fontWith28{
//    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
//        return [self fontNormalWithSize:(14*1.15)];
//    }else{
        return [self fontNormalWithSize:14];
//    }
    
}
-(UIFont *)fontWith24{
//    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
//        return [self fontNormalWithSize:(12*1.15)];
//    }else{
        return [self fontNormalWithSize:12];
//    }
    
}


//注册登录输入框
+ (void)setTextFieldWithPl:(NSString *)pl imageName:(NSString *)imName LblColor:(UIColor *)lblcolor  withField:(UITextField*)field{
    field.placeholder = pl;
//    [field setValue:WYUISTYLE.colorBTgrey forKeyPath:@"_placeholderLabel.textColor"]; 
//    [field setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    [field setValue:[NSNumber numberWithInt:14] forKey:@"paddingLeft"];
    field.font = WYUISTYLE.fontWith30;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    imageView.image=[UIImage imageNamed:imName];
    field.leftView = imageView;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.returnKeyType = UIReturnKeyNext;
    field.textColor = lblcolor;
}

+ (void)setTextFieldWithNoImagePl:(NSString *)pl LblColor:(UIColor *)lblcolor withField:(UITextField*)field{
    field.placeholder = pl;
//    [field setValue:WYUISTYLE.colorBTgrey forKeyPath:@"_placeholderLabel.textColor"];
//    [field setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    field.font = WYUISTYLE.fontWith30;
    field.returnKeyType = UIReturnKeyNext;
    field.textColor = lblcolor;
}

//按钮背景色
+(UIImage *)ButtonBackgroundWithSize:(CGSize)size{
    const CGFloat location[] ={0,1};
    const CGFloat components[] ={
        0.99,0.47,0.33,1,
        1.00,0.32,0.28,1
        
    };
    UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:size locations:location components:components count:2];
    return backgroundImage;
}

//uicolor转uiimage
+ (UIImage*)imageWithColor: (UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 100.0f, 50.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return Image;
}

//--------------UI改版设置(V3.0.0)------------------
+(UIImage *)imageBF352D_BD2B23:(CGSize)size
{
    UIColor *colorStart = [UIColor colorWithHexString:@"BF352D"];
    UIColor *colorEnd = [UIColor colorWithHexString:@"BD2B23"];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:colorStart endColor:colorEnd];
    return backgroundImage;
}
+(UIImage *)imageE23728_CF2218:(CGSize)size
{
    UIColor *colorStart = [UIColor colorWithHexString:@"E23728"];
    UIColor *colorEnd = [UIColor colorWithHexString:@"CF2218"];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:colorStart endColor:colorEnd];
    return backgroundImage;
}
+(UIImage *)imageFDAB53_FD7953:(CGSize)size
{
    UIColor *colorStart = [UIColor colorWithHexString:@"FDAB53"];
    UIColor *colorEnd = [UIColor colorWithHexString:@"FD7953"];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:colorStart endColor:colorEnd];
    return backgroundImage;
}

+(UIImage *)imageFD7953_FE5147:(CGSize)size
{
    UIColor *colorStart = [UIColor colorWithHexString:@"FD7953"];
    UIColor *colorEnd = [UIColor colorWithHexString:@"FE5147"];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:colorStart endColor:colorEnd];
    return backgroundImage;
}
+(UIImage *)imageFF8848_FF5535:(CGSize)size
{
    UIColor *colorStart = [UIColor colorWithHexString:@"FF8848"];
    UIColor *colorEnd = [UIColor colorWithHexString:@"FF5535"];
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:colorStart endColor:colorEnd];
    return backgroundImage;
}

+(UIColor *)colorBD2F26
{
    return [UIColor colorWithHexString:@"#BD2F26"];
}
+(UIColor *)colorFF5434
{
    return [UIColor colorWithHexString:@"#FF5434"];
}








@end
