//
//  AppDelegate.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

