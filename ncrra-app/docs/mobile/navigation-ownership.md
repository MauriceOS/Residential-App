# NCRRA navigation ownership and drawer visibility

**Prepared by Maurice Osoro**

## Principle

NCRRA uses two different navigation layers. The **bottom navigation** owns the member’s primary destinations: Home, Services, Community, Benefits and Account. The **secondary drawer** must not repeat those destinations or simply mirror their labels.

The drawer is a contextual utility surface for cross-cutting tasks that do not belong to the primary tab bar. Its current utility set is:

| Utility group | Drawer destinations | Ownership |
| --- | --- | --- |
| Member record | Member ID & association; Receipts & payment history | Member identity and records, not primary tab navigation |
| Updates & choices | Notifications & notices; Data & privacy | Cross-cutting notices and consent controls |
| Help & account safety | Security checkup; Help centre; Contact NCRRA | Support, session safety and escalation |

## Trigger visibility

The drawer trigger is shown on the authenticated **Home root**, where a member begins a session and may need a cross-cutting utility. It is not shown on utility detail screens, onboarding steps, payment steps, ticket detail screens or other flows that already have a back, close or task-specific action. Those screens should preserve a clear task context and avoid presenting multiple competing escape routes.

The Flutter implementation follows this rule by attaching `NcrraUtilityDrawer` to `HomeScreen` only. Utility detail screens use `NcrraTopBar` with a back action. The React visual prototype mirrors the same rule: the menu trigger is rendered in the Home header, while detail screens use the standard back header. The hamburger glyph is reserved for opening the drawer; the Services destination uses a service-catalogue icon so a primary destination is not mistaken for a global menu. Both tracks use a visually standalone control with a minimum 44×44 touch target; the icon itself remains restrained at roughly 20–24px and is not enclosed in a decorative circle or filled container.

## Regression expectations

When adding a new bottom-navigation destination, do not add it to the drawer. When adding a drawer utility, give it a specific cross-cutting purpose and either a dedicated destination or a clearly labelled prototype outcome. Tests should assert that the drawer contains no primary-tab labels and that the menu trigger is present on Home but absent on utility/detail screens.
