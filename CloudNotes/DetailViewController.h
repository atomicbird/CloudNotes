//
//  DetailViewController.h
//  CloudNotes
//
//  Created by Tom Harrington on 10/30/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDocument.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, NoteDocumentDeletate, UITextViewDelegate>

@property (strong, nonatomic) NoteDocument *document;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
