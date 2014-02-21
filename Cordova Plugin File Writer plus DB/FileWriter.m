//
//  FileWriter.m
//  CustomPlugin
//
//  Created by Jesus Garcia on 8/12/13.
//
//

#import "FileWriter.h"
#import <sqlite3.h>

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation FileWriter 

- (void) cordovaGetFileContents:(CDVInvokedUrlCommand *)command {
    
    // Retrieve the date String from the file via a utility method
    NSString *dateStr = [self getFileContents];
    
    // Create an object that will be serialized into a JSON object.
    // This object contains the date String contents and a success property.
    NSDictionary *jsonObj = [ [NSDictionary alloc]
                               initWithObjectsAndKeys :
                                 dateStr, @"dateStr",
                                 @"true", @"success",
                                 nil
                            ];
    
    // Create an instance of CDVPluginResult, with an OK status code.
    // Set the return message as the Dictionary object (jsonObj)...
    // ... to be serialized as JSON in the browser
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                      resultWithStatus    : CDVCommandStatus_OK
                                      messageAsDictionary : jsonObj
                                    ];
    
    // Execute sendPluginResult on this plugin's commandDelegate, passing in the ...
    // ... instance of CDVPluginResult
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) cordovaSetFileContents:(CDVInvokedUrlCommand *)command {
    // Retrieve the JavaScript-created date String from the CDVInvokedUrlCommand instance.
    // When we implement the JavaScript caller to this function, we'll see how we'll
    // pass an array (command.arguments), which will contain a single String.
    NSString *dateStr = [command.arguments objectAtIndex:0];
    NSString *check = [command.arguments objectAtIndex:1];
    
    [self createDB];
    
    

    // We call our setFileContents utility method, passing in the date String
    // retrieved from the command.arguments array.
    [self setFileContents: dateStr];
    
    // Create an object with a simple success property.
    NSDictionary *jsonObj = [ [NSDictionary alloc]
                               initWithObjectsAndKeys : 
                                 @"true", @"success",
                                 nil
                            ];
    
    
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                      resultWithStatus    : CDVCommandStatus_OK
                                      messageAsDictionary : jsonObj
                                    ];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}

#pragma mark - Util_Methods
// Dives into the file system and writes the file contents.
// Notice fileContents as the first argument, which is of type NSString
- (void) setFileContents:(NSString *)fileContents {
    NSLog(@"The content of the files are set");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Native alert" message:@"Called from the hrml js" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"Yes", nil];
    [alert show];
    // Create an array of directory Paths, to allow us to get the documents directory 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // The documents directory is the first item
    NSString *documentsDirectory = [paths objectAtIndex:0];

    // Create a string that prepends the documents directory path to a text file name
    // using NSString's stringWithFormat method.
    NSString *fileName = [NSString stringWithFormat:@"%@/myTextFile.txt", documentsDirectory];
    
    // Here we save contents to disk by executing the writeToFile method of 
    // the fileContents String, which is the first argument to this function.
    [fileContents writeToFile : fileName
                  atomically  : NO
                  encoding    : NSStringEncodingConversionAllowLossy
                  error       : nil];
}

//Dives into the file system and returns contents of the file
- (NSString *) getFileContents{

    // These next three lines should be familiar to you.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"%@/myTextFile.txt", documentsDirectory];
    
    // Allocate a string and initialize it with the contents of the file via
    // the initWithContentsOfFile instance method.
    NSString *fileContents = [[NSString alloc]
                               initWithContentsOfFile : fileName
                               usedEncoding           : nil
                               error                  : nil
                             ];

    // Return the file contents String to the caller (cordovaGetFileContents)
    return fileContents;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            //'CREATE TABLE IF NOT EXISTS DRIVER_TERM_CLASSIFICATION (DRIVER_ID,TERMINAL_ID,TERMINAL_LOCATION,CLASSIFICATION_ID)'
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists studentsDetail (regno integer primary key, name text, department text, year text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

@end
