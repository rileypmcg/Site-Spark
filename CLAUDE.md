# MockUp-Template

This folder produces one-page website mockups for local service businesses ($300 build + $30/month hosting product).

**When the user describes a client/business, follow [MOCKUP-TEMPLATE.md](MOCKUP-TEMPLATE.md) exactly** — it defines the intake format, design rules, funnel structure, and quality checklist. Output a single self-contained `{business-slug}-mockup.html` in this folder, then open it in the browser preview for review.

Before designing a new mockup's palette, typography, and style, use the **ui-ux-pro-max** skill (in `.claude/skills/`) — search its palette/font-pairing/style database for options that fit the client's industry, then apply MOCKUP-TEMPLATE.md's rules (2 brand colors + 1 CTA accent, industry-grounded signature element) on top.

## Riley's own portfolio site

[index.html](index.html) is **Site Spark**, Riley's client-facing agency site (black/white exaggerated minimalism, Space Grotesk + Archivo, blue `#2563EB` accent — keep this design language distinct from client mockups). After building a new client mockup, wire it into the portfolio:

1. Add a viewer page `portfolio/{slug}.html` (copy an existing one — 54px back bar + full-height iframe pointing at the mockup file).
2. Generate a static thumbnail (live iframes in cards get too heavy as the grid grows):
   `& "C:\Program Files\Google\Chrome\Application\chrome.exe" --headless=new --disable-gpu --hide-scrollbars --window-size=1280,900 --virtual-time-budget=9000 --user-data-dir="$env:TEMP\chrome-shot-profile" --screenshot="<abs path>\portfolio\thumbs\{slug}.png" "http://localhost:8735/{mockup file}"`
   (absolute output path + throwaway `--user-data-dir` are required or Chrome fails with access-denied)
3. Add a card in index.html's `#work` grid before the "Your business here" card: `<img src="portfolio/thumbs/{slug}.png">` in `.thumb`, name, industry · city, badge `Concept` (or `badge--live` for paying clients).

Preview via the `site` launch config (`python -m http.server 8735`) — file:// tabs are unreliable in the Browser pane.
