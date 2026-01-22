# S-Tier SaaS Dashboard Design Principles

Design checklist inspired by Stripe, Airbnb, and Linear.

---

## I. Core Design Philosophy

- [ ] **Users First**: Prioritize user needs, workflows, and ease of use
- [ ] **Meticulous Craft**: Precision, polish, and high quality in every element
- [ ] **Speed & Performance**: Fast load times and snappy interactions
- [ ] **Simplicity & Clarity**: Clean, uncluttered interface with unambiguous labels
- [ ] **Focus & Efficiency**: Help users achieve goals quickly with minimal friction
- [ ] **Consistency**: Uniform design language across the entire dashboard
- [ ] **Accessibility (WCAG AA+)**: Color contrast, keyboard navigation, screen reader support
- [ ] **Opinionated Design**: Clear, efficient defaults to reduce decision fatigue

---

## II. Design System Foundation

### Color Palette

- [ ] **Primary Brand Color**: Used strategically
- [ ] **Neutrals**: 5-7 step gray scale for text, backgrounds, borders
- [ ] **Semantic Colors**:
  - Success (green)
  - Error/Destructive (red)
  - Warning (yellow/amber)
  - Informational (blue)
- [ ] **Dark Mode Palette**: Corresponding accessible dark mode
- [ ] **Accessibility Check**: All combinations meet WCAG AA contrast

### Typography

- [ ] **Primary Font**: Clean, legible sans-serif (Inter, Manrope, system-ui)
- [ ] **Modular Scale**: H1, H2, H3, H4, Body Large, Body, Body Small
- [ ] **Font Weights**: Regular, Medium, SemiBold, Bold
- [ ] **Line Height**: 1.5-1.7 for body text

### Spacing

- [ ] **Base Unit**: 8px
- [ ] **Spacing Scale**: 4px, 8px, 12px, 16px, 24px, 32px

### Border Radii

- [ ] **Small**: 4-6px (inputs, buttons)
- [ ] **Medium**: 8-12px (cards, modals)

### Core Components

- [ ] Buttons (primary, secondary, tertiary, destructive)
- [ ] Input Fields (text, textarea, select, date picker)
- [ ] Checkboxes & Radio Buttons
- [ ] Toggles/Switches
- [ ] Cards
- [ ] Tables (sortable, filterable)
- [ ] Modals/Dialogs
- [ ] Navigation (Sidebar, Tabs)
- [ ] Badges/Tags
- [ ] Tooltips
- [ ] Progress Indicators
- [ ] Icons (single, modern SVG set)
- [ ] Avatars

---

## III. Layout & Visual Hierarchy

- [ ] **Responsive Grid**: 12-column system
- [ ] **Strategic White Space**: Ample negative space for clarity
- [ ] **Clear Visual Hierarchy**: Typography, spacing, positioning guide the eye
- [ ] **Consistent Alignment**: Elements align predictably
- [ ] **Main Layout**:
  - Persistent left sidebar for navigation
  - Content area for module interfaces
  - Optional top bar for search/profile/notifications
- [ ] **Mobile-First**: Graceful adaptation to smaller screens

---

## IV. Interaction Design & Animations

- [ ] **Purposeful Micro-interactions**: Immediate, clear feedback
- [ ] **Animation Timing**: 150-300ms with ease-in-out
- [ ] **Loading States**: Skeleton screens for page loads, spinners for actions
- [ ] **Smooth Transitions**: State changes, modal appearances
- [ ] **Avoid Distraction**: Animations enhance, not overwhelm
- [ ] **Keyboard Navigation**: All interactive elements accessible

---

## V. Module-Specific Design

### Data Tables

- [ ] Smart alignment: Left-align text, right-align numbers
- [ ] Clear, bold headers
- [ ] Optional zebra striping for dense tables
- [ ] Adequate row height and spacing
- [ ] Column sorting with indicators
- [ ] Intuitive filtering (dropdowns, text inputs)
- [ ] Global search
- [ ] Pagination or virtual scroll
- [ ] Sticky headers for long lists
- [ ] Expandable rows for details
- [ ] Inline editing capability
- [ ] Bulk actions with checkboxes
- [ ] Action icons per row (Edit, Delete, View)

### Configuration Panels

- [ ] Clear, unambiguous labels
- [ ] Concise helper text or tooltips
- [ ] Logical grouping into sections/tabs
- [ ] Progressive disclosure (Advanced Settings toggle)
- [ ] Appropriate input types for each setting
- [ ] Immediate save confirmation (toast notifications)
- [ ] Clear error messages
- [ ] Sensible defaults
- [ ] Reset to Defaults option

### Forms

- [ ] Associated labels for all inputs
- [ ] Placeholder text for hints
- [ ] Inline validation with clear error messages
- [ ] Disabled state styling
- [ ] Focus states visible
- [ ] Submit button states (default, loading, success, error)

---

## VI. CSS & Styling Architecture

- [ ] **Utility-First (Recommended)**: Tailwind CSS or similar
- [ ] **Alternative**: BEM with Sass variables
- [ ] **Design Tokens**: Colors, fonts, spacing in config
- [ ] **Maintainability**: Well-organized, readable code
- [ ] **Performance**: Optimized CSS delivery, no bloat

---

## VII. Best Practices

- [ ] **Iterative Design**: Continuously test and iterate
- [ ] **Clear Information Architecture**: Logical content organization
- [ ] **Fully Responsive**: Desktop, tablet, mobile
- [ ] **Documentation**: Maintain design system docs
- [ ] **Consistency Review**: Regular audits for design drift

---

## Quick Visual Check (7-Step)

1. [ ] Spacing consistent throughout
2. [ ] Typography hierarchy clear
3. [ ] Colors used consistently
4. [ ] Interactive states work (hover, focus, active)
5. [ ] Keyboard navigation functional
6. [ ] No horizontal overflow
7. [ ] Console errors clear
