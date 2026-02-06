# Design Document - Fix Kiro Versioning

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale

---

## Overview

This design document describes the implementation approach for adding versioning metadata to 48 files in the `.kiro/` directory. The solution processes files in batches according to their type (Markdown, JSON, PowerShell) and priority level, adding standardized versioning metadata while preserving all existing content.

The implementation follows a file-type-specific approach where each file format has its own metadata structure and insertion logic. The system processes files in priority order (hooks → steering → specs → scripts) to ensure critical files are versioned first.

---

## Architecture

### High-Level Approach

The system uses a batch processing architecture with three main components:

1. **File Processor**: Reads files, identifies insertion points, and writes updated content
2. **Metadata Generator**: Creates format-specific metadata blocks
3. **Validator**: Verifies that all files have correct versioning after processing

### Processing Flow

```
Input: List of files to process
  ↓
For each file:
  1. Read file content
  2. Detect file type (MD/JSON/PS1)
  3. Generate appropriate metadata
  4. Find insertion point
  5. Insert metadata
  6. Write updated file
  ↓
Run verification script
  ↓
Output: Validation report
```

### File Type Detection

Files are categorized by extension:
- `.md` → Markdown processor
- `.json` → JSON processor
- `.ps1` → PowerShell processor

---

## Components and Interfaces

### Component 1: Markdown Processor

**Responsibility**: Add versioning metadata to Markdown files

**Interface**:
```typescript
interface MarkdownProcessor {
  processFile(filePath: string): ProcessResult;
  generateMetadata(): string;
  findInsertionPoint(content: string): number;
}
```

**Behavior**:
- Detects YAML front-matter (lines between `---` markers at start)
- Inserts metadata block after front-matter or at beginning
- Uses blockquote format (`> **Field**: value`)
- Adds horizontal rule after metadata

**Metadata Format**:
```markdown
> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale

---
```

### Component 2: JSON Processor

**Responsibility**: Add versioning metadata to JSON hook files

**Interface**:
```typescript
interface JSONProcessor {
  processFile(filePath: string): ProcessResult;
  generateMetadata(): MetadataObject;
  insertMetadata(json: object, metadata: MetadataObject): object;
}
```

**Behavior**:
- Parses JSON file
- Creates metadata object
- Inserts metadata as first property
- Preserves formatting and property order
- Validates JSON structure

**Metadata Structure**:
```json
{
  "metadata": {
    "version": "1.0.0",
    "lastUpdate": "2026-02-03",
    "author": "Kiro",
    "changelog": [
      {
        "version": "1.0.0",
        "date": "2026-02-03",
        "changes": "Création initiale"
      }
    ]
  }
}
```

### Component 3: PowerShell Processor

**Responsibility**: Add versioning metadata to PowerShell scripts

**Interface**:
```typescript
interface PowerShellProcessor {
  processFile(filePath: string): ProcessResult;
  generateMetadata(): string;
  findOrCreateCommentBlock(content: string): CommentBlockInfo;
}
```

**Behavior**:
- Detects existing comment-based help block (`<# ... #>`)
- If exists: adds versioning fields to existing block
- If not exists: creates new block with SYNOPSIS, DESCRIPTION, and versioning
- Preserves shebang and encoding declarations
- Maintains proper PowerShell comment syntax

**Metadata Format**:
```powershell
<#
.VERSION
    1.0.0

.LAST UPDATE
    2026-02-03

.AUTHOR
    Kiro

.CHANGELOG
    v1.0.0 (2026-02-03) : Création initiale
#>
```

### Component 4: Batch Processor

**Responsibility**: Orchestrate processing of all files in priority order

**Interface**:
```typescript
interface BatchProcessor {
  processPhase(phase: Phase): PhaseResult;
  processFileList(files: string[]): BatchResult;
}

enum Phase {
  HOOKS = 1,
  STEERING = 2,
  SPECS = 3,
  SCRIPTS = 4
}
```

**Behavior**:
- Processes files in defined phases
- Tracks success/failure for each file
- Provides progress reporting
- Handles errors gracefully (skip and report)

### Component 5: Validator

**Responsibility**: Verify versioning compliance after processing

**Interface**:
```typescript
interface Validator {
  validateFile(filePath: string): ValidationResult;
  validateAll(files: string[]): ValidationReport;
}
```

**Behavior**:
- Checks for version number in format X.Y.Z
- Checks for date in format YYYY-MM-DD
- Verifies metadata structure for each file type
- Generates compliance report

---

## Data Models

### ProcessResult

```typescript
interface ProcessResult {
  filePath: string;
  success: boolean;
  error?: string;
  skipped: boolean;
  reason?: string;
}
```

### MetadataObject (JSON)

```typescript
interface MetadataObject {
  version: string;        // "1.0.0"
  lastUpdate: string;     // "2026-02-03"
  author: string;         // "Kiro"
  changelog: ChangelogEntry[];
}

interface ChangelogEntry {
  version: string;
  date: string;
  changes: string;
}
```

### CommentBlockInfo (PowerShell)

```typescript
interface CommentBlockInfo {
  exists: boolean;
  startLine: number;
  endLine: number;
  hasVersion: boolean;
  hasLastUpdate: boolean;
  hasAuthor: boolean;
  hasChangelog: boolean;
}
```

### ValidationResult

```typescript
interface ValidationResult {
  filePath: string;
  hasVersion: boolean;
  hasDate: boolean;
  hasAuthor: boolean;
  hasChangelog: boolean;
  compliant: boolean;
  errors: string[];
}
```

### Phase

```typescript
interface Phase {
  name: string;
  files: string[];
  priority: number;
}
```

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Markdown Metadata Structure and Values

*For any* Markdown file in `.kiro/steering/` or `.kiro/specs/`, when processed by the Versioning_System, the resulting file should contain a metadata block with all required fields (Version: "1.0.0", Dernière mise à jour: "2026-02-03", Auteur: "Kiro", Changelog with initial entry), formatted with blockquote syntax, and followed by a horizontal rule.

**Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8**

### Property 2: JSON Metadata Structure and Values

*For any* JSON file in `.kiro/hooks/`, when processed by the Versioning_System, the resulting JSON should have a "metadata" object as the first property containing all required fields (version: "1.0.0", lastUpdate: "2026-02-03", author: "Kiro", changelog array with initial entry), and the JSON structure should remain valid.

**Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8**

### Property 3: PowerShell Metadata Structure and Values

*For any* PowerShell script in `scripts_outils_ia/`, when processed by the Versioning_System, the resulting script should have a comment-based help block containing all required versioning fields (.VERSION: "1.0.0", .LAST UPDATE: "2026-02-03", .AUTHOR: "Kiro", .CHANGELOG with initial entry).

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8**

### Property 4: Content Preservation Across File Types

*For any* file processed by the Versioning_System, all existing content (excluding the newly added metadata) should be preserved exactly, including YAML front-matter for Markdown files, all properties and their order for JSON files (except metadata position), and all code and comments for PowerShell files.

**Validates: Requirements 4.1, 4.2, 4.3, 4.4**

### Property 5: Metadata Insertion Point for Markdown Files

*For any* Markdown file, when the file contains YAML front-matter (delimited by `---`), the metadata block should be inserted after the front-matter; when no YAML front-matter exists, the metadata block should be inserted at the beginning of the file.

**Validates: Requirements 1.1, 7.1, 7.2**

### Property 6: Validation Script Accuracy

*For any* file with correct versioning metadata, the verification script should report zero errors; for any file with missing or incorrect versioning metadata, the verification script should report which specific files need correction.

**Validates: Requirements 6.2, 6.3, 6.5**

### Property 7: Error Handling for Unreadable Files

*For any* file that is empty or unreadable, the Versioning_System should skip processing it and report a warning with the file path, without crashing or corrupting other files.

**Validates: Requirements 7.5**

---

## Error Handling

### File Reading Errors

**Scenario**: File cannot be read (permissions, corruption, empty file)

**Handling**:
- Skip the file
- Log warning with file path and error reason
- Continue processing remaining files
- Include skipped files in final report

### JSON Parsing Errors

**Scenario**: JSON file has invalid syntax

**Handling**:
- Skip the file
- Log error with file path and parsing error details
- Continue processing remaining files
- Report file in validation report as needing manual correction

### File Writing Errors

**Scenario**: Cannot write updated file (permissions, disk space)

**Handling**:
- Log error with file path
- Do not modify original file
- Continue processing remaining files
- Report file in final report as failed

### YAML Front-Matter Detection Errors

**Scenario**: Malformed YAML front-matter in Markdown file

**Handling**:
- Attempt to detect front-matter boundaries using `---` markers
- If detection fails, insert metadata at beginning
- Log warning about potential front-matter issue
- Continue processing

### PowerShell Comment Block Parsing Errors

**Scenario**: Existing comment block has unexpected format

**Handling**:
- If comment block cannot be parsed, create new block at top
- Preserve existing comment block in file
- Log warning about comment block format
- Continue processing

---

## Testing Strategy

### Dual Testing Approach

This feature requires both unit tests and property-based tests to ensure comprehensive coverage:

- **Unit tests**: Verify specific examples, edge cases, and error conditions
- **Property tests**: Verify universal properties across all inputs

Both approaches are complementary and necessary for complete validation.

### Property-Based Testing

**Library**: Use `fast-check` for TypeScript/JavaScript implementation

**Configuration**:
- Minimum 100 iterations per property test
- Each test references its design document property
- Tag format: **Feature: fix-kiro-versioning, Property {number}: {property_text}**

**Property Test Coverage**:

1. **Property 1 Test**: Generate random Markdown files (with/without YAML front-matter, various content), process them, verify metadata structure and values
   - Generator: Markdown content with optional YAML front-matter
   - Assertion: Metadata block present with correct format and values

2. **Property 2 Test**: Generate random JSON objects, process them, verify metadata is first property with correct structure
   - Generator: Valid JSON objects with various properties
   - Assertion: Metadata object is first, contains all required fields, JSON remains valid

3. **Property 3 Test**: Generate random PowerShell scripts (with/without existing comment blocks), process them, verify versioning fields
   - Generator: PowerShell code with optional comment blocks
   - Assertion: Comment block contains all versioning fields with correct values

4. **Property 4 Test**: Generate random files of each type, process them, verify original content is preserved
   - Generator: Files with various content
   - Assertion: Content (excluding metadata) matches original

5. **Property 5 Test**: Generate Markdown files with and without YAML front-matter, verify insertion point
   - Generator: Markdown with/without YAML front-matter
   - Assertion: Metadata position is correct based on front-matter presence

6. **Property 6 Test**: Generate files with correct and incorrect versioning, verify validation script accuracy
   - Generator: Files with various versioning states
   - Assertion: Validation script correctly identifies compliant/non-compliant files

7. **Property 7 Test**: Generate empty and unreadable files, verify error handling
   - Generator: Empty files, files with read errors
   - Assertion: System skips files and reports warnings without crashing

### Unit Testing

**Unit Test Coverage**:

1. **Markdown Processor Tests**:
   - Test file with YAML front-matter
   - Test file without YAML front-matter
   - Test file with existing content
   - Test empty file

2. **JSON Processor Tests**:
   - Test simple JSON object
   - Test JSON with nested objects
   - Test JSON with arrays
   - Test invalid JSON (error handling)

3. **PowerShell Processor Tests**:
   - Test script with existing comment block
   - Test script without comment block
   - Test script with shebang
   - Test script with encoding declaration

4. **Batch Processor Tests**:
   - Test phase ordering
   - Test progress reporting
   - Test error aggregation

5. **Validator Tests**:
   - Test validation of compliant files
   - Test validation of non-compliant files
   - Test validation report generation

### Integration Testing

**Integration Test Scenarios**:

1. Process all 48 files in the actual file list
2. Run verification script on processed files
3. Verify zero errors reported
4. Manually inspect sample files from each category

### Edge Cases to Test

1. Markdown file with complex YAML front-matter (nested objects, arrays)
2. JSON file with very large objects
3. PowerShell script with multiple comment blocks
4. Files with unusual line endings (CRLF vs LF)
5. Files with special characters in content
6. Files with Unicode characters

---

## Implementation Notes

### File Processing Order

The implementation should process files in this exact order:

**Phase 1: Critical Files**
1. Process 3 hook files (`.kiro/hooks/*.json`)
2. Process 14 steering files (`.kiro/steering/*.md`)
3. Process 12 spec files (`.kiro/specs/*.md`)

**Phase 2: Scripts**
4. Process 19 PowerShell scripts (`scripts_outils_ia/*.ps1`)

### Metadata Insertion Logic

**For Markdown**:
```
1. Read file content
2. Check for YAML front-matter (starts with ---, ends with ---)
3. If front-matter exists:
   - Find end of front-matter (second ---)
   - Insert metadata after front-matter + newline
4. If no front-matter:
   - Insert metadata at beginning
5. Add horizontal rule after metadata
```

**For JSON**:
```
1. Parse JSON file
2. Create metadata object
3. Create new object with metadata as first property
4. Copy all other properties in original order
5. Stringify with proper formatting (2-space indent)
```

**For PowerShell**:
```
1. Read file content
2. Check for existing comment block (<# ... #>)
3. If comment block exists:
   - Parse block to find existing fields
   - Add missing versioning fields
   - Preserve existing fields
4. If no comment block:
   - Create new block with SYNOPSIS, DESCRIPTION
   - Add all versioning fields
5. Preserve shebang/encoding at top if present
```

### Validation Logic

The verification script should check:
1. Version number matches pattern: `\d+\.\d+\.\d+`
2. Date matches pattern: `\d{4}-\d{2}-\d{2}`
3. Author field is present and non-empty
4. Changelog field is present

### Progress Reporting

During batch processing, report:
- Current phase
- Files processed in current phase
- Total files processed
- Errors encountered
- Estimated time remaining

---

## Dependencies

- File system access (Node.js `fs` module or equivalent)
- JSON parser (built-in `JSON.parse`/`JSON.stringify`)
- Regular expressions for pattern matching
- Property-based testing library (`fast-check`)
- Existing verification script (`scripts_outils_ia/verify-versioning.ps1`)

---

## Success Criteria

The implementation is complete when:

1. All 48 files have versioning metadata in the correct format
2. The verification script reports zero errors
3. All property-based tests pass (minimum 100 iterations each)
4. All unit tests pass
5. Manual inspection confirms files are properly formatted
6. No existing content has been lost or corrupted
7. All files remain functional (JSON is valid, PowerShell scripts run, Markdown renders correctly)
