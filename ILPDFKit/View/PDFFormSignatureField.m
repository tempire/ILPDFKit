// PDFFormSignatureField.m
//
// Copyright (c) 2015 Iwe Labs
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PDFFormSignatureField.h"
#import "PDF.h"

@implementation PDFFormSignatureField

#pragma mark - UIView

// This class is incomplete. Signature fields are not implemented currently. We mark them red.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PDFWidgetColor;
        
        [self initializeControls];
    }
    return self;
}

-(void)initializeControls {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSignatureView:)];
    [self addGestureRecognizer:tap];
}

-(void)showSignatureView:(UITapGestureRecognizer *)tap {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"showSignatureView" object:self];
}

-(void)setValue:(NSString *)value {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (!value) return;
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:nil];
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageView *imageView = [[UIImageView alloc] init]; //WithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    
    [self addSubview:imageView];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
                           ]];
    
    [self layoutIfNeeded];
}

@end