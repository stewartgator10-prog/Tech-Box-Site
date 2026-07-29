-- ============================================================================
--  Seed: Thurmont, MD prospects (no owned website)
--  Migration 2 of 2. Run AFTER supabase-prospects-schema.sql
--
--  `verified = true` means the website absence was confirmed by hand.
--  Everything else came from a blank website field in the Town of Thurmont
--  Main Street directory and still needs a 30-second check.
--
--  Safe to re-run: rows already present are skipped, and nothing you've
--  changed in the CRM (status, notes) gets overwritten.
-- ============================================================================

insert into public.prospects
  (business_name, address, category, owner_name, phone, presence_type, verified,
   review_count, rating, findings, pitch,
   gap_score, ticket_score, pain_score, reach_score, demand_score)
values

-- ---------- VERIFIED ----------

('G & S Electric', '16 Miller Alley', 'Trades', 'Gus', '301-271-2224', 'none', true, 5, 3.4,
 'Electrical contractor since 2001, roughly 20 employees, third-party revenue estimate around $500K. Owns nothing online. Manta listing unclaimed; eHardhat auto-generated a page that still shows the raw %COMPANY placeholder in the body text. Reviews split hard: 20-year loyal customers alongside "promise to show up and no show every time" and "called many times, never called back."',
 'Not a website pitch. Their reviews are a public record of blown callbacks — lead intake and scheduling is the leak. Open with the two named reviews and offer a request form plus a follow-up queue so no call dies on a notepad.',
 30, 25, 20, 15, 2),

('5 Speed Auto Repair', '7702 Roddy Creek Rd', 'Automotive', 'Emmanuel (Manuel) & Eddie', '301-524-9257', 'none', true, 20, 5.0,
 'Perfect 5.0 across 20 reviews. Reviewers single out free diagnostics, walking customers through the work, and finishing ahead of schedule. Google Business Profile is the entire footprint — no site, no booking, no way to find them except by name.',
 'They have a flawless reputation nobody outside Thurmont can find. A one-page site plus a booking request form turns 20 great reviews into search traffic against Gateway and Tracy''s, who both outrank them.',
 30, 25, 5, 15, 4),

('FPC Auto & Truck Repair', '6830 Putman Rd, Bldg F', 'Automotive', 'Scott & Annie', '301-898-9870', 'none', true, 17, 4.8,
 'Family-run auto and light truck shop, husband-and-wife operation. Closed Fridays through Sundays. Reviews repeatedly praise Annie''s communication and Scott''s explanations. No site, no online presence beyond the Google listing.',
 'They close three days a week, so every missed call is a lost job with no way to catch it. Pitch an after-hours quote form that lands in Annie''s inbox for Monday morning.',
 30, 25, 5, 15, 2),

('CJS Body and Paint', '144 N Carroll St', 'Automotive', 'Colin', null, 'none', true, 2, 5.0,
 'Body and paint work, owner-operated. Two reviews, both glowing on colour matching and schedule flexibility. No phone number published on the Google listing at all — the only way to reach him appears to be word of mouth.',
 'He is functionally unreachable to anyone who does not already know him. Cheapest possible win: a single page with a phone number, hours, and a photo form for damage estimates.',
 30, 25, 12, 5, 2),

('Windsor Customs', '13906 Jimtown Rd', 'Automotive', 'Chris Windsor', null, 'none', true, 2, 5.0,
 'Performance and race-oriented mechanic. Review describes a loyal racer clientele who trust his work specifically. No phone number on the listing, no site, no social presence found.',
 'Racing is a referral world that lives on forums and Instagram. Pitch a build-gallery page — his work is the product, and right now none of it is visible.',
 30, 25, 12, 5, 2),

('Intowne Barber', '5 W Main St', 'Beauty', 'Jeremy Hahn', '240-288-8181', 'none', true, 81, 4.9,
 'One-chair traditional barbershop, owner-operated by a former Marine. 4.9 stars. No site and no listed phone in the town directory. Fresha and Birdeye have scraped him without his involvement; Yellow Pages still shows "Add Website / Claim This Business." Reviews warn that waits get long because it is one barber serving everyone properly.',
 'Reviewers are literally telling other customers to come back another day. A simple queue or appointment page fixes the one complaint he has, and gets his name off the scraper sites.',
 30, 12, 12, 15, 4),

('Here''s Clyde''s Family Hair Care', '5 S Center St', 'Beauty', 'Krista Royer & Christina', '301-271-4479', 'social_only', true, 22, 5.0,
 'Small family salon, "Voted Frederick''s Best Day Spa 2025." Facebook page plus Krista''s personal Instagram (@kristaroyer_hair, ~500 followers) where the booking instruction is "DM or text." Their unclaimed Yelp page shows 3.3 stars from three reviews, the newest from 2014, while Google shows 5.0 from 22.',
 'A dead Yelp page is publishing 3.3 stars against their real 5.0 and they cannot edit it. Lead with that, then offer online booking so Krista stops running her calendar out of Instagram DMs.',
 25, 12, 12, 15, 4),

('Tracie''s House of Hair', '7 Water St', 'Beauty', 'Tracie Stull-Miller', '301-556-6119', 'abandoned_site', true, 25, 4.8,
 'Opened 2020, second-generation barber — her father ran a shop out of his basement and his photo hangs in the salon. Facebook page has ~510 likes. Critically, there is a Google Sites page at sites.google.com/view/tracieshouseofhair that reads "Site Under Construction — Please Check Back Soon." She started and gave up.',
 'She has already decided she needs a site and failed to finish one. No convincing required — just show her a finished version of the thing she abandoned. Warmest conversation on the list even though it is not the highest-value job.',
 20, 12, 16, 15, 4),

-- ---------- TRADES & CONTRACTORS (directory blank — verify) ----------

('Delphy Construction, Inc.', '12 S Altamont St', 'Trades', null, '301-271-4850', 'none', false, null, null,
 'Listed in the town business directory with no website field. Established local construction outfit with a downtown Thurmont address.',
 'Contractors lose bids to whoever looks legitimate first. Pitch a project-gallery site plus a quote request form that captures scope and photos up front.',
 30, 25, 5, 10, 2),

('Seiss Custom Woodworking and Tile LLC', '7540 Franklinville Rd', 'Trades', null, '301-401-4291', 'none', false, null, null,
 'Custom woodworking and tile. Directory listing carries no website. Highly visual trade with nothing visual published.',
 'Custom woodwork sells on photographs and this business has none online. A portfolio page is the entire product pitch.',
 30, 25, 5, 10, 2),

('BulletpROOF Exteriors LLC', '18 Frederick Rd', 'Trades', null, '301-302-7229', 'none', false, null, null,
 'Roofing and exteriors contractor on the main commercial strip. No website in the directory.',
 'Roofing is storm-driven and urgent — homeowners search on the day the leak starts. Without a site they are invisible in exactly the moment that matters. Pitch a fast-loading page plus an emergency request form.',
 30, 25, 5, 10, 2),

('Schildt Construction', '11 W Main St', 'Trades', null, null, 'none', false, null, null,
 'Directory entry has neither a phone number nor a website. Downtown Main Street address.',
 'They are missing from the directory''s own contact fields, which suggests nobody is minding the online footprint at all. Start with the free-listing cleanup, upsell the site.',
 30, 25, 5, 5, 2),

('C. Richard Dewees', '211 Eyler Rd', 'Trades', 'C. Richard Dewees', '301-271-7303', 'none', false, null, null,
 'Listed under Services in the town directory with no website and no category detail. Trade type needs confirming on the call.',
 'Unknown scope — treat the first call as discovery rather than a pitch.',
 30, 18, 5, 15, 2),

('Heart and Hands Decorators Workroom', 'PO Box 32', 'Trades', null, '301-271-1028', 'none', false, null, null,
 'Custom decorating workroom — window treatments and soft furnishings. PO Box address, no storefront, no website.',
 'A workroom with no address and no site can only be found by referral. Portfolio page plus a consultation request form.',
 30, 18, 5, 10, 2),

('Main Street Upholstery', '311 W Main St', 'Automotive', null, '301-271-2298', 'none', false, null, null,
 'Listed under Automotive in the town directory, no website. Upholstery work spans auto, marine and furniture.',
 'Before-and-after photos are the whole sale in upholstery. Pitch a gallery plus a photo-upload quote form.',
 30, 18, 5, 10, 2),

('Direct-To-You Gas', '304 N Church St', 'Services', null, '301-271-4681', 'none', false, null, null,
 'Propane and fuel delivery. No website listed.',
 'Delivery businesses live on recurring accounts. Pitch a customer request form and a simple delivery-scheduling page.',
 30, 18, 5, 10, 2),

('Portner Trucking', '7006 Blue Mountain Rd', 'Services', null, '301-271-5499', 'none', false, null, null,
 'Local trucking and hauling. No website in the directory.',
 'B2B hauling gets vetted online before anyone calls. A credibility page with equipment, capacity and insurance details is the ask.',
 30, 18, 5, 10, 2),

('Keilholtz Trucking', '300 Eyler Rd', 'Services', null, '301-271-2358', 'none', false, null, null,
 'Local trucking operation, no website listed.',
 'Same as Portner — a one-page credibility site with equipment list and service radius.',
 30, 18, 5, 10, 2),

-- ---------- FOOD & DRINK ----------

('Furnace Grill & Crab House', '12841 Catoctin Furnace Rd', 'Food & Drink', null, '240-288-8942', 'none', false, 636, 4.2,
 '636 reviews and no website. Seasonal crab house near Cunningham Falls State Park, so a large share of traffic is out-of-town visitors searching before they drive. Reviews mention menu and pricing confusion, especially around all-you-can-eat crabs.',
 'Highest review volume of any no-site business in town. Tourists check a menu before committing to a drive out to Catoctin Furnace Road — right now there is nothing to check. Pitch a menu and seasonal-pricing page.',
 30, 12, 12, 10, 10),

('Fratelli''s NY Pizza', '140 Frederick Rd', 'Food & Drink', null, '301-271-0272', 'aggregator_only', false, 480, 4.4,
 'Husband-and-wife pizza and sub shop, 480 reviews. The town directory does not link a site — it links their Restaurantji aggregator page. Delivery is offered but ordering is phone-only. One detailed review complains at length about phone manner during a rush.',
 'Every order goes through a phone the owners answer mid-rush, and it is already costing them reviews. Online ordering removes the bottleneck and the aggregator page stops being their front door.',
 30, 12, 12, 10, 7),

('Simply Asia', '120 Frederick Rd, Ste B & C', 'Food & Drink', null, '301-271-2858', 'none', false, 369, 4.3,
 '369 reviews, no website. Owner works the floor and is named warmly in several reviews. The negative reviews cluster on order accuracy and getting the wrong dishes.',
 'Order-accuracy complaints are what phone ordering produces. Pitch online ordering — the customer types their own order and the mistakes drop.',
 30, 12, 12, 10, 7),

('Celebrations Catering and Event Rentals', '425 N Church St', 'Food & Drink', null, '301-271-2220', 'none', false, null, null,
 'Catering and event rental company on the north end of town. No website listed.',
 'Event work is planned months ahead by people comparing vendors online. With no site they are not in the comparison at all. Pitch a package and gallery page with a date-check enquiry form.',
 30, 18, 5, 10, 2),

('New Wing Hing', '211 Tippin Dr', 'Food & Drink', null, '301-271-3688', 'none', false, null, null,
 'Chinese restaurant in the Tippin Drive plaza. No website. Referenced positively in a shopping-centre review.',
 'Menu page plus online ordering — the standard independent-takeaway gap.',
 30, 12, 5, 10, 2),

('Thurmont Liquors', '215 Tippin Dr', 'Retail', null, '301-271-2949', 'none', false, null, null,
 'Package store in the Tippin Drive plaza, no website.',
 'Low priority on its own. Worth bundling if another Tippin Drive tenant signs.',
 30, 12, 5, 10, 2),

('Town & Country Liquors', '34 Water St', 'Retail', null, '301-271-2990', 'none', false, null, null,
 'Downtown package store on Water Street, no website.',
 'Low priority. Bundle candidate with other Water Street businesses.',
 30, 12, 5, 10, 2),

('Gateway Liquors', '14802 N Franklinville Rd', 'Retail', null, '301-271-7078', 'none', false, null, null,
 'Shares the Franklinville Road complex with Gateway Candyland and The Farmhouse Exchange, both of which do have sites.',
 'Their own neighbours already bought websites. Use that as the opener — same complex, same customers, no page.',
 30, 12, 5, 10, 2),

('Mountain View Convenience Store & Beer & Wine', '140 Frederick Rd', 'Retail', null, '301-271-3333', 'none', false, null, null,
 'Convenience store sharing a phone number with the Sunoco and U-Haul rental operations at the same address.',
 'One phone number covers three businesses, which means calls are being fielded for the wrong one constantly. Pitch a single page that splits the three services.',
 30, 12, 5, 10, 2),

-- ---------- BEAUTY ----------

('Thurmont Barber & Styling', '1 E Main St', 'Beauty', 'Melyssa & Rachel', '301-271-0200', 'none', false, 55, 4.7,
 'Family barber and styling shop on the corner of Main. Reviews praise patience with young children. One negative review describes being promised a callback to rebook a corrected perm and never hearing back.',
 'A named review says they lost a customer to a missed callback. Booking and follow-up is the pitch, not the website.',
 30, 12, 12, 15, 4),

('M&T Shear Magic Inc', '131 E Main St', 'Beauty', 'Tammy, Rachel & Missy', '301-271-2113', 'none', false, 26, 4.9,
 '4.9 stars. Notably, their Google listing publishes no business hours at all — the hours field is empty. Long-tenured stylists with clients of 20-plus years.',
 'Customers cannot find out when they are open without calling. That is the cheapest, most concrete problem on this whole list — fix the listing free, then sell the booking page.',
 30, 12, 12, 15, 4),

('Jen''s Cutting Edge Salon', '12917 Catoctin Furnace Rd B', 'Beauty', 'Jen', '301-271-0011', 'social_only', false, 24, 5.0,
 'Perfect 5.0 across 24 reviews. Clients drive from Frederick specifically for her. Shares a building with Mike''s Auto Body, which does have a website.',
 'Clients already travel to her, which means demand exceeds visibility. Pitch online booking so she stops losing the drive-in customers to phone tag.',
 25, 12, 5, 15, 4),

('Beautiful You Salon & Spa', '9 Water St', 'Beauty', null, '301-271-9367', 'none', false, null, null,
 'Downtown salon and spa two doors from Tracie''s House of Hair. Nominated in Frederick News-Post "Best of the Best" categories. No website.',
 'Spa services sell on a service-and-price menu. Pitch that page plus booking.',
 30, 12, 5, 10, 2),

('Number One Nails-Spa-Tanning', '213 Tippin Dr', 'Beauty', null, '301-271-1152', 'none', false, null, null,
 'Nail salon, spa and tanning in the Tippin Drive plaza. No website.',
 'Nail salons live and die on appointment flow. Booking page is the whole pitch.',
 30, 12, 5, 10, 2),

-- ---------- RETAIL ----------

('Inked Apparel + Signs', '1 N Carroll St', 'Retail', null, '240-357-6441', 'none', false, null, null,
 'Custom apparel and signage shop just off Main Street. No website.',
 'Their entire business is custom quotes — artwork, quantities, turnaround — and it is all happening over the phone. A quote form with file upload is a direct revenue tool, not a brochure.',
 30, 18, 12, 10, 2),

('Gateway Flowers', '11 E Main St', 'Retail', null, '301-271-4178', 'none', false, null, null,
 'Downtown florist on East Main. No website listed.',
 'Florists without their own ordering page lose most out-of-town orders to national wire services that take a large cut. Direct online ordering is a margin argument, not a marketing one.',
 30, 12, 12, 10, 2),

('Thurmont Smoke Shop', '224 N Church St', 'Retail', null, '301-416-9089', 'none', false, 265, 4.9,
 '4.9 stars over 265 reviews. Note: the Google reviews on this listing describe nail salon services, so the listing appears to be crossed with a neighbouring tenant in Thurmont Plaza — worth confirming before contact.',
 'Their Google listing is carrying another business''s reviews. Untangling that is a free favour that opens the conversation.',
 30, 12, 12, 10, 7),

('Mountain Memories Gifts', '4 N Church St', 'Retail', null, '301-271-9100', 'none', false, null, null,
 'Downtown gift shop. No website. Distinct from Mountain Memories the event venue, which does have one.',
 'Colorfest brings roughly 125,000 visitors to Thurmont each autumn. A gift shop with no online presence captures none of that before or after the weekend.',
 30, 12, 5, 10, 2),

-- ---------- HEALTH & PROFESSIONAL ----------

('Catoctin Medical Center – Dr. Aziz', '100 S Center St', 'Health', 'Dr. Aziz', '301-271-4333', 'none', false, null, null,
 'Primary care practice downtown. No website listed in the town directory.',
 'Patients choose a new doctor by looking them up first. No site means no new-patient pipeline. Pitch a practice page with credentials, insurance accepted, and a new-patient enquiry form.',
 30, 18, 5, 15, 2),

('Thurmont Smiles', '100 S Center St', 'Health', null, '301-304-6177', 'none', false, null, null,
 'Dental practice sharing an address with Catoctin Medical Center. No website.',
 'Dentistry is one of the most search-driven local categories and they have nothing. Pitch a practice site with appointment request.',
 30, 18, 5, 10, 2),

('Center of Life Chiropractic', '56 Water St', 'Health', null, '301-271-2711', 'none', false, null, null,
 'Chiropractic practice on Water Street. Related to the Pilates and holistic health studio down the block.',
 'Two related practices, no shared web presence. Pitch one site covering both — better economics for them, bigger job for you.',
 30, 18, 5, 10, 2),

('Center of Life Pilates Studio & Holistic Health Center', '36 Water St', 'Health', null, '301-748-2284', 'none', false, null, null,
 'Pilates and holistic health studio. Won a Frederick News-Post "Best Holistic Health Practice" nomination. No website.',
 'Class schedules and packages are the whole ask here. Pitch a schedule page with class booking, bundled with the chiropractic site.',
 30, 12, 5, 10, 2),

('Well Fit', '202 E Main St', 'Health', null, '301-748-0259', 'none', false, null, null,
 'Fitness business on East Main sharing a building with Barnstone Studio and Commodore Recording Studio. No website.',
 'Fitness sells on schedule and membership pricing. Pitch a schedule and sign-up page.',
 30, 12, 5, 10, 2),

('Walking Together', '5A E Main St', 'Health', null, '240-840-6811', 'none', false, null, null,
 'Listed under Health and Wellness with no website and no detail. Service type needs confirming.',
 'Unknown scope — discovery call first.',
 30, 12, 5, 10, 2),

('Village Hearing Aid Center', '12 Water St', 'Health', null, '301-271-9222', 'none', false, null, null,
 'Hearing aid retailer and audiology services downtown. No website.',
 'An older customer base still researches online before visiting, usually via adult children. Pitch a plain, large-type page with products, brands and a consultation request.',
 30, 18, 5, 10, 2),

-- ---------- SERVICES & PROPERTY ----------

('Rambler', '426 N Church St', 'Lodging', null, '301-271-2424', 'none', false, null, null,
 'Independent motel on North Church Street, one of only three lodging options in the directory. The other two — Super 8 and Ole Mink Farm — both have booking sites.',
 'Every single reservation has to come through a phone call, while both competitors take bookings around the clock. This is the clearest revenue-loss case in the directory.',
 30, 18, 12, 10, 2),

('ThorpeWood', '12805A Mink Farm Rd', 'Event Venue', null, '301-271-2823', 'none', false, null, null,
 'Event and retreat venue on Mink Farm Road, sharing a phone with Mountain Memories which does have a site.',
 'Venue bookings start with photos and availability. If Mountain Memories has a site and ThorpeWood does not, the same operator already believes in this — just unevenly.',
 30, 18, 5, 10, 2),

('1st Look Property Management Services', '120 E Main St', 'Real Estate', null, '240-674-9017', 'none', false, null, null,
 'Property management on East Main. Shares a phone number with realtor Sandi Reed Burns.',
 'Property management needs two front doors: owners looking to hand over a property, and tenants reporting maintenance. Pitch both intake forms.',
 30, 18, 5, 10, 2),

('Sandi Reed Burns – Keller Williams Realty Centre', '5280 Corporate Dr, Frederick', 'Real Estate', 'Sandi Reed Burns', '240-674-9017', 'none', false, null, null,
 'Realtor listed in the Thurmont directory with a Frederick brokerage address and no personal site — only whatever Keller Williams provides.',
 'Agents on brokerage-issued pages compete against every other agent in the same office. A personal site with Thurmont-specific listings and local knowledge is how she differentiates.',
 30, 18, 5, 15, 2),

('Orchard Cleaners', '209 Tippin Dr', 'Services', null, '301-271-0290', 'none', false, null, null,
 'Dry cleaner in the Tippin Drive plaza. No website.',
 'Low ticket, but hours and turnaround times are the two things customers call to ask. A single page removes most of those calls.',
 30, 12, 5, 10, 2),

('Barnstone Studio', '202 E Main St', 'Arts', null, '301-788-6241', 'none', false, null, null,
 'Arts studio on East Main. Directory lists it with no website while three of the four other Arts entries have one.',
 'Every other arts business in the directory has a site. That comparison is the opener.',
 30, 12, 5, 10, 2)

on conflict on constraint prospects_unique_business do nothing;
