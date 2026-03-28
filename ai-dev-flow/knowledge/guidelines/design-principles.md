# Design Principles Reference

This is the shared design principles reference for the AI Dev Flow. It is read by `/flow-ux` (UX Specification) to ensure consistency across design decisions. It may also be referenced by `/flow-code` and `/flow-review` when implementing or reviewing UI work.

## Design Systems Worth Studying

These design systems represent the state of the art. Study their patterns, not their pixels.

- **Google Material Design 3** — Adaptive, personalized interfaces. Dynamic color from user content. Strong emphasis on motion and elevation. Best for: cross-platform consistency.
- **Apple Human Interface Guidelines (HIG)** — Intuitive, accessible, ecosystem-coherent. Subtle depth and translucency. Best for: native-feeling experiences with high polish.
- **Microsoft Fluent Design** — Light, depth, motion, material. Highly adaptive across device form factors. Best for: enterprise and productivity tools.
- **Shopify Polaris** — Web Components, framework-agnostic. Clear merchant-focused patterns. Best for: commerce and admin interfaces.
- **Stripe** — Clarity and hierarchy in data-dense interfaces. Exceptional typography and spacing. Gradient accents used sparingly. Best for: fintech, developer tools, dashboards.
- **Linear** — Minimal, keyboard-first, developer-focused. Dark mode default. Intentional animations. Best for: productivity tools and developer experiences.
- **Vercel** — Clean borders, Geist font family, dark mode default. Restrained color palette (zinc/neutral + one accent). Best for: developer tools and dashboards.
- **Airbnb** — Evolving toward tactile, depth-rich interfaces with 3D elements. Warm, consumer-friendly. Best for: marketplace and consumer experiences.

## Atomic Design (Brad Frost)

Organize components in a hierarchy from simple to complex:

- **Atoms** — The smallest building blocks. Buttons, inputs, labels, icons, badges, toggles, avatars. Cannot be broken down further while remaining useful.
- **Molecules** — Functional combinations of atoms. A search bar (input + button + icon), a form field (label + input + error message), a nav item (icon + text + badge).
- **Organisms** — Complex, distinct sections of an interface. Navigation bars, forms with multiple fields, data tables, card grids, modals, sidebars.
- **Templates** — Page-level layouts with placeholder content. Define the skeleton: where organisms go, how they relate spatially, how the grid works.
- **Pages** — Templates filled with real content. The final composition the user sees. Used to validate that the design system works with actual data.

When to use each level:

| Level | Reuse expectation | Example |
|-------|-------------------|---------|
| Atom | Used everywhere, dozens of instances | Button, Input, Badge |
| Molecule | Used in multiple organisms | SearchBar, FormField |
| Organism | Used across templates | Header, DataTable, Sidebar |
| Template | 1-3 variations per product | DashboardLayout, AuthLayout |
| Page | Unique compositions | SettingsPage, InvoiceDetail |

## Design Token Hierarchy

Tokens are the single source of truth for visual decisions. Never hardcode a raw value.

### Three levels

1. **Primitive tokens** — Raw values with no semantic meaning. The foundation palette.
   - `--blue-500: #3B82F6`, `--gray-900: #171717`, `--space-4: 16px`

2. **Semantic tokens** — Context-aware aliases that express intent.
   - `--color-bg-primary: var(--gray-900)`, `--color-text-muted: var(--gray-400)`
   - `--color-destructive: var(--red-500)`, `--color-success: var(--green-500)`

3. **Component tokens** — Scoped to specific components.
   - `--button-bg: var(--color-bg-primary)`, `--card-border: var(--color-border-subtle)`

### Implementation patterns

- Use CSS custom properties on `:root` for global tokens
- Use `[data-theme="dark"]` or `.dark` class for theme switching
- Tailwind CSS 4: use the `@theme` directive for single source of truth
- Version-control token updates like code with semantic versioning

## Typography Principles

Typography creates hierarchy before color or decoration ever enters the picture.

### Type scale ratios

| Ratio | Name | Use case |
|-------|------|----------|
| 1.200 | Minor Third | Compact UIs, data-dense dashboards |
| 1.250 | Major Third | General purpose, balanced hierarchy |
| 1.333 | Perfect Fourth | Marketing, editorial, spacious layouts |
| 1.414 | Augmented Fourth | Bold statements, hero sections |

### Weight hierarchy

- **Regular (400)** — Body text, descriptions
- **Medium (500)** — Subtle emphasis, secondary headings, labels
- **Semibold (600)** — Primary headings, important labels
- **Bold (700)** — Sparingly. Page titles, critical callouts

### Font recommendations

- **Geist Sans** — Interface text (Vercel ecosystem)
- **Geist Mono** — Code, metrics, IDs, timestamps, terminal output
- **Inter** — Versatile alternative for general interfaces
- **JetBrains Mono** — Code and developer content

### Line height

- **Headings:** 1.1 to 1.3 (tighter for visual impact)
- **Body:** 1.5 to 1.6 (comfortable reading)
- **UI labels:** 1.0 to 1.2 (compact, no extra space)

## Color System

### The 60-30-10 Rule

- **60%** — Background / surface (neutral tones)
- **30%** — Secondary elements (cards, sections, borders)
- **10%** — Accent / interactive (buttons, links, highlights)

### Semantic color roles

| Role | Purpose | Example |
|------|---------|---------|
| `bg-primary` | Main page background | `#FFFFFF` / `#0A0A0A` |
| `bg-secondary` | Cards, sections, panels | `#F9FAFB` / `#171717` |
| `fg-primary` | Main text | `#171717` / `#FAFAFA` |
| `fg-muted` | Secondary text, placeholders | `#6B7280` / `#A1A1AA` |
| `border-default` | Standard borders | `#E5E7EB` / `#27272A` |
| `accent` | Primary actions, links | Project-specific |
| `destructive` | Danger, delete actions | Red family |
| `warning` | Caution states | Amber/yellow family |
| `success` | Confirmation, completed | Green family |

### Contrast requirements (WCAG 2.2)

| Element | AA Minimum | AAA Preferred |
|---------|-----------|---------------|
| Normal text (< 18px) | 4.5:1 | 7:1 |
| Large text (>= 18px or 14px bold) | 3:1 | 4.5:1 |
| UI components, icons | 3:1 | 4.5:1 |

## Spacing System

Use a **4px base unit** for consistency. Every spacing value is a multiple of 4.

| Token | Value | Common use |
|-------|-------|------------|
| `space-0.5` | 2px | Icon padding, tight inline gaps |
| `space-1` | 4px | Minimum gap, border offset |
| `space-2` | 8px | Inline element gaps, tight stacking |
| `space-3` | 12px | Small component padding |
| `space-4` | 16px | Standard component padding, list gaps |
| `space-5` | 20px | Medium section padding |
| `space-6` | 24px | Card padding, form field gaps |
| `space-8` | 32px | Section gaps |
| `space-10` | 40px | Large section gaps |
| `space-12` | 48px | Page section separators |
| `space-16` | 64px | Major section breaks |
| `space-20` | 80px | Hero section padding |
| `space-24` | 96px | Page-level vertical rhythm |

## Motion & Animation

Animation is communication, not decoration. Every animation must answer: "What information does this convey?"

### When to animate

- **Feedback** — User action acknowledged (button press, toggle, submit)
- **Orientation** — Where something came from or where it went (page transition, modal enter/exit)
- **Focus** — Drawing attention to what matters (notification appear, error shake)
- **Hierarchy** — Establishing relationships (accordion expand, tab switch)

### Duration ranges

| Category | Duration | Use case |
|----------|----------|----------|
| Micro | 100-150ms | Hover states, color changes, opacity |
| Small | 150-250ms | Button feedback, toggles, tooltips |
| Medium | 250-400ms | Modals, drawers, dropdowns, cards |
| Large | 400-700ms | Page transitions, complex reveals |

### Easing curves

| Curve | CSS | Use case |
|-------|-----|----------|
| Ease-out | `cubic-bezier(0.0, 0.0, 0.2, 1)` | Elements entering the screen |
| Ease-in | `cubic-bezier(0.4, 0.0, 1, 1)` | Elements leaving the screen |
| Ease-in-out | `cubic-bezier(0.4, 0.0, 0.2, 1)` | Elements moving position |
| Spring | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Playful, bouncy interactions |

### Reduced motion

Always respect `prefers-reduced-motion: reduce`. When active:

- Replace motion with instant state changes or simple opacity fades
- Keep essential feedback (focus indicators, error states) but remove decorative motion
- Never skip the interaction entirely, just reduce the movement

### Animation libraries

- **Framer Motion** — React-focused, declarative, layout animations, exit animations
- **GSAP** — Framework-agnostic, timeline-based, complex sequences
- **Lottie** — After Effects to web, great for illustrations and loading states
- **CSS animations/transitions** — For simple interactions, zero dependencies

## Accessibility (WCAG 2.2)

Accessibility is a design requirement, not a development afterthought.

### Four principles (POUR)

1. **Perceivable** — Information and UI components must be presentable in ways all users can perceive.
   - Text alternatives for non-text content
   - Captions for audio/video
   - Content adaptable to different presentations
   - Sufficient color contrast

2. **Operable** — UI components and navigation must be operable by all users.
   - All functionality available via keyboard
   - No keyboard traps
   - Sufficient time to read and interact
   - No content that causes seizures (no flashing > 3 times/second)

3. **Understandable** — Information and operation of UI must be understandable.
   - Readable and predictable content
   - Input assistance (labels, error identification, suggestions)
   - Consistent navigation and identification

4. **Robust** — Content must be robust enough for diverse user agents and assistive technologies.
   - Valid semantic HTML
   - Proper ARIA roles, states, and properties
   - Status messages communicated to assistive tech

### Design-specific requirements

| Requirement | Specification |
|-------------|--------------|
| Touch targets | Minimum 44x44px (WCAG 2.5.8) |
| Focus indicators | Visible, 2px+ outline, 3:1 contrast against adjacent colors |
| Color independence | Never use color as the only indicator. Add icons, text, or patterns. |
| Text scaling | Interface must work at 200% zoom without horizontal scrolling |
| Skip navigation | Provide a "skip to main content" link as first focusable element |
| Form labels | Every input must have a visible, associated label |
| Error identification | Errors described in text, not just color |
| Heading hierarchy | Sequential (h1 > h2 > h3), no skipped levels |

## Responsive Strategy

### Mobile-first breakpoints

| Name | Width | Target |
|------|-------|--------|
| Mobile | 0-639px | Phones (portrait) |
| Tablet | 640-1023px | Tablets, phones (landscape) |
| Desktop | 1024-1279px | Laptops, small monitors |
| Wide | 1280px+ | Large monitors, ultra-wide |

### Common responsive patterns

- **Stack to grid** — Single column on mobile, multi-column on desktop
- **Show/hide** — Non-essential elements hidden on small screens
- **Reflow** — Navigation collapses to hamburger, sidebar becomes bottom sheet
- **Priority+** — Table shows priority columns, hides low-priority ones
- **Container queries** — Component-level responsiveness independent of viewport

### Touch vs pointer considerations

- Touch targets: 44x44px minimum on touch, 32x32px acceptable on pointer
- Hover states: provide alternative for touch (long-press, tap to reveal)
- Swipe gestures: always provide a tap/click alternative

## Modern Design Trends

Trends to consider, not blindly follow:

- **Typography-centric** — Type as the primary design element. Bold hierarchy, expressive weight contrast, generous whitespace.
- **Dark mode as default** — For developer tools, dashboards, and productivity apps. Light mode as the alternative.
- **Glassmorphism** — Use sparingly. Frosted glass backgrounds work for overlays and cards when contrast is maintained.
- **Bento grid layouts** — Asymmetric card grids for dashboards and landing pages. Visual variety within a consistent grid.
- **3D and depth** — Subtle shadows, layered cards, perspective transforms. Avoid gratuitous 3D that hurts performance.
- **Micro-interactions everywhere** — Every interactive element responds to user input. Hover, press, focus, success, error.
- **AI-native interfaces** — Streaming text, thinking indicators, tool call displays, progressive disclosure of AI reasoning.

## Fintech/SaaS Patterns

When designing for data-heavy, trust-sensitive interfaces:

- **Data visualization** — Interactive charts, sparklines, progress indicators. Always include a text summary alongside visualizations.
- **Progressive disclosure** — Show summary first, details on demand. Avoid overwhelming users with all data at once.
- **Trust indicators** — Security badges, encryption mentions, audit trail visibility. Users need to feel safe.
- **Onboarding flows** — Minimal steps, clear progress, skip-friendly. Time to value is critical.
- **Empty states** — First-use guidance, helpful illustrations, clear CTAs. An empty state is a teaching moment.
- **Error states** — Specific, actionable, human-readable. "Something went wrong" is never acceptable.
- **Loading states** — Skeleton screens over spinners. Optimistic UI where safe. Never leave the user staring at a blank screen.
