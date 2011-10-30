//
//  DetailViewController.h
//  CloudNotes
//
//  Created by Tom Harrington on 10/30/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
