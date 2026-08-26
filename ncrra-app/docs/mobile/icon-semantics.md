# NCRRA icon semantics and header control

**Prepared by Maurice Osoro**

## Purpose

NCRRA uses icons as quiet semantic cues, not decoration. Icons remain standalone, use the established navy/teal action palette, and are paired with visible labels. The interface avoids generic lightning symbols, circular icon orbs and icons that merely make a screen look busy.

## Approved mapping

| Product meaning | React and Flutter icon | Rationale |
| --- | --- | --- |
| Home-header utility drawer | `Menu` | The hamburger is reserved for the contextual drawer and is not used for a bottom-navigation destination. |
| Services catalogue | `ListChecks` | Communicates a browsable list of available member services. |
| My connections | `Cable` | Communicates saved provider references and linked member accounts. |
| Kenya Power / electricity meter | `Gauge` | Communicates a meter reading or provider record without using a generic lightning bolt or a copied brand logo. |
| Water service | `Droplets` | Communicates water supply or account issues directly. |
| Property maintenance | `House` | Communicates shared-property requests. |
| Community | `UsersRound` | Communicates association members and shared activity. |
| Benefits | `Tag` | Communicates partner offers and member discounts. |

## Hamburger placement

The red-circled hamburger in the supplied reference is the Home-header drawer trigger. It is separate from the bottom Home tab. The trigger appears only on the authenticated Home root, uses a standalone 20–24px glyph inside a minimum 44×44 touch target, and sits beside the NCRRA mark with restrained spacing. It is absent from Services, Community, Benefits, Account, utility detail screens and task flows that already provide a back or task-specific action.

## Typography and hierarchy

Community and Benefits are member-facing destinations. Their headings use normal sentence case, not uppercase micro-labels. The primary page title is followed by a clear content introduction, then tabs or filters and actionable content rows/cards. Uppercase treatments remain limited to technical or transactional metadata where they improve scanning; they are not used as decorative section labels.

## Source of truth

Flutter is the mobile behavior source of truth. The React prototype mirrors the same navigation ownership, labels, icon semantics and conditional drawer visibility, with platform-specific implementation differences documented in `docs/architecture/cross-track-preview-apk-alignment.md`.
