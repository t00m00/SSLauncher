//
//  LauncherData.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSPalameters.h"
#import "SSPalameters+Extension.h"
#import "CloudManageDelegate.h"

@interface LauncherData : NSObject

@property (nonatomic, strong) NSString              *title;

@property (nonatomic, assign) SSLCloudType          cloudType;
@property (nonatomic, copy) NSString                *cloudSavePath;

@property (nonatomic, assign) BOOL                  isScannerConnectAuto;
@property (nonatomic, strong) NSString              *scannerName;

@property (nonatomic, assign) SSAutoDelete          autoDelete;
@property (nonatomic, assign) SSFileFormat          fileformat;
@property (nonatomic, assign) SSScanningSide        scanSide;
@property (nonatomic, assign) SSColorMode           colorMode;
@property (nonatomic, assign) SSMonoConcentration   concentration;
@property (nonatomic, assign) SSScanMode            scanMode;
@property (nonatomic, assign) SSContinueScan        continueScan;
@property (nonatomic, assign) SSBlankPageSkip       blankPageSkip;
@property (nonatomic, assign) SSReduceBleedThrough  reduceBleed;
@property (nonatomic, assign) SSFileNameFormat      fileNameFormat;
@property (nonatomic, strong) NSString              *fileName;
@property (nonatomic, assign) SSPaperSize           paperSize;
@property (nonatomic, assign) SSMultiFeedControl    multiFeed;
@property (nonatomic, assign) SSCompression         compression;

// SSCAにはない独自の拡張定義
@property (nonatomic, strong) NSString                  *fileNameDisplay;
@property (nonatomic, assign) SSFileNameFormatEx        fileNameFormatEx;
@property (nonatomic, assign) TMFileNamePrefix          fileNamePrefix;
@property (nonatomic, strong) NSString                  *fileNamePrefixText;
@property (nonatomic, assign) TMDelimiterType           fileNamePrefixDelimiter;
@property (nonatomic, assign) TMFileNameSuffix          fileNameSuffix;
@property (nonatomic, strong) NSString                  *fileNameSuffixText;
@property (nonatomic, assign) TMDelimiterType           fileNameSuffixDelimiter;
@property (nonatomic, assign) BOOL                      isFavorite;
@property (nonatomic, assign) BOOL                      isShareLink;
@property (nonatomic, assign) BOOL                      isPreview;
@property (nonatomic, assign) TMSequentialNumberType    sequentialNumberType;
@property (nonatomic, assign) TMDelimiterType           sequentialNumberDelimiter;

@end
