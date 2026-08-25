# NCRRA UI research findings

## Sources reviewed

Material Design’s navigation guidance explains that navigation should organize content within a hierarchy and make the most important top-level scenes prominent and accessible [1]. A current banking-app design reference emphasizes that financial-service UI depends on clear visual hierarchy, task prioritization, simplified navigation and visible trust signals [2].

## Design decisions for NCRRA

The NCRRA app should retain the supplied original screen’s strongest signals: warm off-white background, deep navy brand typography, the NCRRA mark, generous vertical breathing room, one clear primary action and restrained line icons. To reduce the “generic AI dashboard” feeling, use fewer repeated rounded cards, stronger editorial spacing, left-aligned content blocks and more deliberate section dividers.

The new action palette should make navy the primary action colour rather than green. Recommended tokens are: navy `#0B1E3B` for primary buttons and key headings; a muted blue `#315A86` for secondary emphasis and selected navigation; warm sand `#F1E7D2` for account/billing surfaces; muted amber `#B56B2A` for pending or due states; coral `#C9584C` for destructive/attention states; and the original teal only as a restrained brand/detail colour for the supplied logo and small confirmation accents. This preserves NCRRA recognition without making the entire interface green.

Motion should communicate navigation and state change rather than decorate the interface. Use 180–220 ms fade/slide transitions between top-level screens, 140 ms press feedback, 220 ms bottom-sheet entry, and reduced-motion fallbacks. Keep route state stable so section taps do not recreate expensive application state.

## References

[1]: https://m1.material.io/patterns/navigation.html "Material Design — Navigation patterns"
[2]: https://lollypop.design/blog/2026/june/banking-app-ui-design/ "Lollypop — Banking App UI Design: Principles, Best Practices & Examples (2026)"
