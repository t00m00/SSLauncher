//
//  LauncherData.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "LauncherData.h"
#import "LauncherData+Managing.h"

#pragma mark -
#pragma mark ===== LauncherData クラス =====
@interface LauncherData ()
{
    NSString   *_launcherDataFileName;                  /**< 自分自身のファイル名 */
    NSUInteger _sortValue;                              /**< ソート用番号を保持 */
    NSUInteger _favoriteSortValue;                      /**< お気に入り画面のソート用番号を保持 */
}

@end

/** Launcherのデータをメモリ中に保持する */
@implementation LauncherData

/** 各種ゲッター/セッター */
- (void)setCloudSavePath:(NSString *)cloudSavePath
{
    
    NSString *tmpSavePath = cloudSavePath;
    
    if (SSLCloudTypeDropbox == self.cloudType) {
        // "/" がない場合に補完する
        tmpSavePath = [NSLocalizedString(@"LData_Default_CloudSavePath", @"")
                       stringByAppendingPathComponent:tmpSavePath];
    }
    
    self->_cloudSavePath = tmpSavePath;
}

@end


#pragma mark -
#pragma mark ===== LauncherData (Managing) クラス =====
@implementation LauncherData (Managing)

/** インスタンスを作成する */
+ (instancetype)create
{
    LauncherData *data = [[LauncherData alloc] init];
    
    //=================================================================================
    // ここで設定した値が初期値となる。
    //=================================================================================
    data.title                  = NSLocalizedString(@"LData_Default_Title", @"");
    data.cloudType              = SSLCloudTypeDropbox;
    data.cloudSavePath          = NSLocalizedString(@"LData_Default_CloudSavePath", @"");
    data.isScannerConnectAuto   = YES;
    data.scannerName            = NSLocalizedString(@"LData_Default_ScannerName", @"");
    data.autoDelete             = SSAutoDeleteDel;
    data.fileformat             = SSFileFormatPDF;
    data.scanSide               = SSScanningSideBoth;
    data.colorMode              = SSColorModeAuto;
    data.concentration          = SSMonoConcentrationLv0;
    data.scanMode               = SSScanModeAuto;
    data.continueScan           = SSContinueScanEnable;
    data.blankPageSkip          = SSBlankPageSkipDel;
    data.reduceBleed            = SSReduceBleedThroughDisable;
    data.fileNameFormat         = SSFileNameFormatDirect;
    data.fileNameFormatEx       = SSFileNameFormatExScanRuntime;
    data.fileName               = NSLocalizedString(@"LData_Default_FileName", @"");
    data.paperSize              = SSPaperSizeAuto;
    data.multiFeed              = SSMultiFeedControlEnable;
    data.compression            = SSCompressionLv0;
    
    
    //============================================
    // 独自拡張用
    //============================================
    data.fileNameDisplay            = data.fileName;
    data.fileNamePrefix             = TMFileNamePrefixNone;
    data.fileNameSuffix             = TMFileNameSuffixNone;
    data.fileNamePrefixText         = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_DirectInput", @"");
    data.fileNameSuffixText         = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_DirectInput", @"");
    data.fileNamePrefixDelimiter    = TMDelimiterTypeUnderScore;
    data.fileNameSuffixDelimiter    = TMDelimiterTypeUnderScore;
    data.isFavorite                 = NO;
    data.isShareLink                = NO;
    data.isPreview                  = YES;
    data.sequentialNumberType       = TMSequentialNumberTypeNumParentheses;
    data.sequentialNumberDelimiter  = TMDelimiterTypeUnderScore;
    
    //============================================
    // 内部データ用
    //============================================
    data.launcherDataFileName       = @"";
    data.sortValue                  = UINT_MAX;
    data.favoriteSortValue          = UINT_MAX;
    
    return data;
}


/** 連想配列の値でインスタンスを作成する */
+ (instancetype)create:(NSDictionary *)dataDictionary
{
    
    LauncherData *data = [[LauncherData alloc] init];
    
    NSString *title = [dataDictionary valueForKey:@(LauncherDataPropTitle).stringValue];
    data.title = (title == nil) ? @"" : title;
    
    data.cloudType =
    [[dataDictionary valueForKey:@(LauncherDataPropCloudType).stringValue] integerValue];
    
    NSString *cloudSavePath = [dataDictionary valueForKey:@(LauncherDataPropCloudSavePath).stringValue];
    data.cloudSavePath = ([cloudSavePath length] <= 0) ? NSLocalizedString(@"LData_Default_CloudSavePath", @"") : cloudSavePath;

    data.isScannerConnectAuto =
    [[dataDictionary valueForKey:@(LauncherDataPropScannerConnectAuto).stringValue] boolValue];
    
    NSString *scannerName = [dataDictionary valueForKey:@(LauncherDataPropScannerName).stringValue];
    data.scannerName = ([scannerName length] <= 0) ? NSLocalizedString(@"LData_Default_ScannerName", @"") : scannerName;

    data.autoDelete =
    [[dataDictionary valueForKey:@(LauncherDataPropAutoDelete).stringValue] integerValue];

    data.fileformat =
    [[dataDictionary valueForKey:@(LauncherDataPropFileFormat).stringValue] integerValue];

    data.scanSide =
    [[dataDictionary valueForKey:@(LauncherDataPropScanSide).stringValue] integerValue];

    data.colorMode =
    [[dataDictionary valueForKey:@(LauncherDataPropColorMode).stringValue] integerValue];

    data.concentration =
    [[dataDictionary valueForKey:@(LauncherDataPropConcentration).stringValue] integerValue];
    
    data.scanMode =
    [[dataDictionary valueForKey:@(LauncherDataPropScanningMode).stringValue] integerValue];

    data.continueScan =
    [[dataDictionary valueForKey:@(LauncherDataPropContinueScan).stringValue] integerValue];

    data.blankPageSkip =
    [[dataDictionary valueForKey:@(LauncherDataPropBlankPageSkip).stringValue] integerValue];

    data.reduceBleed =
    [[dataDictionary valueForKey:@(LauncherDataPropReduceBleedThrough).stringValue] integerValue];

    data.fileNameFormat =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNameFormat).stringValue] integerValue];

    data.fileNameFormatEx =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNameFormatEx).stringValue] integerValue];
    
    NSString *fileName = [dataDictionary valueForKey:@(LauncherDataPropFileName).stringValue];
    data.fileName = ([fileName length] <= 0) ? NSLocalizedString(@"LData_Default_FileName", @"") : fileName;

    data.paperSize =
    [[dataDictionary valueForKey:@(LauncherDataPropPaperSize).stringValue] integerValue];

    data.multiFeed =
    [[dataDictionary valueForKey:@(LauncherDataPropMultiFeed).stringValue] integerValue];

    data.compression =
    [[dataDictionary valueForKey:@(LauncherDataPropCompression).stringValue] integerValue];

    //============================================
    // 独自拡張用
    //============================================
    NSString *fileNameDisplay = [dataDictionary valueForKey:@(LauncherDataPropFileNameDisplay).stringValue];
    data.fileNameDisplay =
    ([fileNameDisplay length] <= 0) ? data.fileName : fileNameDisplay;

    data.fileNamePrefix =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNamePrefix).stringValue] integerValue];

    data.fileNameSuffix =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNameSuffix).stringValue] integerValue];

    NSString *prefixText = [dataDictionary valueForKey:@(LauncherDataPropFileNamePrefixText).stringValue];
    data.fileNamePrefixText =
    ([prefixText length] <= 0) ? NSLocalizedString(@"SSParam_Ex_FileName_Prefix_DirectInput", @"") : prefixText;
    
    NSString *suffixText = [dataDictionary valueForKey:@(LauncherDataPropFileNameSuffixText).stringValue];
    data.fileNameSuffixText =
    ([suffixText length] <= 0) ? NSLocalizedString(@"SSParam_Ex_FileName_Suffix_DirectInput", @"") : suffixText;
    
    data.fileNamePrefixDelimiter =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNamePrefixDelimiter).stringValue] integerValue];
    
    data.fileNameSuffixDelimiter =
    [[dataDictionary valueForKey:@(LauncherDataPropFileNameSuffixDelimiter).stringValue] integerValue];
    
    data.isFavorite =
    [[dataDictionary valueForKey:@(LauncherDataPropFavorite).stringValue] boolValue];

    data.isShareLink =
    [[dataDictionary valueForKey:@(LauncherDataPropShareLink).stringValue] boolValue];

    data.isPreview =
    [[dataDictionary valueForKey:@(LauncherDataPropPreview).stringValue] boolValue];
    
    data.sequentialNumberType =
    [[dataDictionary valueForKey:@(LauncherDataPropSequentialNumberType).stringValue] integerValue];

    data.sequentialNumberDelimiter =
    [[dataDictionary valueForKey:@(LauncherDataPropSequentialNumberDelimiter).stringValue] integerValue];

    //============================================
    // 内部データ用
    //============================================
    [data setLauncherDataFileName:
     [dataDictionary valueForKey:@(LauncherDataPropInternalFileName).stringValue]];
    
    [data setSortValue:
     [[dataDictionary valueForKey:@(LauncherDataPropInternalSortValue).stringValue] integerValue]];

    [data setFavoriteSortValue:
     [[dataDictionary valueForKey:@(LauncherDataPropInternalFavoriteSortValue).stringValue] integerValue]];
    data.favoriteSortValue = (0 == data.favoriteSortValue) ? UINT_MAX : data.favoriteSortValue;
    
    return data;
}

/** プロパティの値を連想配列で取得する */
- (NSDictionary *)dataDictionary
{
    return
    @{
      @(LauncherDataPropTitle).stringValue:                 self.title,
      @(LauncherDataPropCloudType).stringValue:             @(self.cloudType),
      @(LauncherDataPropCloudSavePath).stringValue:         self.cloudSavePath,
      @(LauncherDataPropScannerConnectAuto).stringValue:    @(self.isScannerConnectAuto),
      @(LauncherDataPropScannerName).stringValue:           self.scannerName,
      @(LauncherDataPropAutoDelete).stringValue:            @(self.autoDelete),
      @(LauncherDataPropFileFormat).stringValue:            @(self.fileformat),
      @(LauncherDataPropScanSide).stringValue:              @(self.scanSide),
      @(LauncherDataPropColorMode).stringValue:             @(self.colorMode),
      @(LauncherDataPropConcentration).stringValue:         @(self.concentration),
      @(LauncherDataPropScanningMode).stringValue:          @(self.scanMode),
      @(LauncherDataPropContinueScan).stringValue:          @(self.continueScan),
      @(LauncherDataPropBlankPageSkip).stringValue:         @(self.blankPageSkip),
      @(LauncherDataPropReduceBleedThrough).stringValue:    @(self.reduceBleed),
      @(LauncherDataPropFileNameFormat).stringValue:        @(self.fileNameFormat),
      @(LauncherDataPropFileNameFormatEx).stringValue:      @(self.fileNameFormatEx),
      @(LauncherDataPropFileName).stringValue:              self.fileName,
      @(LauncherDataPropPaperSize).stringValue:             @(self.paperSize),
      @(LauncherDataPropMultiFeed).stringValue:             @(self.multiFeed),
      @(LauncherDataPropCompression).stringValue:           @(self.compression),
      
      //============================================
      // 独自拡張用
      //============================================
      @(LauncherDataPropFileNameDisplay).stringValue:               self.fileNameDisplay,
      @(LauncherDataPropFileNamePrefix).stringValue:                @(self.fileNamePrefix),
      @(LauncherDataPropFileNameSuffix).stringValue:                @(self.fileNameSuffix),
      @(LauncherDataPropFileNamePrefixText).stringValue:            self.fileNamePrefixText,
      @(LauncherDataPropFileNameSuffixText).stringValue:            self.fileNameSuffixText,
      @(LauncherDataPropFileNamePrefixDelimiter).stringValue:       @(self.fileNamePrefixDelimiter),
      @(LauncherDataPropFileNameSuffixDelimiter).stringValue:       @(self.fileNameSuffixDelimiter),
      @(LauncherDataPropFavorite).stringValue:                      @(self.isFavorite),
      @(LauncherDataPropShareLink).stringValue:                     @(self.isShareLink),
      @(LauncherDataPropPreview).stringValue:                       @(self.isPreview),
      @(LauncherDataPropSequentialNumberType).stringValue:          @(self.sequentialNumberType),
      @(LauncherDataPropSequentialNumberDelimiter).stringValue:     @(self.sequentialNumberDelimiter),

      //============================================
      // 内部データ用
      //============================================
      @(LauncherDataPropInternalFileName).stringValue:              [self launcherDataFileName],
      @(LauncherDataPropInternalSortValue).stringValue:             @(self.sortValue),
      @(LauncherDataPropInternalFavoriteSortValue).stringValue:     @(self.favoriteSortValue),

     };
}

/** 各種ゲッター/セッター */
- (void)setLauncherDataFileName:(NSString *)launcherDataFileName
{
    self->_launcherDataFileName = launcherDataFileName;
}
- (NSString *)launcherDataFileName
{
    return self->_launcherDataFileName;
}

- (void)setSortValue:(NSUInteger)sortValue
{
    self->_sortValue = sortValue;
}
- (NSUInteger)sortValue
{
    return self->_sortValue;
}
- (void)setFavoriteSortValue:(NSUInteger)favoriteSortValue
{
    self->_favoriteSortValue = favoriteSortValue;
}
- (NSUInteger)favoriteSortValue
{
    return self->_favoriteSortValue;
}

/** お気に入りソートの値をリセット */
- (void)resetFavoriteSortValue
{
    self->_favoriteSortValue = UINT_MAX;
}


/*****************************************/
/** 列挙体に合わせた表示用文字列              */
/*****************************************/
/** クラウドタイプの表示用の文字列を表示する */
+ (NSString *)cloudTypeText:(SSLCloudType)type
{
    NSString *typeString = NSLocalizedString(@"Common_Cloud_Dropbox", @"");

    switch (type) {
            
        case SSLCloudTypeEvernote:
            typeString = NSLocalizedString(@"Common_Cloud_Evernote", @"");
            break;

        case SSLCloudTypeiCloud:
            typeString = NSLocalizedString(@"Common_Cloud_iCloud", @"");
            break;
            
        case SSLCloudTypeOneDrive:
            typeString = NSLocalizedString(@"Common_Cloud_OneDrive", @"");
            break;

        case SSLCloudTypeGoogleDrive:
            typeString = NSLocalizedString(@"Common_Cloud_GoogleDrive", @"");
            break;

        default:
        case SSLCloudTypeDropbox:
            
            typeString = NSLocalizedString(@"Common_Cloud_Dropbox", @"");
            break;
    }
    
    return typeString;
}

/** 表示用のPrefix文字列を表示する */
+ (NSString *)displayPrefixText:(LauncherData*)data
{
    // Preix
    NSString *prefixDelimiter = [SSPalameters stringFromTMDelimiterType:data.fileNamePrefixDelimiter];
    NSString *preixStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_None", @"");
    
    switch (data.fileNamePrefix) {
            
        case TMFileNamePrefixDirectInput:
            
            preixStr = data.fileNamePrefixText;
            break;
            
        case TMFileNamePrefixyyyyMMdd:
        case TMFileNamePrefixyyyyMM:
        case TMFileNamePrefixyyyy:
        case TMFileNamePrefixMM:
        case TMFileNamePrefixMMdd:
            
            preixStr = [SSPalameters stringFromTMFileNamePrefix:data.fileNamePrefix];
            preixStr = [preixStr stringByAppendingString:prefixDelimiter];
            break;
            
        case TMFileNamePrefixNone:
        default:
            preixStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_None", @"");
            break;
    }
    
    return preixStr;
}

/** 表示用のPrefix文字列を表示する("なし"は表示しない) */
+ (NSString *)fileNamePrefixText:(LauncherData*)data
{
    // Preix
    NSString *preixStr = @"";
    
    switch (data.fileNamePrefix) {
            
        case TMFileNamePrefixNone:
            preixStr = @"";
            break;
            
        default:
            preixStr = [[self class] displayPrefixText:data];
            break;
    }
    
    return preixStr;
}

/** 表示用のSuffix文字列を表示する */
+ (NSString *)displaySuffixText:(LauncherData*)data
{
    // Suffix
    NSString *suffixDelimiter = [SSPalameters stringFromTMDelimiterType:data.fileNameSuffixDelimiter];
    NSString *suffixStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_None", @"");
    
    switch (data.fileNameSuffix) {
            
        case TMFileNameSuffixDirectInput:
            
            suffixStr = data.fileNameSuffixText;
            break;
            
        case TMFileNameSuffixyyyyMMdd:
        case TMFileNameSuffixyyyyMM:
        case TMFileNameSuffixyyyy:
        case TMFileNameSuffixMM:
        case TMFileNameSuffixMMdd:
            
            suffixStr = suffixDelimiter;
            suffixStr =
            [suffixStr stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:data.fileNameSuffix]];
            break;
            
        case TMFileNameSuffixNone:
        default:
            suffixStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_None", @"");
            break;
    }
    
    return suffixStr;
}

/** 表示用のSuffix文字列を表示する("なし"は表示しない) */
+ (NSString *)fileNameSuffixText:(LauncherData*)data
{
    // Suffix
    NSString *suffixStr = @"";
    
    switch (data.fileNameSuffix) {
            
        case TMFileNameSuffixNone:
            suffixStr = @"";
            break;
            
        default:
            suffixStr = [[self class] displaySuffixText:data];
            break;
    }
    
    return suffixStr;

}

/** クラウドタイプに合わせた入力を促す文字列を表示する */
+ (NSString *)promoEnterFileNameWithCloudType:(SSLCloudType)type
{
    NSString *typeString = NSLocalizedString(@"Common_Alert_Title_InputFileName", @"");
    
    switch (type) {
            
        case SSLCloudTypeEvernote:
            typeString = NSLocalizedString(@"Common_Alert_Title_InputNoteName", @"");
            break;
            
        case SSLCloudTypeiCloud:
            typeString = NSLocalizedString(@"Common_Alert_Title_InputFileName", @"");
            break;
            
        case SSLCloudTypeOneDrive:
            typeString = NSLocalizedString(@"Common_Alert_Title_InputFileName", @"");
            break;
            
        case SSLCloudTypeGoogleDrive:
            typeString = NSLocalizedString(@"Common_Alert_Title_InputFileName", @"");
            break;
            
        default:
        case SSLCloudTypeDropbox:
            
            typeString = NSLocalizedString(@"Common_Alert_Title_InputFileName", @"");
            break;
    }
    
    return typeString;
}

@end