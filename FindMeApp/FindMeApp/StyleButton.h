//
//  StyleButton.h
//  FindMeApp
//
//  Created by Diego Vidal on 08/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleButton : UIButton

@property  (nonatomic, assign) CGFloat hue;
@property  (nonatomic, assign) CGFloat saturation;
@property  (nonatomic, assign) CGFloat brightness;


- (instancetype)initWithHue: (CGFloat)hueR andSaturation: (CGFloat)saturationR andBrightness: (CGFloat)brightnessR;
@end
