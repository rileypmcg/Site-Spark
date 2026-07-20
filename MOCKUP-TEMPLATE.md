# Local Business Mockup Template — AI Build Spec

You are building a **one-page website mockup** for a local service business. The output is a single, self-contained HTML file the business owner sees as a near-finished site — polished enough to close a $300 build + $30/month hosting deal.

## How to use this spec

1. Read the **Client Brief** the user gives you (format below). If fields are missing, invent plausible placeholder content that fits the industry — never leave blanks or lorem ipsum. Mark invented facts with an HTML comment `<!-- PLACEHOLDER: confirm with client -->`.
2. Design the **brand identity** (palette, fonts, signature element) per the rules below — grounded in how this specific industry actually works.
3. Build the page following the **Funnel Structure**.
4. Output one file: `{business-slug}-mockup.html`.

---

## Client Brief (input format)

The user will give you some or all of:

```
Business name:
Industry / what they do:
Location / service area:
Phone / email (if known):
Services offered:
Anything distinctive (years in business, guarantee, story, awards):
Vibe or colors they like (optional):
Photos available? (optional)
```

A one-line brief like "a barbershop called Fade District in Mesa AZ" is enough — fill in the rest yourself.

---

## Design rules (non-negotiable)

### Brand identity per client
- **2 brand colors + 1 high-contrast CTA accent.** The accent is used ONLY for CTAs and key highlights. Derive the palette from the industry's real materials and mood (e.g., landscaping = deep greens + earth orange; coffee = espresso dark + gold; cleaning = linen white + teal + citrus). Never reuse a palette from a previous mockup.
- **Fonts:** one display font + one body font from Google Fonts CDN, chosen to match the industry's personality (rugged trades = condensed/slab; upscale = serif display like Fraunces; clinical/clean = geometric sans). Fallback stack always included.
- **Signature element:** every mockup gets ONE interactive or visual element in/near the hero that proves you understand how this business works — not decoration. Examples so far: pour-over brew timer (coffee shop), live cleaning checklist (cleaning service). Invent an equivalent for the new industry (e.g., barbershop = live "next available chair" board; HVAC = seasonal tune-up countdown; auto detail = before/after slider).
- Icons: emoji are acceptable; inline SVG is better if quick.

### Tech constraints
- **Plain HTML + CSS in a single file.** No build tools, no frameworks, no external JS libraries. Small amounts of vanilla JS allowed for the signature element and smooth-scroll/mobile nav.
- Google Fonts via CDN `<link>` is the only external dependency. Images: use CSS gradients/patterns or emoji placeholders unless the client provided photos.
- CSS custom properties in `:root` for the palette so colors can be retuned in one place.
- **Mobile-first.** Grids use `auto-fit` / `minmax()`. Exactly one breakpoint, at 768–800px.
- Semantic HTML, real `<title>` + meta description written for local SEO ("{Service} in {City} | {Business Name}"), LocalBusiness JSON-LD schema block with the client's NAP.
- Clickable `tel:` and `mailto:` links everywhere phone/email appears. Sticky or prominent call CTA on mobile.

---

## Funnel structure (build sections in this order)

1. **Hero** — clear promise headline (outcome, not service name), subline with location, primary CTA button ("Get a Free Quote" / "Book Now"), plus the signature element in or beside it.
2. **Stats band** — 3–4 credibility numbers (years, jobs done, rating, response time). Invent reasonable ones if not provided (mark as placeholder).
3. **Services / Menu grid** — cards with icon, name, 1–2 line benefit-focused description. `auto-fit` grid.
4. **Process or signature-element expansion** — industry-specific proof of method (how a job goes, step 1-2-3, what's included).
5. **Why choose us / Guarantee** — 3–4 differentiators; include a bolded guarantee statement if the brief has one.
6. **Gallery or origin story** — photo grid placeholders (CSS gradient tiles with captions) OR a short founder story, whichever fits the industry.
7. **Testimonials** — 3 quotes with first name + neighborhood/city. Invent plausible ones (mark as placeholder).
8. **About** — short, human, local. Name-drop the service area towns.
9. **CTA banner** — full-width accent-colored strip repeating the main CTA.
10. **Contact** — phone, email, hours, service area list, simple contact form (non-functional in mockup, note it in a comment).
11. **Footer** — NAP, quick links, "Website by [Riley]" credit line optional.

---

## Quality bar / checklist before finishing

- [ ] Palette passes the squint test: 2 brand colors, accent only on CTAs.
- [ ] Signature element works (test any JS mentally; keep it dependency-free).
- [ ] Reads correctly at 375px wide and at desktop; one breakpoint only.
- [ ] No lorem ipsum, no empty sections, no broken layout at any width.
- [ ] All invented facts flagged with `<!-- PLACEHOLDER -->` comments.
- [ ] Headline sells an outcome ("A lawn your neighbors notice"), not a category ("Landscaping Services").
- [ ] File is fully self-contained except Google Fonts.

## Mockup → Production (when a client signs)

The mockup is the sales artifact; the live site adds a launch layer. Based on the shipped CTF Maintenance site (ctfmaintenance.com), a production build includes everything in the mockup plus:

- **Real content:** actual NAP, owner name, service-area city names, real photos as optimized `.webp` in a `photos/` folder, `favicon.svg`.
- **Head/SEO:** canonical URL, `robots` meta, Open Graph + Twitter Card tags with an `og-image.jpg`, `preconnect` hints for Google Fonts.
- **Root files:** `robots.txt`, `sitemap.xml`, `llms.txt`, `.well-known/security.txt`.
- **Rich JSON-LD:** industry-specific business type (e.g. `LandscapingBusiness`), plus `PostalAddress`, `GeoCoordinates`, `OpeningHoursSpecification`, `AggregateRating`, `OfferCatalog` of services, owner `Person`, and `WebSite`.
- **Extra trust sections that convert:** Meet the Owner (photo + name), results gallery with real photos, and a hard-hitting CTA banner (e.g. "Don't Be a Victim of High Prices").
- Design system in `:root` custom properties: full color scale (not just 3 hexes), radius and shadow tokens.

## Reference mockups (existing, for tone — do NOT copy palettes)

| Client | Industry | Palette | Fonts | Signature element |
|---|---|---|---|---|
| CTF Maintenance (live) | Landscaping / junk removal | Emerald scale `#064E3B`–`#10B981` + amber `#F59E0B` | Inter (all weights) | "One Call. Every Job. Done Right." band + Meet the Owner |
| EmberCup | Coffee shop | `#1F1610` + `#C89B3C` / `#A13D2B` | Fraunces + Inter | Pour-over brew timer |
| ClearLine | Cleaning | `#FAF8F4` + `#0F6B63` / `#E8B93B` | Barlow Condensed + Barlow | Live checklist in hero |
| Homebird Coffee House | Coffee shop / café | Cream `#FFF4E3` + terracotta `#D9572F` / marigold `#F4A72C` + teal `#12766C` CTA, pink `#F27A9B` pops | Baloo 2 + Nunito | Regulars Club punch card (tap-to-stamp) |
