//
//  PreviewModeTests.m
//  ContentfulSDK
//
//  Created by Boris Bügling on 20/03/14.
//
//

#import "ContentfulBaseTestCase.h"

@interface PreviewModeTests : ContentfulBaseTestCase

@end

#pragma mark -

@implementation PreviewModeTests

- (void)setUp {
    [super setUp];
    
    CDAConfiguration* configuration = [CDAConfiguration defaultConfiguration];
    configuration.previewMode = YES;
    
    self.client = [[CDAClient alloc] initWithSpaceKey:@"cfexampleapi" accessToken:@"5b5367a9a0cc3ab6ac2d4835bd8893907c61d3bafc7cb8b1f51840686a89fae3" configuration:configuration];
}

- (void)testAssetsInPreviewMode {
    StartBlock();
    
    [self.client fetchAssetWithIdentifier:@"nyancat" success:^(CDAResponse *response, CDAAsset *asset) {
        XCTAssertNotNil(asset.URL, @"");
        
        EndBlock();
    } failure:^(CDAResponse *response, NSError *error) {
        XCTFail(@"Error: %@", error);
        
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testFetchLotsOfResources {
    StartBlock();
    
    CDAConfiguration* conf = [CDAConfiguration defaultConfiguration];
    conf.previewMode = YES;
    self.client = [[CDAClient alloc] initWithSpaceKey:@"o5rx7qhjuvi8" accessToken:@"fd1b0875969c7045a0e4356ed05fa30f1ac1ea7bedaa4b96a0acdbedae645695" configuration:conf];
    [self.client fetchEntriesMatching:@{ @"content_type": @"5KRmcSqvE4OuYsWkMigI4A", @"include": @0 }
                              success:^(CDAResponse *response, CDAArray *array) {
                                  XCTAssertNotNil(array, @"");
                                  XCTAssertTrue(array.items.count > 0, @"");
                                  
                                  EndBlock();
                              } failure:^(CDAResponse *response, NSError *error) {
                                  XCTFail(@"Error: %@", error);
                                  
                                  EndBlock();
                              }];
    
    WaitUntilBlockCompletes();
}

- (void)testReturnsUnpublishedContent {
    StartBlock();
    
    [self.client fetchEntriesMatching:@{ @"content_type": @"1t9IbcfdCk6m04uISSsaIK" }
                              success:^(CDAResponse *response, CDAArray* array) {
                                  XCTAssertEqual(6U, array.items.count, @"");
                                  
                                  BOOL foundEntries = NO;
                                  
                                  for (CDAEntry* entry in array.items) {
                                      if ([entry.identifier isEqualToString:@"6hIqDVkumASkySQg4gQsys"] || [entry.identifier isEqualToString:@"ebFIXyjSfuO42EMIWYGKK"]) {
                                          XCTAssertEqualObjects(@"Föö", entry.fields[@"name"], @"");
                                          
                                          foundEntries = YES;
                                      }
                                  }
                                  
                                  XCTAssertTrue(foundEntries, @"Expected Entries not found.");
                                  EndBlock();
                              } failure:^(CDAResponse *response, NSError *error) {
                                  XCTFail(@"Error: %@", error);
                                  
                                  EndBlock();
                              }];
    
    WaitUntilBlockCompletes();
}

- (void)testRevisionFieldAccessible {
    StartBlock();
    
    [[CDAClient new] fetchEntryWithIdentifier:@"nyancat" success:^(CDAResponse *response,
                                                                   CDAEntry *entry) {
        NSNumber* revision = entry.sys[@"revision"];
        
        [self.client fetchEntryWithIdentifier:@"nyancat"
                                      success:^(CDAResponse *response, CDAEntry *entry) {
                                          XCTAssertNotNil(entry.sys[@"revision"], @"");
                                          XCTAssertEqualObjects(revision, entry.sys[@"revision"], @"");
                                          
                                          EndBlock();
                                      } failure:^(CDAResponse *response, NSError *error) {
                                          XCTFail(@"Error: %@", error);
                                          
                                          EndBlock();
                                      }];
    } failure:^(CDAResponse *response, NSError *error) {
        XCTFail(@"Error: %@", error);
        
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

@end
