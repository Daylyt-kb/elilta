# Elilta East Africa Dropshipping Storefront

Elilta is a premium direct-to-consumer import hub serving East Africa — zero customs hassle, secure Paystack checkout (Card, M-Pesa, Bank Transfer, Apple Pay), and express doorstep delivery across Kenya.

## Live Site
GitHub Pages: `https://daylyt-kb.github.io/elilta/`

## Architecture
- **Hosting**: GitHub Pages (free domain, `daylyt-kb.github.io/elilta`)
- **API**: Supabase Edge Functions (`/api/initialize`, `/api/webhook`, `/api/download`, `/api/products`)
- **Database**: Supabase PostgreSQL project `tfiwflcmecahjdqnavid` with strict Row-Level Security (RLS)
- **Payments**: Paystack live (KES) — settlement to M-Pesa `+254 769721573` (KEBRON ARAYA)

## Supabase Schema
See `supabase/schema.sql` — tables: `products`, `orders`, with RLS policies enabling public product browsing and guest checkout inserts.

## Edge Functions
| Function | Path | Purpose |
|---|---|---|
| `initialize` | `/api/initialize` | Paystack transaction init (LAW 5 channels, KES subunits) |
| `webhook` | `/api/webhook` | Paystack `charge.success` handler; marks orders paid |
| `download` | `/api/download` | Payment-verified download link (survives refresh/back-button) |
| `products` | `/api/products` | Public product catalog |

## Payment Law
Paystack live keys only. No Paystack single rail. Amounts in KES subunits (KES 8,900 = `890000`). All initializations include `channels: ['card', 'mobile_money', 'bank_transfer', 'apple_pay']`.