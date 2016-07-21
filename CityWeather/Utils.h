//
//  Utils.h
//  CityWeather
//
//  Created by Luiz Monteiro on 20/07/16.
//  Copyright © 2016 LuizMonteiro. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (SCREEN_MAX_LENGTH == 736.0)

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define APP_ID @"08e586474cfca159de9d878eca9b7f4b"
#define FORECAST_URL @"http://api.openweathermap.org/data/2.5/find?lat=%0.f&lon=%0.f&cnt=15&units=metric&APPID=%@"

#define ICON_URL @"http://openweathermap.org/img/w/"

#define APPLEBLUE [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]