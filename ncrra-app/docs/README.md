# NCRRA Documentation

**Prepared by Maurice Osoro**

This directory contains maintained documentation for engineers, operators and reviewers. Historical research and source material is kept separately under `brainstorm/`.

## Maintained documents

| Location | Purpose |
| --- | --- |
| `maintainers-guide.md` | Handoff, ownership, security rules, change workflow and definition of done. |
| `mobile/` | Flutter authentication, emulator/device testing and Android handoff notes. Includes `android-11-install-evidence.md` for the recorded Windows/ADB storage failure and safe retry path, `navigation-ownership.md` for drawer and bottom-navigation rules, and `icon-semantics.md` for the approved icon mapping, hamburger placement and sentence-case hierarchy. |
| `ui_ux_deck_content.md` | Stakeholder UI/UX presentation content. |
| `product/tubik-informed-mobile-screen-adaptations.md` | NCRRA-specific recommendations adapted from the supplied Tubik screen-pattern reference. |
| `product/tubik-motion-review-notes.md` | Review notes for restrained, purposeful motion and feedback patterns adapted from the supplied animation reference. |
| `verification/runtime-log-audit.md` | Timestamped runtime-log findings, historical-error separation and post-correction verification notes. |
| `architecture/cross-track-preview-apk-alignment.md` | React-preview versus Flutter-APK source-of-truth rules, parity matrix and checksum-based device comparison procedure. |

## Implementation references

The implementation track contains module-local README files and technical boundaries that belong beside the code they describe:

- `implementation/README.md` explains the modular implementation track.
- `implementation/architecture/` defines service ownership and boundaries.
- `implementation/backend/` describes the .NET service scaffolds.
- `implementation/providers/` describes provider agreement and readiness controls.
- `implementation/ops/` describes VPS operations and security rules.
- `implementation/verification/` records verification evidence and limits.

If a document is a proposal, benchmark, source extract or decision exploration, place it under `brainstorm/research/` and link to it from `brainstorm/README.md`. Visual planning references belong under `brainstorm/assets/`, with a short index describing their provenance and intended use. If it is a current operating rule or handoff requirement, keep it under `docs/` and assign an owner.
