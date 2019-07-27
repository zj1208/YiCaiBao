//
//  ZXKeyboardManager.m
//  YiShangbao
//
//  Created by simon on 2018/4/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXKeyboardManager.h"

@interface ZXKeyboardManager ()

@property (nonatomic, copy) NSString * activedTextFieldRect;

@end;

@implementation ZXKeyboardManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
 
    }
    return self;
}

- (void)setSuperView:(UIView *)superView
{
    _superView = superView;
    if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView*tableView = (UIScrollView *)_superView;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
}
- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        self.superView = superView;
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static id singletonInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{

        if (!singletonInstance)
        {
            singletonInstance = [[super allocWithZone:NULL] init];
        }
    });
    return singletonInstance;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 注册通知

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name: UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name: UIKeyboardDidChangeFrameNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  Registering for UITextField notification.
    [self registerTextFieldTextViewClass:[UITextField class]
     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    
    [self registerTextFieldTextViewClass:[UITextView class] didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}



-(void)registerTextFieldTextViewClass:(nonnull Class)aClass
  didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
    didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldViewBeginEditing:) name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldViewEndEditing:) name:didEndEditingNotificationName object:nil];
}


#pragma mark - 移除通知

- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [self unregisterTextFieldTextViewClass:[UITextField class] didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    [self unregisterTextFieldTextViewClass:[UITextView class] didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

-(void)unregisterTextFieldTextViewClass:(nonnull Class)aClass
        didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
          didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didEndEditingNotificationName object:nil];
}


#pragma mark - textField/TextView回调

// textField 自身通知比 键盘通知早;textView 自身通知比 键盘通知迟
- (void)textFieldViewBeginEditing:(NSNotification *)noti
{
    UIView *obj = noti.object;//textField,textView;
    CGRect rect = [obj.superview convertRect:obj.frame toView:self.superView];
    self.activedTextFieldRect = NSStringFromCGRect(rect);
    if ([obj isKindOfClass:[UITextView class]])
    {
        CGRect activeRect = CGRectFromString(self.activedTextFieldRect);
        if ((activeRect.origin.y + activeRect.size.height+HEIGHT_NAVBAR) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-30))
        {
            [UIView animateWithDuration:2.f animations:^{
                if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
                {
                    UIScrollView*tableView = (UIScrollView *)_superView;
                    tableView.contentOffset = CGPointMake(0, HEIGHT_NAVBAR + activeRect.origin.y + activeRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height-30));
                }
            }];
        }
    }
}

- (void)textFieldViewEndEditing:(NSNotification *)noti
{
    
}

#pragma mark - 键盘回调

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect activeRect = CGRectFromString(self.activedTextFieldRect);
    if ((activeRect.origin.y + activeRect.size.height+HEIGHT_NAVBAR) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-30))
    {
        [UIView animateWithDuration:duration animations:^{
            if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
            {
                UIScrollView*tableView = (UIScrollView *)_superView;
                tableView.contentOffset = CGPointMake(0, HEIGHT_NAVBAR + activeRect.origin.y + activeRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height-30));
            }
        }];
    }
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    
}
- (void)keyboardDidChange:(NSNotification *)noti
{
    
}
- (void)keyboardWillChange:(NSNotification *)noti
{
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView*tableView = (UIScrollView *)_superView;
        [tableView scrollRectToVisible:CGRectMake(0, 1, 1, 1) animated:NO];
    }
}

@end
