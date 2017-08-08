//
//  secureWipeFile.c
//  Securing_iOS_Data
//
//  Created by linkapp on 08/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

#include "secureWipeFile.h"
#import <string.h>
#import <sys/stat.h>
#import <unistd.h>
#import <errno.h>
#import <fcntl.h>
#import <stdio.h>
#import <stdlib.h>

#define MY_MIN(a, b) (((a) < (b)) ? (a) : (b))
int SecureWipeFile(const char *filePath)
{
    int lastStatus = -1;
    for (int pass = 1; pass < 4; pass++)
    {
        //setup local vars
        int fileHandleInt = open(filePath, O_RDWR);
        struct stat stats;
        unsigned char charBuffer[1024];
        
        //if can open file
        if (fileHandleInt >= 0)
        {
            //get file descriptors
            int result = fstat(fileHandleInt, &stats);
            if (result == 0)
            {
                switch (pass)
                {
                        //DOD 5220.22-M implementation states that we write over with three passes first with 10101010, 01010101 and then the third with random data
                    case 1:
                        //write over with 10101010
                        memset(charBuffer, 0x55, sizeof(charBuffer));
                        break;
                    case 2:
                        //write over with 01010101
                        memset(charBuffer, 0xAA, sizeof(charBuffer));
                        break;
                    case 3:
                        //write over with arc4random
                        for (unsigned long i = 0; i < sizeof(charBuffer); ++i)
                        {
                            charBuffer[i] = arc4random() % 255;
                        }
                        break;
                        
                    default:
                        //at least write over with random data
                        for (unsigned long i = 0; i < sizeof(charBuffer); ++i)
                        {
                            charBuffer[i] = arc4random() % 255;
                        }
                        break;
                }
                
                //get file size in bytes
                off_t fileSizeInBytes = stats.st_size;
                
                //rewrite every byte of the file
                ssize_t numberOfBytesWritten;
                for ( ; fileSizeInBytes; fileSizeInBytes -= numberOfBytesWritten)
                {
                    //write bytes from the buffer into the file
                    numberOfBytesWritten = write(fileHandleInt, charBuffer, MY_MIN((size_t)fileSizeInBytes, sizeof(charBuffer)));
                }
                
                //close the file
                lastStatus = close(fileHandleInt);
            }
        }
    }
    return lastStatus;
}
