# Frontend Development Guide (Next.js)
*(Guidelines for the React/Next.js frontend developers.)*

## 1. Rendering Architecture: Next.js (Hybrid SSR/CSR)
We are using **Next.js (App Router)**. This is critical for our Ugandan user base.
- **Server Components (RSC):** Use React Server Components by default for data fetching. This ensures the initial HTML is rendered on the server and sent to the client. **This prevents the "white screen of death" on slow 3G/4G mobile networks.**
- **Client Components:** Only use `'use client'` when you need interactivity (onClick, useState, useEffect), such as complex data tables, modals, or the payment proof uploader.
- **Data Fetching:** Use React Query (TanStack Query) for client-side state and mutations, or Next.js Server Actions if keeping data fetching strictly on the server.

## 2. UI/UX Strategy by Viewport
Since the Web App contains *everything*, we use responsive design to serve different users:

### A. JCIL Staff (Desktop Viewport)
- **Context:** Internal staff sitting at desks with large monitors.
- **UI Strategy:** Desktop-first for the Admin/Finance routes. 
- **Requirements:** High data density. Use complex, sortable data tables (e.g., `@tanstack/react-table`), multi-column grid layouts, persistent side-navigation, and keyboard shortcuts for rapid data entry.

### B. Clients & Wholesalers (Mobile & Desktop Viewports)
- **Context:** Site managers checking orders on the go, or procurement officers at their desks.
- **UI Strategy:** Mobile-first responsive design for the Client Portal routes.
- **Requirements:** Large touch targets, simplified navigation (hamburger menus on mobile), bottom-sheet modals for mobile, and highly optimized forms. 

## 3. Performance & Bandwidth Optimization (Crucial for Uganda)
Because mobile data is expensive and network speeds vary:
- **Images:** You MUST use the Next.js `<Image />` component. It automatically serves modern formats (WebP/AVIF) and lazy-loads images. Never use standard `<img>` tags for user-uploaded content.
- **Fonts:** Use `next/font` to self-host fonts (like Inter or Roboto). This prevents layout shift (CLS) and avoids external network requests to Google Fonts.
- **Bundle Size:** Keep client-side JavaScript bundles small. Rely on Server Components to keep heavy logic out of the client bundle.
- **Skeletons:** Use Skeleton loaders instead of spinning wheels. It makes the app feel faster on poor connections.

## 4. Form Handling & Validation
- Use `react-hook-form` combined with `zod` for schema validation.
- **Currency Formatting:** All monetary inputs must be formatted to UGX (Ugandan Shillings) with proper thousand separators (e.g., `UGX 1,500,000`). Use a library like `react-number-format`.
- **Optimistic UI:** When a client uploads a payment proof or submits an order, update the UI immediately to show success, then reconcile with the server in the background.