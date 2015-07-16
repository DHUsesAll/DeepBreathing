//
//  DHInfoPresentationView.h
//  HealthManagement
//
//  Created by DreamHack on 14-10-30.
//  Copyright (c) 2014年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHInfoPresentationView;
@protocol DHInfoPresentationViewDataSource <NSObject>

- (NSInteger)numberOfItemsInInfoPresentationView:(DHInfoPresentationView *)infoPresentationView;
- (NSString *)infoPresentationView:(DHInfoPresentationView *)infoPresentationView titleForItemAtIndex:(NSInteger)index;
- (id)infoPresentationView:(DHInfoPresentationView *)infoPresentationView infoForItemAtIndex:(NSInteger)index;
- (BOOL)infoPresentationView:(DHInfoPresentationView *)infoPresentationView canEditItemAtIndex:(NSInteger)index;
- (UIView *)infoPresentationView:(DHInfoPresentationView *)infoPresentationView inputViewForItemAtIndex:(NSInteger)index;
- (UIFont *)infoPresentationView:(DHInfoPresentationView *)infoPresentationView fontForItemAtIndex:(NSInteger)index;

@end

@protocol DHInfoPresentationViewDelegate <NSObject>

@optional

- (void)infoPresentationView:(DHInfoPresentationView *)infoPresentationView didBeginEditingItemWithInfo:(id)info atIndex:(NSInteger)index;

@end


@interface DHInfoPresentationView : UIView

@property (nonatomic, assign) BOOL editting;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) id <DHInfoPresentationViewDataSource> dataSource;
@property (nonatomic, assign) id <DHInfoPresentationViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame itemHeight:(CGFloat)itemHeight dataSource:(id <DHInfoPresentationViewDataSource>)dataSource delegate:(id <DHInfoPresentationViewDelegate>)delegate;
//- (void)addItemWithTitle:(NSString *)title info:(id)info canEdit:(BOOL)flag;

- (void)reloadData;

- (void)setInfo:(id)info forItemAtIndex:(NSInteger)index;

- (void)setEditting:(BOOL)editting;

- (void)hideKeyBorad;
- (NSArray *)presentationInfos;

@end
