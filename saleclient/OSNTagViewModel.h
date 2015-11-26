//
//  OSNTagVIewModel.h
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNTagViewModel : NSObject

// text
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSAttributedString *attributedText;
@property(nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;

// backgound
@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) UIImage *backgroundImage;

// border
@property(nonatomic, assign) CGFloat cornerRadius;
@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, assign) CGFloat borderWidth;

// like padding in css
@property(nonatomic, assign) UIEdgeInsets padding;

// default:YES
@property(nonatomic, assign) BOOL enable;

- (instancetype)initWithText:(NSString *)text;

@end
