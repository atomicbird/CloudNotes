//
//  NoteDocument.h
//  CloudNotes
//
//  Created by Tom Harrington on 10/30/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteDocument;

@protocol NoteDocumentDeletate <NSObject>
- (void)noteDocumentContentsUpdated:(NoteDocument *)document;
@end

@interface NoteDocument : UIDocument

@property (strong, readwrite) NSString *documentText;
@property (weak, readwrite) id delegate;
@property (strong, readwrite) NSString *filename;
@end
