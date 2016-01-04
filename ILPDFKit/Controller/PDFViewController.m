// PDFViewController.m
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

#import "PDF.h"
#import "PDFFormContainer.h"

// Simple macro to get the device orientation before the orientation change
// has actually been made.  So you can't use [UIDevice] yet.
#define UIOrientationIsPortrait(size) size.height > size.width

@interface PDFViewController(Private)
- (void)loadPDFView;
- (CGPoint)margins;
@end

@implementation PDFViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPDFView:[[UIScreen mainScreen] bounds].size];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    for (PDFForm *form in self.document.forms) {
//        [form removeObservers];
//    }
//    [_pdfView removeFromSuperview];
//    self.pdfView = nil;
//}
//


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         // DPNote: do nothing for now.  But I'd like to have the loadPDFView occur here
         // I'm hoping this will fix the "flash" that occurs currently when the orientation happens by reloading before
         // the view is displayed.  But this requires fixing the code underneath this because currently it gets it's location
         // from the device current view (pre rotation).
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - PDFViewController

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self != nil) {
        _document = [[PDFDocument alloc] initWithData:data];
    }
    return self;
}

- (instancetype)initWithResource:(NSString *)name {
    self = [super init];
    if (self != nil) {
        _document = [[PDFDocument alloc] initWithResource:name];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if(self != nil) {
        _document = [[PDFDocument alloc] initWithPath:path];
    }
    return self;
}

- (void)reload {
    [_document refresh];
    [_pdfView removeFromSuperview];
    _pdfView = nil;
    [self loadPDFView];
}

#pragma mark - Private

- (void)loadPDFView:(CGSize)size {
    id pass = (_document.documentPath ? _document.documentPath:_document.documentData);
    CGPoint margins = [self getMargins:size];
    NSArray *additionViews = [_document.forms createWidgetAnnotationViewsForSuperviewWithWidth:self.view.bounds.size.width margin:margins.x hMargin:margins.y];
    _pdfView = [[PDFView alloc] initWithFrame:self.view.bounds dataOrPath:pass additionViews:additionViews];
    _pdfView.alpha = 0;
    [self.view addSubview:_pdfView];
    [UIView animateWithDuration:0.35 animations:^{
        _pdfView.alpha = 1;
    }];
}

- (CGPoint)getMargins:(CGSize)size {
    
  //    static const float PDFLandscapePadWMargin = 13.0f;
//    static const float PDFLandscapePadHMargin = 7.25f;
//    static const float PDFPortraitPadWMargin = 9.0f;
//    static const float PDFPortraitPadHMargin = 6.10f;
//    static const float PDFPortraitPhoneWMargin = 3.5f;
//    static const float PDFPortraitPhoneHMargin = 6.7f;
//    static const float PDFLandscapePhoneWMargin = 6.8f;
//    static const float PDFLandscapePhoneHMargin = 6.5f;

    // DPNote: I played with the idea of doing full device detection here.  I'm hoping that this "lighter" version will work just fine.  The problem I need to solve is figuring out which kind of device it is so the margins can be more exact for each device.

    // DPNote: I know it's bad to hard code these numbers...but it makes it more clear what is actually going on and what the exact numbers
    // are for each device.  So I'm sacrificing rules for clarity.

    CGSize result = [[UIScreen mainScreen] bounds].size;
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
          if (UIOrientationIsPortrait(size))
          {
              if(result.height == 1366) return CGPointMake(9.0f,-2.8f); // IPad Pro
              else                      return CGPointMake(9.0f,6.10f); // All other IPads
          }
          else
          {
              if(result.width == 1366) return CGPointMake(9.0f, -13.6f); // IPad Pro
              else                     return CGPointMake(13.0f,7.25f); // All other IPads
          }
      }
      else
      {
          if (UIOrientationIsPortrait(size))
          {
              if(result.height == 480)         return CGPointMake(3.5f, 6.7f); // 3.5 inch display - iPhone 4S and below
              else if (result.height == 568)   return CGPointMake(3.5f, 6.7f); // 4 inch display - iPhone 5
              else if (result.height == 667)   return CGPointMake(3.5f, 4.0f); // 4.7 inch display - iphone 6
              else if (result.height == 736)   return CGPointMake(3.5f, 3.3f); // 5.5 inch display - iphone 6P
              else                             return CGPointMake(3.5f, 6.7f);
          }
          else    // Landscape orientation
          {
              if(result.width == 480)         return CGPointMake(6.8f, 6.5f); // 3.5 inch display - iPhone 4S and below
              else if(result.width == 568)    return CGPointMake(6.8f, 6.5f); // 4 inch display - iPhone 5
              else if(result.width == 667)    return CGPointMake(6.8f, 3.8f); // 4.7 inch display - iphone 6
              else if(result.width == 736)    return CGPointMake(6.8f, 1.5f); // 5.5 inch display - iPhone 6P
              else                            return CGPointMake(6.8f, 6.5f); // Undetected, return previous default
          }
      }
 

}

@end
