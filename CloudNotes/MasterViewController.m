//
//  MasterViewController.m
//  CloudNotes
//
//  Created by Tom Harrington on 10/30/11.
//  Copyright (c) 2011 Atomic Bird, LLC. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
@property (strong, readwrite) NSMetadataQuery *metadataQuery;
@property (strong, readwrite) NSMutableArray *fileList;

- (NSURL*)localDocumentsDirectoryURL;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize metadataQuery = _metadataQuery;
@synthesize fileList = _fileList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Master", @"Master");
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		    self.clearsSelectionOnViewWillAppear = NO;
		    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
		}
		UIBarButtonItem *newDocumentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createDocument)];
		[[self navigationItem] setRightBarButtonItem:newDocumentButton];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	}
	
	[self setFileList:[NSMutableArray array]];

	[self setMetadataQuery:[[NSMetadataQuery alloc] init]];
	[[self metadataQuery] setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
	[[self metadataQuery] setPredicate:[NSPredicate predicateWithFormat:@"%K = '*.txt'", NSMetadataItemFSNameKey]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileListReceived) name:NSMetadataQueryDidFinishGatheringNotification object:[self metadataQuery]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileListReceived) name:NSMetadataQueryDidUpdateNotification object:[self metadataQuery]];
	[[self metadataQuery] startQuery];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self fileList] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

	// Configure the cell.
    NoteDocument *document = [[self fileList] objectAtIndex:indexPath.row];
	cell.textLabel.text = [document localizedName];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
    NoteDocument *document = [[self fileList] objectAtIndex:indexPath.row];
    [[self detailViewController] setDocument:document];
}

#pragma mark - File creation
- (void)createDocument
{
	UIAlertView *simpleCreateDialog = [[UIAlertView alloc] initWithTitle:@"Create Document"
																 message:@"Enter the document title"
																delegate:self
													   cancelButtonTitle:@"Cancel"
													   otherButtonTitles:@"OK", nil];
	[simpleCreateDialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[simpleCreateDialog show];
}

- (void)createFileNamed:(NSString *)filename
{
	NSURL *localFileURL = [[self localDocumentsDirectoryURL] URLByAppendingPathComponent:filename];
	NSLog(@"Local file URL: %@", localFileURL);
	
	NoteDocument *newDocument = [[NoteDocument alloc] initWithFileURL:localFileURL];
    // Should really check to see if a file exists with the name
	[newDocument saveToURL:localFileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
		if (success) {
			[[self fileList] addObject:newDocument];
			[[self tableView] reloadData];
			NSIndexPath *newDocumentPath = [NSIndexPath indexPathForRow:([[self fileList] count]-1) inSection:0];
			[[self tableView] selectRowAtIndexPath:newDocumentPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                [[self detailViewController] setDocument:newDocument];
            }
		}
	}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [alertView firstOtherButtonIndex]) {
		NSString *filename = [[alertView textFieldAtIndex:0] text];
		if (![filename hasSuffix:@".txt"]) {
			filename = [filename stringByAppendingPathExtension:@"txt"];
		}
		NSLog(@"Creating file named %@", filename);
		[self createFileNamed:filename];
	}
}

#pragma mark - NSMetadataQuery lookup
- (void)fileListReceived
{
	// Get currently selected file and save it
	NSString *selectedFileName = nil;
	NSInteger selectedRow = [[[self tableView] indexPathForSelectedRow] row];
	if (selectedRow != NSNotFound) {
		selectedFileName = [[[self fileList] objectAtIndex:selectedRow] localizedName];
	}
	
	// Build the new file list
	[[self fileList] removeAllObjects];
	NSArray *queryResults = [[self metadataQuery] results];
	for (NSMetadataItem *result in queryResults) {
		NSString *filename = [result valueForAttribute:NSMetadataItemFSNameKey];
		if ((selectedFileName != nil) && ([selectedFileName isEqualToString:filename])) {
			selectedRow = [[self fileList] count];
		}
		[[self fileList] addObject:[[NoteDocument alloc] initWithFileURL:[result valueForAttribute:NSMetadataItemURLKey]]];
	}
	
	[[self tableView] reloadData];
	if (selectedRow != NSNotFound) {
		NSIndexPath *selectionPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
		[[self tableView] selectRowAtIndexPath:selectionPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
}

#pragma mark - Misc utility
- (NSURL*)localDocumentsDirectoryURL
{
    static NSURL *localDocumentsDirectoryURL = nil;
    if (localDocumentsDirectoryURL == nil) {
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
																				NSUserDomainMask, YES ) objectAtIndex:0];
        localDocumentsDirectoryURL = [NSURL fileURLWithPath:documentsDirectoryPath];
    }
    return localDocumentsDirectoryURL;
}

@end
