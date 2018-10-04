//
//  main.m
//  MountWarden
//  Version 1.0.1
//
//  Created on 22/09/2018.
//  Updated on 25/09/2018
//  Copyright (c) 2017 Mark J Swift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSWorkspace.h>




@interface ApplicationNotification : NSObject;

- (void)volumeDidMount:(NSNotification *)note;
- (void)volumeWillUnmount:(NSNotification *)note;
- (void)volumeDidUnmount:(NSNotification *)note;

@end




@implementation ApplicationNotification

-(NSString *) dateInFormat:(NSString*) stringFormat {
    char buffer[80];
    const char *format = [stringFormat UTF8String];
    time_t rawtime;
    struct tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(buffer, 80, format, timeinfo);
    return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (void)volumeDidMount:(NSNotification *)note
{
    NSLog(@"Did mount: '%@'", [[note userInfo] objectForKey:@"NSDevicePath"]);
    
    NSString *cmd = [NSString stringWithFormat:@"'%@'-DidMount \"DidMount:%@:%@\"",[[NSBundle bundleForClass:[self class]] executablePath], [self dateInFormat:@"%s"], [[note userInfo] objectForKey:@"NSDevicePath"] ];
    [self executeCMD:cmd];
    
}

- (void)volumeWillUnmount:(NSNotification *)note
{
    NSLog(@"Will unmount: '%@'", [[note userInfo] objectForKey:@"NSDevicePath"]);
    
    NSString *cmd = [NSString stringWithFormat:@"'%@'-WillUnmount \"WillUnmount:%@:%@\"",[[NSBundle bundleForClass:[self class]] executablePath], [self dateInFormat:@"%s"], [[note userInfo] objectForKey:@"NSDevicePath"] ];
    [self executeCMD:cmd];
}

- (void)volumeDidUnmount:(NSNotification *)note
{
    NSLog(@"Did unmount: '%@'", [[note userInfo] objectForKey:@"NSDevicePath"]);
    
    NSString *cmd = [NSString stringWithFormat:@"'%@'-DidUnmount \"DidUnmount:%@:%@\"",[[NSBundle bundleForClass:[self class]] executablePath], [self dateInFormat:@"%s"], [[note userInfo] objectForKey:@"NSDevicePath"] ];
    [self executeCMD:cmd];
}

// execute a shell command, but don't wait around for it to finish
- (NSData *) executeCMD:(NSString *)cmd
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    //    NSPipe *pipe = [[NSPipe alloc] init];
    //    [task setStandardOutput: pipe];
    
    //    NSFileHandle *file  = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = NULL;
    //    NSData *data = [file readDataToEndOfFile];
    
    return data;
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSNotificationCenter *  center;
        center = [[NSWorkspace sharedWorkspace] notificationCenter];
        
        NSObject * ano = [ApplicationNotification alloc];
        
        [center addObserver:ano
                   selector:@selector(volumeDidMount:)
                       name:NSWorkspaceDidMountNotification
                     object:nil
         ];
        [center addObserver:ano
                   selector:@selector(volumeWillUnmount:)
                       name:NSWorkspaceWillUnmountNotification
                     object:nil
         ];
        [center addObserver:ano
                   selector:@selector(volumeDidUnmount:)
                       name:NSWorkspaceDidUnmountNotification
                     object:nil
         ];
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
