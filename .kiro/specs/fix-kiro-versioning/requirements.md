# Requirements Document - Fix Kiro Versioning

> **Version** : 1.0.0  
> **Dernière mise à jour** : 2026-02-03  
> **Auteur** : Kiro  
> **Changelog** :
> - v1.0.0 (2026-02-03) : Création initiale

---

## Introduction

This document specifies the requirements for adding versioning metadata to 48 files in the `.kiro/` directory that currently lack proper version tracking. The versioning system follows the rules defined in `.kiro/steering/13-versioning-rules.md` and uses semantic versioning (MAJOR.MINOR.PATCH) to track changes over time.

The verification script `scripts_outils_ia/verify-versioning.ps1` has identified files across multiple categories that need versioning metadata added according to their file type (Markdown, JSON, or PowerShell).

---

## Glossary

- **Versioning_System**: The metadata structure that tracks version numbers, update dates, authors, and change history for files
- **Semantic_Version**: A version number in the format MAJOR.MINOR.PATCH (e.g., 1.0.0)
- **Metadata_Block**: The structured section at the beginning of a file containing versioning information
- **Steering_File**: Documentation files in `.kiro/steering/` that provide guidance and rules
- **Spec_File**: Specification files in `.kiro/specs/` that define features and requirements
- **Hook_File**: JSON configuration files in `.kiro/hooks/` that define automated behaviors
- **Script_File**: PowerShell scripts in `scripts_outils_ia/` that perform automated tasks
- **Changelog**: A chronological list of changes made to a file across versions

---

## Requirements

### Requirement 1: Add Versioning to Markdown Files

**User Story:** As a developer, I want all Markdown files in `.kiro/steering/` and `.kiro/specs/` to have versioning metadata, so that I can track their evolution over time.

#### Acceptance Criteria

1. WHEN a Markdown file in `.kiro/steering/` or `.kiro/specs/` is processed, THE Versioning_System SHALL add a metadata block after any YAML front-matter
2. THE Metadata_Block SHALL contain Version, Dernière mise à jour, Auteur, and Changelog fields
3. THE Version field SHALL be set to "1.0.0" for all existing files
4. THE Dernière mise à jour field SHALL be set to "2026-02-03"
5. THE Auteur field SHALL be set to "Kiro"
6. THE Changelog SHALL contain a single entry: "v1.0.0 (2026-02-03) : Création initiale"
7. THE Metadata_Block SHALL be formatted with blockquote syntax (lines starting with ">")
8. THE Metadata_Block SHALL be followed by a horizontal rule ("---")

### Requirement 2: Add Versioning to JSON Hook Files

**User Story:** As a developer, I want all JSON hook files to have versioning metadata, so that I can track changes to automated behaviors.

#### Acceptance Criteria

1. WHEN a JSON file in `.kiro/hooks/` is processed, THE Versioning_System SHALL add a "metadata" object as the first property
2. THE metadata object SHALL contain version, lastUpdate, author, and changelog properties
3. THE version property SHALL be set to "1.0.0"
4. THE lastUpdate property SHALL be set to "2026-02-03"
5. THE author property SHALL be set to "Kiro"
6. THE changelog property SHALL be an array containing a single object with version, date, and changes properties
7. THE changelog entry SHALL have version "1.0.0", date "2026-02-03", and changes "Création initiale"
8. THE JSON structure SHALL remain valid after adding metadata

### Requirement 3: Add Versioning to PowerShell Scripts

**User Story:** As a developer, I want all PowerShell scripts to have versioning metadata, so that I can track script evolution and compatibility.

#### Acceptance Criteria

1. WHEN a PowerShell script in `scripts_outils_ia/` is processed, THE Versioning_System SHALL add or update the comment-based help block
2. IF the script has an existing comment block, THE Versioning_System SHALL add versioning fields to it
3. IF the script has no comment block, THE Versioning_System SHALL create a new one with SYNOPSIS and DESCRIPTION
4. THE comment block SHALL contain .VERSION, .LAST UPDATE, .AUTHOR, and .CHANGELOG fields
5. THE .VERSION field SHALL be set to "1.0.0"
6. THE .LAST UPDATE field SHALL be set to "2026-02-03"
7. THE .AUTHOR field SHALL be set to "Kiro"
8. THE .CHANGELOG field SHALL contain "v1.0.0 (2026-02-03) : Création initiale"

### Requirement 4: Preserve File Content and Formatting

**User Story:** As a developer, I want the versioning addition process to preserve existing file content, so that no functionality is lost.

#### Acceptance Criteria

1. WHEN versioning metadata is added to a file, THE Versioning_System SHALL preserve all existing content
2. FOR Markdown files, THE Versioning_System SHALL preserve YAML front-matter if present
3. FOR JSON files, THE Versioning_System SHALL preserve all existing properties and their order (except metadata moves to first position)
4. FOR PowerShell files, THE Versioning_System SHALL preserve all code and existing comments
5. THE Versioning_System SHALL maintain proper indentation and formatting for each file type

### Requirement 5: Process Files in Priority Order

**User Story:** As a developer, I want critical files to be versioned first, so that the most important files are tracked immediately.

#### Acceptance Criteria

1. THE Versioning_System SHALL process files in three phases: hooks, steering files, then spec files, then scripts
2. WHEN processing Phase 1, THE Versioning_System SHALL complete all 3 hook files before proceeding
3. WHEN processing Phase 1, THE Versioning_System SHALL complete all 14 steering files before proceeding
4. WHEN processing Phase 1, THE Versioning_System SHALL complete all 12 spec files before proceeding
5. WHEN processing Phase 2, THE Versioning_System SHALL complete all 19 PowerShell scripts

### Requirement 6: Validate Versioning Compliance

**User Story:** As a developer, I want to verify that all files have correct versioning metadata, so that I can ensure compliance with versioning rules.

#### Acceptance Criteria

1. WHEN all files are processed, THE Versioning_System SHALL run the verification script
2. THE verification script SHALL check for presence of version numbers in the correct format
3. THE verification script SHALL check for presence of update dates in YYYY-MM-DD format
4. THE verification script SHALL report zero errors for all processed files
5. IF any file fails validation, THE Versioning_System SHALL report which files need correction

### Requirement 7: Handle Special Cases

**User Story:** As a developer, I want the system to handle edge cases correctly, so that all files are processed successfully.

#### Acceptance Criteria

1. WHEN a Markdown file has YAML front-matter, THE Versioning_System SHALL place the metadata block after the front-matter
2. WHEN a Markdown file has no YAML front-matter, THE Versioning_System SHALL place the metadata block at the beginning
3. WHEN a JSON file has comments (if supported), THE Versioning_System SHALL preserve them
4. WHEN a PowerShell script has a shebang or encoding declaration, THE Versioning_System SHALL preserve it at the top
5. IF a file is empty or unreadable, THE Versioning_System SHALL skip it and report a warning

---

## File List

### Phase 1: Critical Files (29 files)

**Steering Files (14):**
1. `.kiro/steering/01-project-overview.md`
2. `.kiro/steering/02-migration-angular-rules.md`
3. `.kiro/steering/03-rxjs-migration-patterns.md`
4. `.kiro/steering/04-ivy-migration-guide.md`
5. `.kiro/steering/05-webpack-custom-migration.md`
6. `.kiro/steering/06-testing-strategy.md`
7. `.kiro/steering/07-typescript-migration.md`
8. `.kiro/steering/08-workspace-hygiene.md`
9. `.kiro/steering/09-version-management.md`
10. `.kiro/steering/10-local-dev-config.md`
11. `.kiro/steering/11-playwright-e2e-testing.md`
12. `.kiro/steering/12-modification-rules.md`
13. `.kiro/steering/13-versioning-rules.md`
14. `.kiro/steering/08-nodejs-version-management.md` (if readable)

**Spec Files (12):**
1. `.kiro/specs/00-resume-executif.md`
2. `.kiro/specs/01-etat-actuel.md`
3. `.kiro/specs/02-plan-migration.md`
4. `.kiro/specs/03-risques-identifies.md`
5. `.kiro/specs/04-palier-01-angular-5-to-6.md`
6. `.kiro/specs/05-palier-04-angular-8-to-9-ivy.md`
7. `.kiro/specs/06-palier-07-angular-11-to-12-webpack5.md`
8. `.kiro/specs/07-palier-11-angular-15-to-16-signals.md`
9. `.kiro/specs/08-palier-12-angular-16-to-17-control-flow.md`
10. `.kiro/specs/09-palier-15-angular-19-to-20-final.md`
11. `.kiro/specs/10-workflow-tests-playwright.md`
12. `.kiro/specs/README.md`

**Hook Files (3):**
1. `.kiro/hooks/cleanup-and-journal.json`
2. `.kiro/hooks/rules-reminder.json`
3. `.kiro/hooks/sync-kiro-indexes.json`

### Phase 2: PowerShell Scripts (19 files)

1. `scripts_outils_ia/add-traceability-comments.ps1`
2. `scripts_outils_ia/backup-file.ps1`
3. `scripts_outils_ia/check-stack.ps1`
4. `scripts_outils_ia/cleanup-backups.ps1`
5. `scripts_outils_ia/document-git-changes.ps1`
6. `scripts_outils_ia/import-existing-modifications.ps1`
7. `scripts_outils_ia/install-dependencies.ps1`
8. `scripts_outils_ia/list-modifications.ps1`
9. `scripts_outils_ia/register-modification.ps1`
10. `scripts_outils_ia/rollback.ps1`
11. `scripts_outils_ia/Use-Node10.ps1`
12. `scripts_outils_ia/Use-Node12.ps1`
13. `scripts_outils_ia/Use-Node14.ps1`
14. `scripts_outils_ia/Use-Node16.ps1`
15. `scripts_outils_ia/Use-Node18.ps1`
16. `scripts_outils_ia/Use-Node20.ps1`
17. `scripts_outils_ia/Use-Node22.ps1`
18. `scripts_outils_ia/verify-backups.ps1`
19. `scripts_outils_ia/verify-comments.ps1`

---

## Success Criteria

The feature is complete when:
1. All 48 files have versioning metadata in the correct format
2. The verification script reports zero errors
3. All files remain functional and properly formatted
4. The versioning follows the rules in `13-versioning-rules.md`
