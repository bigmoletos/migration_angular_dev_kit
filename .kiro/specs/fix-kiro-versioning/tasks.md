# Implementation Plan: Fix Kiro Versioning

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale

---

## Overview

This implementation plan breaks down the versioning fix into discrete coding tasks. The approach processes files in priority order (hooks → steering → specs → scripts) and validates results after each phase. Each task builds incrementally on previous work, ensuring early validation of core functionality.

---

## Tasks

- [ ] 1. Set up project structure and utilities
  - Create TypeScript project structure for versioning tool
  - Set up file reading/writing utilities
  - Create data models (ProcessResult, ValidationResult, etc.)
  - Set up testing framework (Jest + fast-check)
  - _Requirements: 4.1, 4.5_

- [ ] 2. Implement Markdown processor
  - [ ] 2.1 Create MarkdownProcessor class with file reading
    - Implement file reading and content parsing
    - Create method to detect YAML front-matter (lines between `---` markers)
    - _Requirements: 1.1, 7.1, 7.2_
  
  - [ ] 2.2 Implement metadata generation for Markdown
    - Create method to generate metadata block with blockquote format
    - Include all required fields (Version, Dernière mise à jour, Auteur, Changelog)
    - Add horizontal rule after metadata
    - _Requirements: 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8_
  
  - [ ] 2.3 Implement metadata insertion logic
    - Find correct insertion point (after YAML front-matter or at beginning)
    - Insert metadata while preserving existing content
    - Write updated file
    - _Requirements: 1.1, 4.1, 4.2_
  
  - [ ]* 2.4 Write property test for Markdown processor
    - **Property 1: Markdown Metadata Structure and Values**
    - **Property 5: Metadata Insertion Point for Markdown Files**
    - **Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 7.1, 7.2**
  
  - [ ]* 2.5 Write unit tests for Markdown processor
    - Test file with YAML front-matter
    - Test file without YAML front-matter
    - Test file with existing content
    - _Requirements: 1.1, 4.2_

- [ ] 3. Implement JSON processor
  - [ ] 3.1 Create JSONProcessor class with JSON parsing
    - Implement JSON file reading and parsing
    - Handle JSON parsing errors gracefully
    - _Requirements: 2.1, 2.8_
  
  - [ ] 3.2 Implement metadata generation for JSON
    - Create metadata object with all required fields
    - Structure: version, lastUpdate, author, changelog array
    - _Requirements: 2.2, 2.3, 2.4, 2.5, 2.6, 2.7_
  
  - [ ] 3.3 Implement metadata insertion and property ordering
    - Insert metadata as first property
    - Preserve all existing properties in original order
    - Stringify with proper formatting (2-space indent)
    - Validate JSON structure remains valid
    - _Requirements: 2.1, 2.8, 4.3_
  
  - [ ]* 3.4 Write property test for JSON processor
    - **Property 2: JSON Metadata Structure and Values**
    - **Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8**
  
  - [ ]* 3.5 Write unit tests for JSON processor
    - Test simple JSON object
    - Test JSON with nested objects
    - Test invalid JSON (error handling)
    - _Requirements: 2.8, 4.3_

- [ ] 4. Implement PowerShell processor
  - [ ] 4.1 Create PowerShellProcessor class with comment block detection
    - Implement file reading
    - Detect existing comment-based help block (`<# ... #>`)
    - Parse comment block structure
    - _Requirements: 3.1, 3.2, 3.3_
  
  - [ ] 4.2 Implement metadata generation for PowerShell
    - Create versioning fields (.VERSION, .LAST UPDATE, .AUTHOR, .CHANGELOG)
    - Format according to PowerShell comment-based help syntax
    - _Requirements: 3.4, 3.5, 3.6, 3.7, 3.8_
  
  - [ ] 4.3 Implement comment block insertion/update logic
    - If comment block exists: add versioning fields to it
    - If no comment block: create new one with SYNOPSIS and DESCRIPTION
    - Preserve shebang and encoding declarations at top
    - Preserve all existing code and comments
    - _Requirements: 3.1, 3.2, 3.3, 4.4, 7.4_
  
  - [ ]* 4.4 Write property test for PowerShell processor
    - **Property 3: PowerShell Metadata Structure and Values**
    - **Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8**
  
  - [ ]* 4.5 Write unit tests for PowerShell processor
    - Test script with existing comment block
    - Test script without comment block
    - Test script with shebang
    - _Requirements: 3.2, 3.3, 7.4_

- [ ] 5. Checkpoint - Ensure all processor tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 6. Implement batch processor and orchestration
  - [ ] 6.1 Create BatchProcessor class with phase management
    - Define Phase enum (HOOKS, STEERING, SPECS, SCRIPTS)
    - Implement phase-based file processing
    - Track progress and errors for each phase
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_
  
  - [ ] 6.2 Implement file type detection and routing
    - Detect file type by extension (.md, .json, .ps1)
    - Route to appropriate processor
    - Handle unsupported file types
    - _Requirements: 1.1, 2.1, 3.1_
  
  - [ ] 6.3 Implement error handling and reporting
    - Handle file reading errors (skip and report)
    - Handle processing errors (skip and report)
    - Handle file writing errors (skip and report)
    - Generate progress reports during processing
    - _Requirements: 7.5_
  
  - [ ]* 6.4 Write property test for content preservation
    - **Property 4: Content Preservation Across File Types**
    - **Validates: Requirements 4.1, 4.2, 4.3, 4.4**
  
  - [ ]* 6.5 Write property test for error handling
    - **Property 7: Error Handling for Unreadable Files**
    - **Validates: Requirements 7.5**
  
  - [ ]* 6.6 Write unit tests for batch processor
    - Test phase ordering
    - Test progress reporting
    - Test error aggregation
    - _Requirements: 5.1_

- [ ] 7. Implement validator
  - [ ] 7.1 Create Validator class with validation logic
    - Check for version number pattern (X.Y.Z)
    - Check for date pattern (YYYY-MM-DD)
    - Check for author field presence
    - Check for changelog field presence
    - _Requirements: 6.2, 6.3_
  
  - [ ] 7.2 Implement validation reporting
    - Generate ValidationResult for each file
    - Generate ValidationReport for all files
    - Report which files need correction
    - _Requirements: 6.4, 6.5_
  
  - [ ]* 7.3 Write property test for validator
    - **Property 6: Validation Script Accuracy**
    - **Validates: Requirements 6.2, 6.3, 6.5**
  
  - [ ]* 7.4 Write unit tests for validator
    - Test validation of compliant files
    - Test validation of non-compliant files
    - Test validation report generation
    - _Requirements: 6.2, 6.3_

- [ ] 8. Create main execution script
  - [ ] 8.1 Create main script with file list
    - Define all 48 files to process in priority order
    - Phase 1: 3 hooks, 14 steering, 12 specs
    - Phase 2: 19 PowerShell scripts
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_
  
  - [ ] 8.2 Implement execution workflow
    - Process Phase 1 (hooks, steering, specs)
    - Process Phase 2 (scripts)
    - Run validator after all processing
    - Generate final report
    - _Requirements: 6.1, 6.4_
  
  - [ ] 8.3 Add progress reporting and logging
    - Report current phase and progress
    - Log errors and warnings
    - Display final summary
    - _Requirements: 5.1, 7.5_

- [ ] 9. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 10. Execute versioning fix on actual files
  - [ ] 10.1 Run main script on Phase 1 files (hooks, steering, specs)
    - Process 3 hook files
    - Process 14 steering files
    - Process 12 spec files
    - Verify no errors during processing
    - _Requirements: 1.1, 2.1, 5.1, 5.2, 5.3, 5.4_
  
  - [ ] 10.2 Run main script on Phase 2 files (PowerShell scripts)
    - Process 19 PowerShell scripts
    - Verify no errors during processing
    - _Requirements: 3.1, 5.1, 5.5_
  
  - [ ] 10.3 Run verification script
    - Execute `scripts_outils_ia/verify-versioning.ps1`
    - Verify zero errors reported
    - Review validation report
    - _Requirements: 6.1, 6.4_

- [ ] 11. Final validation and cleanup
  - [ ] 11.1 Manual inspection of sample files
    - Inspect sample Markdown files (steering and specs)
    - Inspect sample JSON files (hooks)
    - Inspect sample PowerShell scripts
    - Verify formatting and content preservation
    - _Requirements: 4.1, 4.5_
  
  - [ ] 11.2 Verify file functionality
    - Verify JSON files are valid (can be parsed)
    - Verify Markdown files render correctly
    - Verify PowerShell scripts can be executed
    - _Requirements: 2.8, 4.1_
  
  - [ ]* 11.3 Run integration tests
    - Test complete workflow on test files
    - Verify all 48 files processed successfully
    - Verify validation script reports zero errors
    - _Requirements: 6.1, 6.4_

- [ ] 12. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

---

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties (minimum 100 iterations each)
- Unit tests validate specific examples and edge cases
- The implementation uses TypeScript for type safety and maintainability
- All processors preserve existing file content while adding metadata
- Error handling ensures the system continues processing even if individual files fail

---

## File List Reference

### Phase 1: Critical Files (29 files)

**Hooks (3):**
- `.kiro/hooks/cleanup-and-journal.json`
- `.kiro/hooks/rules-reminder.json`
- `.kiro/hooks/sync-kiro-indexes.json`

**Steering (14):**
- `.kiro/steering/01-project-overview.md`
- `.kiro/steering/02-migration-angular-rules.md`
- `.kiro/steering/03-rxjs-migration-patterns.md`
- `.kiro/steering/04-ivy-migration-guide.md`
- `.kiro/steering/05-webpack-custom-migration.md`
- `.kiro/steering/06-testing-strategy.md`
- `.kiro/steering/07-typescript-migration.md`
- `.kiro/steering/08-workspace-hygiene.md`
- `.kiro/steering/09-version-management.md`
- `.kiro/steering/10-local-dev-config.md`
- `.kiro/steering/11-playwright-e2e-testing.md`
- `.kiro/steering/12-modification-rules.md`
- `.kiro/steering/13-versioning-rules.md`
- `.kiro/steering/08-nodejs-version-management.md` (if readable)

**Specs (12):**
- `.kiro/specs/00-resume-executif.md`
- `.kiro/specs/01-etat-actuel.md`
- `.kiro/specs/02-plan-migration.md`
- `.kiro/specs/03-risques-identifies.md`
- `.kiro/specs/04-palier-01-angular-5-to-6.md`
- `.kiro/specs/05-palier-04-angular-8-to-9-ivy.md`
- `.kiro/specs/06-palier-07-angular-11-to-12-webpack5.md`
- `.kiro/specs/07-palier-11-angular-15-to-16-signals.md`
- `.kiro/specs/08-palier-12-angular-16-to-17-control-flow.md`
- `.kiro/specs/09-palier-15-angular-19-to-20-final.md`
- `.kiro/specs/10-workflow-tests-playwright.md`
- `.kiro/specs/README.md`

### Phase 2: PowerShell Scripts (19 files)

- `scripts_outils_ia/add-traceability-comments.ps1`
- `scripts_outils_ia/backup-file.ps1`
- `scripts_outils_ia/check-stack.ps1`
- `scripts_outils_ia/cleanup-backups.ps1`
- `scripts_outils_ia/document-git-changes.ps1`
- `scripts_outils_ia/import-existing-modifications.ps1`
- `scripts_outils_ia/install-dependencies.ps1`
- `scripts_outils_ia/list-modifications.ps1`
- `scripts_outils_ia/register-modification.ps1`
- `scripts_outils_ia/rollback.ps1`
- `scripts_outils_ia/Use-Node10.ps1`
- `scripts_outils_ia/Use-Node12.ps1`
- `scripts_outils_ia/Use-Node14.ps1`
- `scripts_outils_ia/Use-Node16.ps1`
- `scripts_outils_ia/Use-Node18.ps1`
- `scripts_outils_ia/Use-Node20.ps1`
- `scripts_outils_ia/Use-Node22.ps1`
- `scripts_outils_ia/verify-backups.ps1`
- `scripts_outils_ia/verify-comments.ps1`
