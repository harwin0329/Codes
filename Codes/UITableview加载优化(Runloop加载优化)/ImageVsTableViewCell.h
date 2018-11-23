//
//  ImageVsTableViewCell.h
//  Codes
//
//  Created by chenzw on 2018/11/22.
//  Copyright © 2018 Gripay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageVsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;

@end

NS_ASSUME_NONNULL_END
