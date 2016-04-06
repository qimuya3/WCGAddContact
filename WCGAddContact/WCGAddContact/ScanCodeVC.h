//
//  ScanCodeVC.h
//  WCGAddContact
//
//  Created by wuchungang on 16/3/30.
//  Copyright © 2016年 chungangwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanCodeVCDelegate <NSObject>

- (void)scanCodeStopWithResultString:(NSString *)string;

@end

@interface ScanCodeVC : UIViewController

@property (nonatomic, assign)id<ScanCodeVCDelegate> delegate;

@end
