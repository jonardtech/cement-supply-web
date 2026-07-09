# Design System, Brand & Visual Identity
*(For Frontend (Next.js) and Android devs so they can build the UI component library.)*

## 1. Design Philosophy
* Core Concept: Professional Efficiency Meets Field-Ready Simplicity.
* Clarity Over Cleverness: Every screen has one primary purpose.
* Progressive Disclosure: Show only what is needed now.
* Forgiving by Design: Require confirmation for destructive actions.
* Field-First Mobile: Android app designed for one-handed use and bright sunlight.
* Trust Through Transparency: Every status change is visible and explained.
* Performance is UX: A 3-second load time is a failed design.

## 2. Brand Colors
### Primary Palette (JCIL Brand)
* primary-900 (#0A2540): Headers, primary buttons (dark)
* primary-700 (#0F3B66): Hover states, active nav
* primary-500 (#1A5490): Primary buttons, links
* primary-100 (#E8F0F9): Subtle backgrounds, badges
* primary-50 (#F5F8FC): Page backgrounds

### Semantic Colors
* success-500 (#10B981): Reconciled, Delivered, success states
* warning-500 (#F59E0B): Pending, caution states
* error-500 (#EF4444): Rejected, errors, destructive actions
* info-500 (#3B82F6): Informational states

### Cement Category Color Coding
* CEM I (Portland): Blue (#1A5490)
* CEM II (Composite): Teal (#0D9488)
* CEM IV (Pozzolanic): Amber (#D97706)
* Other: Gray (#6B7280)

## 3. Typography & Spacing
* Font Family: Inter (Web) / Roboto (Android fallback).
* Financial Figures: Always use monospace font for alignment. Format currency as UGX 32,000.
* Spacing Grid: Based on a 4px grid.
  * space-1 (4px): Tight spacing (icon to text)
  * space-2 (8px): Related elements
  * space-4 (16px): Card padding, standard gaps
  * space-8 (32px): Page margins

## 4. Core Components
### Buttons
* Primary: Solid primary-500, white text.
* Secondary: Outlined primary-500.
* Destructive: Solid error-500, white text.
* Sizes: sm (32px), md (40px), lg (48px for mobile).

### Form Inputs
* Text Input: 40px height, 8px radius, neutral-300 border.
* File Upload: Drag-and-drop zone with camera capture option on mobile.

### Tables & Cards
* Desktop Tables: Striped rows, sticky header, sortable columns.
* Mobile Tables: Transform to card view (each row becomes a card).
* Data Card: White background, elevation-1, 16px padding, 8px radius.

## 5. State Design
Every component must handle these states:
* Default: Standard styling.
* Hover/Focus: Slight elevation or 2px solid focus ring.
* Loading: Skeleton loader or spinner.
* Empty: Illustration plus message plus Call to Action.
* Error: Red styling plus actionable error message.
* Success: Green styling plus checkmark.

## 6. Micro-interactions & Animations
* Purposeful and fast (100ms to 300ms).
* Button click: Scale to 0.98 (100ms).
* Modal open: Fade in plus scale up (200ms).
* Success checkmark: Draw-in effect (400ms).
* Respect the "Reduce Motion" system setting on all devices.