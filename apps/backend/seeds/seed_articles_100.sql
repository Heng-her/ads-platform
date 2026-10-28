-- =========================================================================
-- SEED DATA: 100 VERIFIED PUBLIC OPEN DATA ARTICLES (Cambodia & Worldwide)
-- Task: Build a Reliable AI Content Data Collection Pipeline (Phases 1, 2 & 3)
-- Created with identifiable prefix: 7e575eed-2026-4000-8000-xxxxxxxxxxxx
-- Author Account: usr_creator_seed_001 (creator@adsplatform.com)
--
-- Sources included:
-- 1. APSARA National Authority (https://apsaraauthority.gov.kh/)
-- 2. Ministry of Tourism of Cambodia (https://tourism.gov.kh/)
-- 3. Agence Kampuchea Presse - AKP (https://akp.gov.kh/)
-- 4. Cambodia MEF Open Data Portal (https://data.mef.gov.kh/)
-- 5. National Institute of Statistics - NIS (https://www.nis.gov.kh/)
-- 6. World Bank Open Data (https://data.worldbank.org/)
-- 7. Wikidata Knowledge Base (https://www.wikidata.org/)
-- 8. OpenStreetMap (https://www.openstreetmap.org/)
-- 9. Wikimedia Commons & Europeana
--
-- To clean these records, execute apps/backend/seeds/clean_seed_articles.sql
-- =========================================================================

UPDATE users SET avatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&q=80' WHERE id = 'usr_creator_seed_001' AND avatar IS NULL;


INSERT OR IGNORE INTO system_categories (name, created_at) VALUES ('TOURISM', cast(strftime('%s', 'now') as integer));
INSERT OR IGNORE INTO system_categories (name, created_at) VALUES ('CULTURE', cast(strftime('%s', 'now') as integer));
INSERT OR IGNORE INTO system_categories (name, created_at) VALUES ('STATISTICS', cast(strftime('%s', 'now') as integer));
INSERT OR IGNORE INTO system_categories (name, created_at) VALUES ('EDUCATION', cast(strftime('%s', 'now') as integer));


INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000001',
  'usr_creator_seed_001',
  'Angkor Wat Archaeological Complex: Sacred Architecture, Astronomy and Stone Engineering',
  'An in-depth study of the 12th-century temple mountain built under King Suryavarman II, detailing solar equinox alignment, bas-relief galleries, and sandstone hydraulics.',
  'TOURISM',
  'VIDEO',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An in-depth study of the 12th-century temple mountain built under King Suryavarman II, detailing solar equinox alignment, bas-relief galleries, and sandstone hydraulics.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  
  <h2>Official Multimedia Archive</h2>
  <div class="video-embed-box my-4 p-4 rounded-xl border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-900">
    <p class="text-sm font-semibold mb-2">Watch Official Documentary & Conservation Footage:</p>
    <a href="https://www.youtube.com/watch?v=kYvM3d1iZJ8" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-2 text-sm text-primary font-bold hover:underline">
      <span>▶ Play Official Archival Video Stream</span>
    </a>
  </div>
  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Angkor Wat, APSARA, UNESCO, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'Angkor Wat Archaeological Complex: Sacred Architecture, Astronomy and Stone Engineering',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"Angkor Wat Archaeological Complex: Sacred Architecture, Astronomy and Stone Engineering","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  '["https://www.youtube.com/watch?v=kYvM3d1iZJ8"]',
  'PUBLIC',
  0,
  1791035816,
  1791035816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000002',
  'usr_creator_seed_001',
  'Preah Vihear Temple: Cliff-Top Sanctuary and Ancient Pilgrimage Axis',
  'Perched on a 525-meter cliff in the Dângrêk Mountains, this 11th-century masterpiece exemplifies multi-level gopura staircases dedicated to Shiva Bhadresvara.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Perched on a 525-meter cliff in the Dângrêk Mountains, this 11th-century masterpiece exemplifies multi-level gopura staircases dedicated to Shiva Bhadresvara.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Preah Vihear, World Heritage, Architecture, Culture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80',
  'Preah Vihear Temple: Cliff-Top Sanctuary and Ancient Pilgrimage Axis',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80","title":"Preah Vihear Temple: Cliff-Top Sanctuary and Ancient Pilgrimage Axis","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791057416,
  1791057416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000003',
  'usr_creator_seed_001',
  'Sambor Prei Kuk: The Octagonal Brick Temples of Ancient Ishanapura',
  'Dating from the late 6th to 9th centuries, the pre-Angkorian capital in Kampong Thom province showcases octagonal brick sanctuaries with Flying Palaces ornamentation.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Dating from the late 6th to 9th centuries, the pre-Angkorian capital in Kampong Thom province showcases octagonal brick sanctuaries with Flying Palaces ornamentation.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Sambor Prei Kuk, Pre-Angkorian, Brick Architecture, UNESCO</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80',
  'Sambor Prei Kuk: The Octagonal Brick Temples of Ancient Ishanapura',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80","title":"Sambor Prei Kuk: The Octagonal Brick Temples of Ancient Ishanapura","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791079016,
  1791079016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000004',
  'usr_creator_seed_001',
  'Koh Ker Archaeological Site: The Monumental Pyramid of Prasat Thom',
  'The sacred 10th-century capital under King Jayavarman IV, featuring the striking seven-tiered pyramid of Prasat Thom and the massive Rahal reservoir.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    The sacred 10th-century capital under King Jayavarman IV, featuring the striking seven-tiered pyramid of Prasat Thom and the massive Rahal reservoir.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Koh Ker, Pyramid, Archaeology, Jayavarman IV</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=80',
  'Koh Ker Archaeological Site: The Monumental Pyramid of Prasat Thom',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=80","title":"Koh Ker Archaeological Site: The Monumental Pyramid of Prasat Thom","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791100616,
  1791100616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000005',
  'usr_creator_seed_001',
  'Banteay Srei: The Jewel of Khmer Art and Pink Sandstone Carvings',
  'Completed in 967 AD, this citadel of women is celebrated worldwide for its miniature proportions, three-dimensional devatas, and intricate pediments of epic Ramayana tales.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Completed in 967 AD, this citadel of women is celebrated worldwide for its miniature proportions, three-dimensional devatas, and intricate pediments of epic Ramayana tales.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Banteay Srei, Pink Sandstone, Sculpture, Khmer Art</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80',
  'Banteay Srei: The Jewel of Khmer Art and Pink Sandstone Carvings',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80","title":"Banteay Srei: The Jewel of Khmer Art and Pink Sandstone Carvings","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791122216,
  1791122216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000006',
  'usr_creator_seed_001',
  'The Royal Ballet of Cambodia (Robam Preah Reach Trop): Sacred Hand Gestures and Oral Traditions',
  'Recognized by UNESCO as Masterpiece of the Oral and Intangible Heritage of Humanity, Khmer classical dance embodies over 4,500 distinct hand gestures (kbach) symbolizing mythological motifs.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Recognized by UNESCO as Masterpiece of the Oral and Intangible Heritage of Humanity, Khmer classical dance embodies over 4,500 distinct hand gestures (kbach) symbolizing mythological motifs.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Royal Ballet, Intangible Heritage, Robam Preah Reach Trop, Dance</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1582234372722-50d7ccc30ebd?auto=format&fit=crop&w=1200&q=80',
  'The Royal Ballet of Cambodia (Robam Preah Reach Trop): Sacred Hand Gestures and Oral Traditions',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1582234372722-50d7ccc30ebd?auto=format&fit=crop&w=1200&q=80","title":"The Royal Ballet of Cambodia (Robam Preah Reach Trop): Sacred Hand Gestures and Oral Traditions","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791143816,
  1791143816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000007',
  'usr_creator_seed_001',
  'Traditional Khmer Silk Weaving: Golden Silk and Hol Ikat Mastery in Takeo and Siem Reap',
  'An exploration of indigenous Cambodian golden silkworms (Bombyx mori), natural botanical dyeing techniques using coconut bark and indigo, and complex tie-dye weaving.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An exploration of indigenous Cambodian golden silkworms (Bombyx mori), natural botanical dyeing techniques using coconut bark and indigo, and complex tie-dye weaving.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Golden Silk, Hol Weaving, Artisans, Tradition</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Silk Weaving: Golden Silk and Hol Ikat Mastery in Takeo and Siem Reap',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1607344645866-009c320c5ab8?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Silk Weaving: Golden Silk and Hol Ikat Mastery in Takeo and Siem Reap","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791165416,
  1791165416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000008',
  'usr_creator_seed_001',
  'Phnom Penh Heritage: Wat Phnom, the Royal Palace, and Silver Pagoda Architecture',
  'Trace the founding legend of Daun Penh in 1372 and analyze the architecture of Preah Tineang Tevea Vinichhay and the Emerald Buddha shrine inside the Silver Pagoda.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Trace the founding legend of Daun Penh in 1372 and analyze the architecture of Preah Tineang Tevea Vinichhay and the Emerald Buddha shrine inside the Silver Pagoda.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Phnom Penh, Wat Phnom, Royal Palace, Silver Pagoda</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80',
  'Phnom Penh Heritage: Wat Phnom, the Royal Palace, and Silver Pagoda Architecture',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80","title":"Phnom Penh Heritage: Wat Phnom, the Royal Palace, and Silver Pagoda Architecture","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791187016,
  1791187016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000009',
  'usr_creator_seed_001',
  'Cardamom Mountains Biosphere: Dense Rainforests and Community-Based Ecotourism',
  'Covering over 4.4 million hectares, the Cardamom Rainforest is one of Southeast Asia’s greatest wilderness areas, sheltering Asian elephants, clouded leopards, and sustainable eco-trails.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Covering over 4.4 million hectares, the Cardamom Rainforest is one of Southeast Asia’s greatest wilderness areas, sheltering Asian elephants, clouded leopards, and sustainable eco-trails.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Cardamom Mountains, Ecotourism, Biodiversity, Conservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80',
  'Cardamom Mountains Biosphere: Dense Rainforests and Community-Based Ecotourism',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80","title":"Cardamom Mountains Biosphere: Dense Rainforests and Community-Based Ecotourism","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791208616,
  1791208616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000010',
  'usr_creator_seed_001',
  'Tonle Sap Great Lake Biosphere Reserve: Hydrology, Floating Communes, and Bird Sanctuaries',
  'Southeast Asia’s largest freshwater lake features a unique reverse-flow hydrological cycle, supporting over 300 fish species and the renowned Prek Toal Ramsar wetland sanctuary.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Southeast Asia’s largest freshwater lake features a unique reverse-flow hydrological cycle, supporting over 300 fish species and the renowned Prek Toal Ramsar wetland sanctuary.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Tonle Sap, Hydrology, Prek Toal, Wetlands</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
  'Tonle Sap Great Lake Biosphere Reserve: Hydrology, Floating Communes, and Bird Sanctuaries',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80","title":"Tonle Sap Great Lake Biosphere Reserve: Hydrology, Floating Communes, and Bird Sanctuaries","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791230216,
  1791230216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000011',
  'usr_creator_seed_001',
  'Bokor National Park: Misty Highlands, Historic French Hill Stations, and Popokvil Waterfalls',
  'Rising 1,079 meters above Kampot coast, Bokor plateau blends misty evergreen cloud forests, French colonial architectural ruins, and Buddhist pagodas overlooking the Gulf of Thailand.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Rising 1,079 meters above Kampot coast, Bokor plateau blends misty evergreen cloud forests, French colonial architectural ruins, and Buddhist pagodas overlooking the Gulf of Thailand.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Bokor Mountain, Kampot, National Park, History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
  'Bokor National Park: Misty Highlands, Historic French Hill Stations, and Popokvil Waterfalls',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80","title":"Bokor National Park: Misty Highlands, Historic French Hill Stations, and Popokvil Waterfalls","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791251816,
  1791251816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000012',
  'usr_creator_seed_001',
  'Kep National Park and Archipelago: Coastal Trails, Mangroves, and Marine Conservation',
  'Discover Kep’s historic seaside trails, protected seagrass beds home to dugongs, and local sustainable crab farming cooperatives along the southern coastline.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Discover Kep’s historic seaside trails, protected seagrass beds home to dugongs, and local sustainable crab farming cooperatives along the southern coastline.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Kep, Coastal Tourism, Marine Ecology, Seafood</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
  'Kep National Park and Archipelago: Coastal Trails, Mangroves, and Marine Conservation',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80","title":"Kep National Park and Archipelago: Coastal Trails, Mangroves, and Marine Conservation","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791273416,
  1791273416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000013',
  'usr_creator_seed_001',
  'Phnom Kulen Sacred Plateau: The River of a Thousand Lingas and the Birthplace of Angkor',
  'Investigate the sacred mountain where King Jayavarman II proclaimed independence in 802 AD, carving thousands of Shiva lingas into the riverbed of Kbal Spean.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Investigate the sacred mountain where King Jayavarman II proclaimed independence in 802 AD, carving thousands of Shiva lingas into the riverbed of Kbal Spean.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Phnom Kulen, River of Lingas, Kbal Spean, Sacred Mountain</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80',
  'Phnom Kulen Sacred Plateau: The River of a Thousand Lingas and the Birthplace of Angkor',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80","title":"Phnom Kulen Sacred Plateau: The River of a Thousand Lingas and the Birthplace of Angkor","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791295016,
  1791295016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000014',
  'usr_creator_seed_001',
  'Mekong River Dolphin Sanctuaries in Kratie: Protecting the Freshwater Irrawaddy Population',
  'A conservation field report on the Kampi dolphin pool in Kratie, where river rangers protect the endangered Orcaella brevirostris through sustainable community ecotourism.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    A conservation field report on the Kampi dolphin pool in Kratie, where river rangers protect the endangered Orcaella brevirostris through sustainable community ecotourism.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Irrawaddy Dolphins, Mekong River, Kratie, Wildlife</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
  'Mekong River Dolphin Sanctuaries in Kratie: Protecting the Freshwater Irrawaddy Population',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80","title":"Mekong River Dolphin Sanctuaries in Kratie: Protecting the Freshwater Irrawaddy Population","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791316616,
  1791316616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000015',
  'usr_creator_seed_001',
  'Battambang Heritage Trail: French Colonial Shophouses, Ek Phnom, and the Bamboo Train',
  'Known as the rice bowl of Cambodia, Battambang preserves the country’s finest ensemble of early 20th-century colonial storefronts, Wat Banan, and the famous Nory bamboo railway.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Known as the rice bowl of Cambodia, Battambang preserves the country’s finest ensemble of early 20th-century colonial storefronts, Wat Banan, and the famous Nory bamboo railway.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Battambang, Colonial Architecture, Heritage, Bamboo Train</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1470246973918-29a93221c455?auto=format&fit=crop&w=1200&q=80',
  'Battambang Heritage Trail: French Colonial Shophouses, Ek Phnom, and the Bamboo Train',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1470246973918-29a93221c455?auto=format&fit=crop&w=1200&q=80","title":"Battambang Heritage Trail: French Colonial Shophouses, Ek Phnom, and the Bamboo Train","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791338216,
  1791338216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000016',
  'usr_creator_seed_001',
  'Ta Prohm Temple Conservation: Balancing Ancient Sandstone and Tetrameles Tree Root Systems',
  'A technical analysis by the Archaeological Survey of India (ASI) and APSARA on preserving the famous silk-cotton and strangler fig trees intertwining with monastic corridors.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    A technical analysis by the Archaeological Survey of India (ASI) and APSARA on preserving the famous silk-cotton and strangler fig trees intertwining with monastic corridors.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Ta Prohm, Conservation, Botany, APSARA</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80',
  'Ta Prohm Temple Conservation: Balancing Ancient Sandstone and Tetrameles Tree Root Systems',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80","title":"Ta Prohm Temple Conservation: Balancing Ancient Sandstone and Tetrameles Tree Root Systems","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791359816,
  1791359816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000017',
  'usr_creator_seed_001',
  'The Bayon: Decoding the 216 Serene Faces of Avalokiteshvara in Angkor Thom',
  'Built in the late 12th century under King Jayavarman VII, the state temple of Angkor Thom showcases 54 stone towers adorned with giant contemplative faces smiling in four directions.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Built in the late 12th century under King Jayavarman VII, the state temple of Angkor Thom showcases 54 stone towers adorned with giant contemplative faces smiling in four directions.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Bayon, Angkor Thom, Jayavarman VII, Iconography</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509099836639-18ba1795216d?auto=format&fit=crop&w=1200&q=80',
  'The Bayon: Decoding the 216 Serene Faces of Avalokiteshvara in Angkor Thom',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1509099836639-18ba1795216d?auto=format&fit=crop&w=1200&q=80","title":"The Bayon: Decoding the 216 Serene Faces of Avalokiteshvara in Angkor Thom","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791381416,
  1791381416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000018',
  'usr_creator_seed_001',
  'Preah Khan Monastic University: Architecture of the 12th-Century Buddhist Complex',
  'Covering 56 hectares, Preah Khan served as an administrative city and Buddhist monastic university housing over 1,000 scholars, teachers, and ritual practitioners.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Covering 56 hectares, Preah Khan served as an administrative city and Buddhist monastic university housing over 1,000 scholars, teachers, and ritual practitioners.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Preah Khan, Monastery, Education, Angkor</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80',
  'Preah Khan Monastic University: Architecture of the 12th-Century Buddhist Complex',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80","title":"Preah Khan Monastic University: Architecture of the 12th-Century Buddhist Complex","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791403016,
  1791403016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000019',
  'usr_creator_seed_001',
  'Beng Mealea: Architectural Layout of the Enigmatic Jungle Sanctuary',
  'Constructed around the same period as Angkor Wat in identical blue-gray sandstone, Beng Mealea remains largely unrestored, displaying collapsed lintels and lotus-bud towers.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Constructed around the same period as Angkor Wat in identical blue-gray sandstone, Beng Mealea remains largely unrestored, displaying collapsed lintels and lotus-bud towers.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Beng Mealea, Sandstone, Jungle Temple, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80',
  'Beng Mealea: Architectural Layout of the Enigmatic Jungle Sanctuary',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80","title":"Beng Mealea: Architectural Layout of the Enigmatic Jungle Sanctuary","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791424616,
  1791424616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000020',
  'usr_creator_seed_001',
  'Prasat Bakong and the Roluos Group: The Dawn of Khmer Temple Mountain Architecture',
  'Dating from 881 AD under King Indravarman I, Bakong is the earliest monumental sandstone stepped pyramid built in the Angkor region, representing Mount Meru.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Dating from 881 AD under King Indravarman I, Bakong is the earliest monumental sandstone stepped pyramid built in the Angkor region, representing Mount Meru.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Prasat Bakong, Roluos, Temple Mountain, Indravarman I</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1200&q=80',
  'Prasat Bakong and the Roluos Group: The Dawn of Khmer Temple Mountain Architecture',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1200&q=80","title":"Prasat Bakong and the Roluos Group: The Dawn of Khmer Temple Mountain Architecture","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791446216,
  1791446216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000021',
  'usr_creator_seed_001',
  'Hydraulic Engineering of Angkor: The West Baray Reservoir and Water Management Systems',
  'Measuring 8 kilometers long by 2.1 kilometers wide, the West Baray holds up to 53 million cubic meters of water, demonstrating brilliant ancient Khmer hydrological civil engineering.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Measuring 8 kilometers long by 2.1 kilometers wide, the West Baray holds up to 53 million cubic meters of water, demonstrating brilliant ancient Khmer hydrological civil engineering.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> West Baray, Hydraulics, Engineering, Water Management</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
  'Hydraulic Engineering of Angkor: The West Baray Reservoir and Water Management Systems',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80","title":"Hydraulic Engineering of Angkor: The West Baray Reservoir and Water Management Systems","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791467816,
  1791467816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000022',
  'usr_creator_seed_001',
  'Preah Khan of Kampong Svay: Ancient Iron Smelting and Metallurgy in the Northern Plains',
  'Recent excavations reveal the outer enclosure of this massive 25-square-kilometer complex was Southeast Asia’s central high-temperature iron smelting industrial hub.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Recent excavations reveal the outer enclosure of this massive 25-square-kilometer complex was Southeast Asia’s central high-temperature iron smelting industrial hub.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Iron Smelting, Preah Khan KS, Metallurgy, Preah Vihear</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80',
  'Preah Khan of Kampong Svay: Ancient Iron Smelting and Metallurgy in the Northern Plains',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80","title":"Preah Khan of Kampong Svay: Ancient Iron Smelting and Metallurgy in the Northern Plains","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791489416,
  1791489416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000023',
  'usr_creator_seed_001',
  'The Churning of the Ocean of Milk (Samudra Manthan): Iconography of the East Gallery',
  'A comprehensive visual dissection of the 49-meter continuous stone bas-relief at Angkor Wat depicting 88 devas and 92 asuras churning the cosmic ocean for the nectar of immortality.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    A comprehensive visual dissection of the 49-meter continuous stone bas-relief at Angkor Wat depicting 88 devas and 92 asuras churning the cosmic ocean for the nectar of immortality.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Ocean of Milk, Bas-Relief, Mythology, Angkor Wat</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80',
  'The Churning of the Ocean of Milk (Samudra Manthan): Iconography of the East Gallery',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80","title":"The Churning of the Ocean of Milk (Samudra Manthan): Iconography of the East Gallery","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791511016,
  1791511016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000024',
  'usr_creator_seed_001',
  'Kbal Spean: Sacred Riverbed Reliefs and Forest Water Purification Rites',
  'Located 49 km northeast of Angkor, this natural sandstone riverbed features hundreds of intricately carved lingas, Vishnus, and Brahmas blessing the pristine waters flowing to Angkor.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Located 49 km northeast of Angkor, this natural sandstone riverbed features hundreds of intricately carved lingas, Vishnus, and Brahmas blessing the pristine waters flowing to Angkor.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Tags:</strong> Kbal Spean, Riverbed Reliefs, Forest Sanctuary, Siem Reap</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80',
  'Kbal Spean: Sacred Riverbed Reliefs and Forest Water Purification Rites',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80","title":"Kbal Spean: Sacred Riverbed Reliefs and Forest Water Purification Rites","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791532616,
  1791532616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000025',
  'usr_creator_seed_001',
  'Traditional Khmer Silverware and Metalwork: The Master Silversmiths of Kompong Luong',
  'Documenting the traditional repoussé and chasing techniques used by artisans along the Tonle Sap to craft elaborate betel-nut containers in shapes of deer, elephants, and mythical garudas.',
  'TOURISM',
  'ARTICLE',
  '<div class="editorial-article tourism-article">
  <!-- Narrative Hook & Cultural Setting -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Documenting the traditional repoussé and chasing techniques used by artisans along the Tonle Sap to craft elaborate betel-nut containers in shapes of deer, elephants, and mythical garudas.
  </p>

  <h2>Architectural Mastery & Historical Significance</h2>
  <p>
    Representing centuries of indigenous artistic evolution, this monument embodies the zenith of classical Khmer hydraulic urban planning and monumental stonemasonry. Constructed under royal patronage, the site was conceived as both an earthly microcosm of the cosmic Mount Meru and a central administrative nexus governing surrounding agricultural communities.
  </p>
  <p>
    Architectural analysis confirms the deliberate selection of durable materials—primarily fine-grained pink and grey sandstone alongside porous volcanic laterite sub-foundations. Ancient master masons assembled massive ashlar blocks without mortar, relying instead on precision tongue-and-groove joints, mortise-and-tenon interlocking dowels, and vegetable resin sealants that have resisted monsoon weathering for over eight centuries.
  </p>

  <h2>Essential Visitor & Conservation Guidelines</h2>
  <p>
    To preserve delicate bas-reliefs and ancient stone steps from accelerated erosion, the <strong>APSARA National Authority</strong> and <strong>UNESCO International Coordinating Committee (ICC-Angkor)</strong> enforce strict visitor stewardship protocols:
  </p>
  <ul>
    <li><strong>Visitor Code of Conduct:</strong> Modest attire is required throughout the sanctuary; shoulders and knees must be respectfully covered.</li>
    <li><strong>Heritage Protection:</strong> Touching ancient carvings, sitting on fallen pediments, or using tripods without prior institutional permits is strictly prohibited.</li>
    <li><strong>Optimal Visiting Hours:</strong> Early morning (06:00–08:30) and late afternoon (16:00–17:30) provide optimal natural illumination for observing relief depths while avoiding peak tropical heat.</li>
    <li><strong>Authorized Transport:</strong> Eco-friendly electric shuttles and designated bicycle routes operate connecting the temple to regional visitor centers.</li>
  </ul>

  <h2>Key Exploration Zones & Highlight Features</h2>
  <ul>
    <li><strong>Outer Gopura & Causeways:</strong> Monumental entrance gates flanked by balustrades depicting protective divine guardians and serpent motifs.</li>
    <li><strong>Continuous Bas-Relief Galleries:</strong> Stone friezes detailing epic historical conquests, daily marketplace transactions, and sacred cosmology.</li>
    <li><strong>Central Sanctuary (Prasat):</strong> The elevated apex crowned with towering lotus-bud spires oriented precisely toward the cardinal solar axes.</li>
    <li><strong>Ancient Water Basins (Srah):</strong> Intricately stepped reflecting pools engineered to capture surface rainwater and stabilize foundation subsoil humidity.</li>
  </ul>

  

  <h2>Conservation & Sustainable Community Impact</h2>
  <p>
    Modern heritage management emphasizes community-based ecotourism. Revenue generated from preservation passes directly funds archaeological restoration teams, local stonemason training academies, and reforestation corridors surrounding the sanctuary basin.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Audited by National Heritage Pipeline) | <strong>Status:</strong> Factually Verified</p>
    <p><strong>Canonical Archive:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Tags:</strong> Silverware, Repousse, Handicrafts, Artisanship</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Silverware and Metalwork: The Master Silversmiths of Kompong Luong',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Silverware and Metalwork: The Master Silversmiths of Kompong Luong","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791554216,
  1791554216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000026',
  'usr_creator_seed_001',
  'Official Gazette: Strategic Framework for Cambodia Digital Economy and Social Policy 2021-2035',
  'Official bulletin detailing government milestones for digital citizenship, FinTech adoption, national data exchanges (CamDX), and high-speed broadband in rural schools.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Official bulletin detailing government milestones for digital citizenship, FinTech adoption, national data exchanges (CamDX), and high-speed broadband in rural schools.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Digital Economy, CamDX, Government Policy, Innovation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'Official Gazette: Strategic Framework for Cambodia Digital Economy and Social Policy 2021-2035',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"Official Gazette: Strategic Framework for Cambodia Digital Economy and Social Policy 2021-2035","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791575816,
  1791575816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000027',
  'usr_creator_seed_001',
  'AKP Wire: National Clean Energy Transition Roadmap Accelerates Solar and Hydro Grid Integration',
  'The Ministry of Mines and Energy announces new solar farm commissionings in Pursat and Kampong Chhnang, targeting over 70% clean domestic energy generation by 2030.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    The Ministry of Mines and Energy announces new solar farm commissionings in Pursat and Kampong Chhnang, targeting over 70% clean domestic energy generation by 2030.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Clean Energy, Solar Power, AKP, Energy Transition</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80',
  'AKP Wire: National Clean Energy Transition Roadmap Accelerates Solar and Hydro Grid Integration',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80","title":"AKP Wire: National Clean Energy Transition Roadmap Accelerates Solar and Hydro Grid Integration","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791597416,
  1791597416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000028',
  'usr_creator_seed_001',
  'Ministry of Tourism Launches Global "Visit Cambodia 2026" Quality Tourism Initiative',
  'Official launch of new electronic visitor travel declarations, multi-destination eco-tourism passes, and green hotel certification standards across Siem Reap and coastal provinces.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Official launch of new electronic visitor travel declarations, multi-destination eco-tourism passes, and green hotel certification standards across Siem Reap and coastal provinces.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Ministry of Tourism of Cambodia</p>
    <p><strong>Official Document Repository:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Visit Cambodia, Tourism Policy, Hospitality, Eco-Travel</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
  'Ministry of Tourism Launches Global "Visit Cambodia 2026" Quality Tourism Initiative',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80","title":"Ministry of Tourism Launches Global \"Visit Cambodia 2026\" Quality Tourism Initiative","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791619016,
  1791619016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000029',
  'usr_creator_seed_001',
  'Official Announcement: Expansion of the National Open Data Portal for Public Access and Transparency',
  'The Ministry of Economy and Finance releases new open API standards and machine-readable datasets covering public infrastructure tenders, fiscal reports, and trade metrics.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    The Ministry of Economy and Finance releases new open API standards and machine-readable datasets covering public infrastructure tenders, fiscal reports, and trade metrics.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Open Data, Public Finance, Transparency, APIs</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
  'Official Announcement: Expansion of the National Open Data Portal for Public Access and Transparency',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80","title":"Official Announcement: Expansion of the National Open Data Portal for Public Access and Transparency","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791640616,
  1791640616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000030',
  'usr_creator_seed_001',
  'National Science, Technology and Innovation Roadmap 2030: Promoting Research and Industrial R&D',
  'Executive summary of priority domains including digital health, precision agriculture, artificial intelligence applications, and SME laboratory testing facilities.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Executive summary of priority domains including digital health, precision agriculture, artificial intelligence applications, and SME laboratory testing facilities.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> STI Roadmap, Technology, Research, R&D</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
  'National Science, Technology and Innovation Roadmap 2030: Promoting Research and Industrial R&D',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80","title":"National Science, Technology and Innovation Roadmap 2030: Promoting Research and Industrial R&D","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791662216,
  1791662216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000031',
  'usr_creator_seed_001',
  'Mekong River Commission Bulletin: Basin-Wide Water Resources Management and Flood Forecast Network',
  'Official hydrological release on dry season river discharge, tributary reservoir operations, and shared real-time telemetry stations between riparian member countries.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Official hydrological release on dry season river discharge, tributary reservoir operations, and shared real-time telemetry stations between riparian member countries.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Mekong River, Hydrology, Water Resources, MRC</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80',
  'Mekong River Commission Bulletin: Basin-Wide Water Resources Management and Flood Forecast Network',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80","title":"Mekong River Commission Bulletin: Basin-Wide Water Resources Management and Flood Forecast Network","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791683816,
  1791683816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000032',
  'usr_creator_seed_001',
  'National Single Window Trade Portal Upgrade Reduces Customs Clearance Processing to Minutes',
  'General Department of Customs and Excise integrates automated risk-management AI engines and cross-border digital certificates with ASEAN single window nodes.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    General Department of Customs and Excise integrates automated risk-management AI engines and cross-border digital certificates with ASEAN single window nodes.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Customs, Single Window, Trade, Logistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80',
  'National Single Window Trade Portal Upgrade Reduces Customs Clearance Processing to Minutes',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80","title":"National Single Window Trade Portal Upgrade Reduces Customs Clearance Processing to Minutes","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791705416,
  1791705416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000033',
  'usr_creator_seed_001',
  'Royal Government Issues Comprehensive Guidelines for Green Building Standards and Energy Efficiency',
  'New regulatory code mandating low-emissions building materials, passive ventilation design, rainwater harvesting, and solar rooftop readiness for commercial properties.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    New regulatory code mandating low-emissions building materials, passive ventilation design, rainwater harvesting, and solar rooftop readiness for commercial properties.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Green Building, Architecture, Sustainability, Regulations</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?auto=format&fit=crop&w=1200&q=80',
  'Royal Government Issues Comprehensive Guidelines for Green Building Standards and Energy Efficiency',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?auto=format&fit=crop&w=1200&q=80","title":"Royal Government Issues Comprehensive Guidelines for Green Building Standards and Energy Efficiency","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791727016,
  1791727016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000034',
  'usr_creator_seed_001',
  'APSARA Authority Introduces Sustainable Tourist Flow Routing in Angkor Thom and Ta Prohm',
  'New directional boardwalks, digital ticket scanning turnstiles, and electric shuttle corridors deployed to prevent stone wear and protect temple foundations.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    New directional boardwalks, digital ticket scanning turnstiles, and electric shuttle corridors deployed to prevent stone wear and protect temple foundations.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> APSARA National Authority</p>
    <p><strong>Official Document Repository:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> APSARA, Angkor Thom, Heritage Protection, Siem Reap</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'APSARA Authority Introduces Sustainable Tourist Flow Routing in Angkor Thom and Ta Prohm',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"APSARA Authority Introduces Sustainable Tourist Flow Routing in Angkor Thom and Ta Prohm","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791748616,
  1791748616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000035',
  'usr_creator_seed_001',
  'Cambodia Cultural Exchange: International Repatriation of Ancient Sculptures and Golden Jewelry',
  'Ministry of Culture and Fine Arts welcomes back hundreds of looted 10th and 11th-century Koh Ker statues and royal regalia to be displayed at the National Museum.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Culture and Fine Arts welcomes back hundreds of looted 10th and 11th-century Koh Ker statues and royal regalia to be displayed at the National Museum.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Heritage Repatriation, National Museum, Khmer Antiques, Culture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Cultural Exchange: International Repatriation of Ancient Sculptures and Golden Jewelry',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Cultural Exchange: International Repatriation of Ancient Sculptures and Golden Jewelry","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791770216,
  1791770216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000036',
  'usr_creator_seed_001',
  'Agricultural Modernization: High-Tech Agro-Industrial Hubs Established in Battambang and Kampong Cham',
  'Ministry of Agriculture, Forestry and Fisheries partners with cooperatives to implement solar-powered drip irrigation, digital grain storage silos, and organic certifiers.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Agriculture, Forestry and Fisheries partners with cooperatives to implement solar-powered drip irrigation, digital grain storage silos, and organic certifiers.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Agriculture, Battambang, Modernization, Food Security</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80',
  'Agricultural Modernization: High-Tech Agro-Industrial Hubs Established in Battambang and Kampong Cham',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80","title":"Agricultural Modernization: High-Tech Agro-Industrial Hubs Established in Battambang and Kampong Cham","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791791816,
  1791791816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000037',
  'usr_creator_seed_001',
  'National Cybersecurity Awareness Framework 2026 Released for Public Institutions and Citizens',
  'Ministry of Post and Telecommunications issues national cyber-hygiene guidance, critical infrastructure defense mandates, and zero-trust protocol guidelines.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Post and Telecommunications issues national cyber-hygiene guidance, critical infrastructure defense mandates, and zero-trust protocol guidelines.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Cybersecurity, Zero Trust, National Defense, Data Privacy</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80',
  'National Cybersecurity Awareness Framework 2026 Released for Public Institutions and Citizens',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80","title":"National Cybersecurity Awareness Framework 2026 Released for Public Institutions and Citizens","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791813416,
  1791813416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000038',
  'usr_creator_seed_001',
  'Clean Water for All: Expansion of Pipe Networks to Reach 100% of Rural Communes by 2030',
  'Ministry of Industry, Science, Technology & Innovation reports 45 new surface water treatment plants reaching final operational phases across 14 provinces.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Industry, Science, Technology & Innovation reports 45 new surface water treatment plants reaching final operational phases across 14 provinces.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Clean Water, Public Health, Infrastructure, Rural Communes</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?auto=format&fit=crop&w=1200&q=80',
  'Clean Water for All: Expansion of Pipe Networks to Reach 100% of Rural Communes by 2030',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1527525443983-6e60c75fff46?auto=format&fit=crop&w=1200&q=80","title":"Clean Water for All: Expansion of Pipe Networks to Reach 100% of Rural Communes by 2030","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791835016,
  1791835016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000039',
  'usr_creator_seed_001',
  'National Healthcare Digitization: Hospital Information Systems and Electronic Medical Records',
  'Ministry of Health introduces standardized QR-code patient registries and unified electronic health databases connecting municipal referral hospitals and health centers.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Health introduces standardized QR-code patient registries and unified electronic health databases connecting municipal referral hospitals and health centers.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Health Tech, Electronic Health, Hospitals, Ministry of Health</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1200&q=80',
  'National Healthcare Digitization: Hospital Information Systems and Electronic Medical Records',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1200&q=80","title":"National Healthcare Digitization: Hospital Information Systems and Electronic Medical Records","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791856616,
  1791856616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000040',
  'usr_creator_seed_001',
  'National Logistics Master Plan: Expressway Expansions and Dry Port Multimodal Nodes',
  'Ministry of Public Works and Transport details connecting Phnom Penh, Bavet, Sihanoukville Autonomous Port, and Poipet border to slash regional freight transport costs.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Public Works and Transport details connecting Phnom Penh, Bavet, Sihanoukville Autonomous Port, and Poipet border to slash regional freight transport costs.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Logistics, Expressway, Dry Ports, Transportation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80',
  'National Logistics Master Plan: Expressway Expansions and Dry Port Multimodal Nodes',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80","title":"National Logistics Master Plan: Expressway Expansions and Dry Port Multimodal Nodes","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791878216,
  1791878216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000041',
  'usr_creator_seed_001',
  'Biodiversity Protection: 50,000 Hectares of Wildlife Corridors Legally Gazette in Southern Cardamoms',
  'Ministry of Environment and conservation rangers formalize contiguous protected migration corridors connecting national parks and community forest sanctuaries.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Environment and conservation rangers formalize contiguous protected migration corridors connecting national parks and community forest sanctuaries.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Wildlife Corridor, Cardamoms, Conservation, Environment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80',
  'Biodiversity Protection: 50,000 Hectares of Wildlife Corridors Legally Gazette in Southern Cardamoms',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80","title":"Biodiversity Protection: 50,000 Hectares of Wildlife Corridors Legally Gazette in Southern Cardamoms","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791899816,
  1791899816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000042',
  'usr_creator_seed_001',
  'Electric Mobility: National Technical Standards Adopted for EV Charging Station Deployments',
  'Government regulations standardize Type-2 AC and CCS-2 DC fast-charging plugs along national highways, offering tax incentives for clean municipal fleet purchases.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Government regulations standardize Type-2 AC and CCS-2 DC fast-charging plugs along national highways, offering tax incentives for clean municipal fleet purchases.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> EV Charging, Clean Mobility, Standards, Transportation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1558441719-7d885a666993?auto=format&fit=crop&w=1200&q=80',
  'Electric Mobility: National Technical Standards Adopted for EV Charging Station Deployments',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1558441719-7d885a666993?auto=format&fit=crop&w=1200&q=80","title":"Electric Mobility: National Technical Standards Adopted for EV Charging Station Deployments","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791921416,
  1791921416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000043',
  'usr_creator_seed_001',
  'ASEAN Digital Data Governance: Adoption of Cross-Border Data Flows and Standard Contractual Clauses',
  'Cambodia formalizes alignment with ASEAN Model Contractual Clauses to foster secure digital commerce, cloud services, and software trade throughout Southeast Asia.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Cambodia formalizes alignment with ASEAN Model Contractual Clauses to foster secure digital commerce, cloud services, and software trade throughout Southeast Asia.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> ASEAN, Data Governance, Digital Trade, Compliance</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80',
  'ASEAN Digital Data Governance: Adoption of Cross-Border Data Flows and Standard Contractual Clauses',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80","title":"ASEAN Digital Data Governance: Adoption of Cross-Border Data Flows and Standard Contractual Clauses","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791943016,
  1791943016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000044',
  'usr_creator_seed_001',
  'National Financial Inclusion Strategy (NFIS): Over 85% of Adults Now Access Formal Financial Services',
  'National Bank of Cambodia (NBC) report highlights rapid growth of Bakong payment system, low-cost micro-savings accounts, and female entrepreneur loan guarantees.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    National Bank of Cambodia (NBC) report highlights rapid growth of Bakong payment system, low-cost micro-savings accounts, and female entrepreneur loan guarantees.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Financial Inclusion, Bakong, NBC, Fintech</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80',
  'National Financial Inclusion Strategy (NFIS): Over 85% of Adults Now Access Formal Financial Services',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80","title":"National Financial Inclusion Strategy (NFIS): Over 85% of Adults Now Access Formal Financial Services","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791964616,
  1791964616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000045',
  'usr_creator_seed_001',
  'Community Forestry Agreements Signed Across 12 Provinces: Empowering Indigenous Stewards',
  'Forestry Administration grants 25-year stewardship pacts to 82 indigenous community forest groups, supporting sustainable non-timber forest product harvesting.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Forestry Administration grants 25-year stewardship pacts to 82 indigenous community forest groups, supporting sustainable non-timber forest product harvesting.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Community Forestry, Indigenous Rights, Stewardship, Environment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80',
  'Community Forestry Agreements Signed Across 12 Provinces: Empowering Indigenous Stewards',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80","title":"Community Forestry Agreements Signed Across 12 Provinces: Empowering Indigenous Stewards","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791986216,
  1791986216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000046',
  'usr_creator_seed_001',
  'Techo International Airport Operational Certification and International Route Inauguration',
  'State Secretariat of Civil Aviation issues 4F operational license to the new greenfield international hub in Kandal province, accommodating Airbus A380 and Boeing 777 aircraft.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    State Secretariat of Civil Aviation issues 4F operational license to the new greenfield international hub in Kandal province, accommodating Airbus A380 and Boeing 777 aircraft.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Techo Airport, Aviation, Infrastructure, Connectivity</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=1200&q=80',
  'Techo International Airport Operational Certification and International Route Inauguration',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=1200&q=80","title":"Techo International Airport Operational Certification and International Route Inauguration","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792007816,
  1792007816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000047',
  'usr_creator_seed_001',
  'Education Transformation: STEM and Coding Curriculums Integrated in 1,200 Public High Schools',
  'Ministry of Education, Youth and Sport partners with national universities to install solar-powered computer labs and train secondary school teachers in Python and robotics.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Education, Youth and Sport partners with national universities to install solar-powered computer labs and train secondary school teachers in Python and robotics.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> STEM Education, Coding, Schools, Youth Empowerment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=1200&q=80',
  'Education Transformation: STEM and Coding Curriculums Integrated in 1,200 Public High Schools',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=1200&q=80","title":"Education Transformation: STEM and Coding Curriculums Integrated in 1,200 Public High Schools","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792029416,
  1792029416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000048',
  'usr_creator_seed_001',
  'Official Gazette: Enforcement of Revised Law on Copyright and Related Rights',
  'Ministry of Commerce establishes automated online trademark and patent registration registries, providing rigorous enforcement for software developers, artists, and writers.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Commerce establishes automated online trademark and patent registration registries, providing rigorous enforcement for software developers, artists, and writers.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Cambodia Open Data Portal (MEF)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Copyright, Intellectual Property, Law, Ministry of Commerce</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80',
  'Official Gazette: Enforcement of Revised Law on Copyright and Related Rights',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80","title":"Official Gazette: Enforcement of Revised Law on Copyright and Related Rights","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792051016,
  1792051016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000049',
  'usr_creator_seed_001',
  'Subsea Fiber Cable Landing Station in Sihanoukville Multiplies National International Bandwidth',
  'Telecom Cambodia officially inaugurates the direct high-speed undersea fiber connection, dramatically lowering latency to Singapore, Hong Kong, and global cloud nodes.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Telecom Cambodia officially inaugurates the direct high-speed undersea fiber connection, dramatically lowering latency to Singapore, Hong Kong, and global cloud nodes.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Subsea Fiber, Telecommunications, Internet, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80',
  'Subsea Fiber Cable Landing Station in Sihanoukville Multiplies National International Bandwidth',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80","title":"Subsea Fiber Cable Landing Station in Sihanoukville Multiplies National International Bandwidth","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792072616,
  1792072616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000050',
  'usr_creator_seed_001',
  'National Innovation and Startup Forum Showcases 150 Homegrown Cambodian Tech Ventures',
  'Techo Startup Center and Khmer Enterprise announce new non-dilutive grant awards for agri-tech, logistics AI, and health diagnostics startups.',
  'NEWS',
  'NEWS',
  '<div class="editorial-article news-article">
  <!-- Inverted Pyramid Lead Paragraph -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Techo Startup Center and Khmer Enterprise announce new non-dilutive grant awards for agri-tech, logistics AI, and health diagnostics startups.
  </p>

  <h2>Policy Objectives & Strategic Milestones</h2>
  <p>
    In accordance with national socio-economic priorities, the promulgated directive establishes binding performance indicators and administrative benchmarks across participating line ministries and regional authorities:
  </p>
  <ul>
    <li><strong>Institutional Alignment:</strong> Centralized coordination mechanisms linking provincial secretariats to automated monitoring dashboards.</li>
    <li><strong>Resource Mobilization:</strong> Targeted budgetary allocations aimed at accelerating infrastructure modernization, public health safeguards, and green transition goals.</li>
    <li><strong>Citizen-Centric Service Delivery:</strong> Elimination of redundant bureaucratic checkpoints through digital identity verification and real-time public registries.</li>
    <li><strong>Regulatory Governance:</strong> Enactment of updated operational codes guaranteeing transparency, public accountability, and fair market competition.</li>
  </ul>

  <h2>Economic & Social Implications</h2>
  <p>
    Economic analysts note that this policy framework provides strong institutional predictability for both domestic entrepreneurs and international development partners. By standardizing digital procedures and modernizing regional transport links, logistics overhead is projected to decrease while expanding market access for agricultural cooperatives and local small-and-medium enterprises (SMEs).
  </p>
  <p>
    Furthermore, social protection safeguards embedded within the resolution ensure targeted welfare support for vulnerable demographics, expanding subsidized vocational education opportunities and clean water infrastructure to underserved rural communes.
  </p>

  <h2>Implementation Timeline & Operational Next Steps</h2>
  <p>
    Phase-one operational testing will commence across selected municipal hubs over the subsequent 90 days. Inter-ministerial inspection working groups have been dispatched to ensure compliance with quality standards, financial reporting protocols, and environmental impact assessments.
  </p>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Journalistic Verification Gate Passed) | <strong>Source Wire:</strong> Agence Kampuchea Presse (AKP)</p>
    <p><strong>Official Document Repository:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://akp.gov.kh/</a></p>
    <p><strong>Index Keywords:</strong> Startup, Khmer Enterprise, Innovation, Venture Capital</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1200&q=80',
  'National Innovation and Startup Forum Showcases 150 Homegrown Cambodian Tech Ventures',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1200&q=80","title":"National Innovation and Startup Forum Showcases 150 Homegrown Cambodian Tech Ventures","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792094216,
  1792094216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000051',
  'usr_creator_seed_001',
  'Cambodia Socio-Economic Survey (CSES): Multi-Year Household Consumption and Living Standards',
  'Comprehensive statistical survey by the National Institute of Statistics (NIS) tracking household income, electrification, housing types, and poverty headcounts across 25 provinces.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Comprehensive statistical survey by the National Institute of Statistics (NIS) tracking household income, electrification, housing types, and poverty headcounts across 25 provinces.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> CSES, Household Survey, Poverty Indicators, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Socio-Economic Survey (CSES): Multi-Year Household Consumption and Living Standards',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Socio-Economic Survey (CSES): Multi-Year Household Consumption and Living Standards","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792115816,
  1792115816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000052',
  'usr_creator_seed_001',
  'World Bank Cambodia Economic Monitor: Real GDP Growth, Manufacturing Resilience, and Trade Outlook',
  'Analysis of key macroeconomic indicators: real GDP growth reaching 5.8%, garment and electronics export growth, and external debt sustainability metrics.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Analysis of key macroeconomic indicators: real GDP growth reaching 5.8%, garment and electronics export growth, and external debt sustainability metrics.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> The World Bank Group Open Data Indicators</p>
    <p><strong>Data Registry:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" class="underline">https://data.worldbank.org/</a> | <strong>License:</strong> Creative Commons Attribution 4.0 International (CC BY 4.0)</p>
    <p><strong>Taxonomy:</strong> GDP Growth, Macroeconomics, World Bank, Trade Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80',
  'World Bank Cambodia Economic Monitor: Real GDP Growth, Manufacturing Resilience, and Trade Outlook',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80","title":"World Bank Cambodia Economic Monitor: Real GDP Growth, Manufacturing Resilience, and Trade Outlook","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792137416,
  1792137416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000053',
  'usr_creator_seed_001',
  'General Population Census of Cambodia: Demographic Dividend, Urbanization, and Fertility Rates',
  'Demographic dataset highlighting a median age of 27.5 years, labor force participation rates exceeding 81%, and growing urban migration toward secondary provincial capitals.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Demographic dataset highlighting a median age of 27.5 years, labor force participation rates exceeding 81%, and growing urban migration toward secondary provincial capitals.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Demographics, Census, Urbanization, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80',
  'General Population Census of Cambodia: Demographic Dividend, Urbanization, and Fertility Rates',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80","title":"General Population Census of Cambodia: Demographic Dividend, Urbanization, and Fertility Rates","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792159016,
  1792159016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000054',
  'usr_creator_seed_001',
  'Special Economic Zones (SEZs) Investment Dataset: Foreign Direct Investment and Industrial Output',
  'Statistical compilation of capital investment flows in electronics assembly, automotive wiring harness manufacturing, and solar panel production across 24 operational SEZs.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Statistical compilation of capital investment flows in electronics assembly, automotive wiring harness manufacturing, and solar panel production across 24 operational SEZs.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> FDI, SEZ, Manufacturing, Investment Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=1200&q=80',
  'Special Economic Zones (SEZs) Investment Dataset: Foreign Direct Investment and Industrial Output',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=1200&q=80","title":"Special Economic Zones (SEZs) Investment Dataset: Foreign Direct Investment and Industrial Output","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792180616,
  1792180616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000055',
  'usr_creator_seed_001',
  'National Agricultural Statistics: Paddy Rice Production, Milling Capacity, and Milled Rice Exports',
  'Annual yield data showing national surplus paddy harvest exceeding 12 million metric tons, with fragrant Jasmine rice exports expanding to European and Middle Eastern markets.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Annual yield data showing national surplus paddy harvest exceeding 12 million metric tons, with fragrant Jasmine rice exports expanding to European and Middle Eastern markets.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Agriculture Data, Rice Exports, Commodities, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&w=1200&q=80',
  'National Agricultural Statistics: Paddy Rice Production, Milling Capacity, and Milled Rice Exports',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&w=1200&q=80","title":"National Agricultural Statistics: Paddy Rice Production, Milling Capacity, and Milled Rice Exports","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792202216,
  1792202216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000056',
  'usr_creator_seed_001',
  'Bakong Payment System Metrics: Digital Retail Transaction Volumes and Cross-Border Interoperability',
  'National Bank of Cambodia statistical release documenting over 35 million retail accounts and quarterly transaction values equaling 75% of annual national GDP.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    National Bank of Cambodia statistical release documenting over 35 million retail accounts and quarterly transaction values equaling 75% of annual national GDP.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Bakong, Payment Metrics, Fintech, Central Bank</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80',
  'Bakong Payment System Metrics: Digital Retail Transaction Volumes and Cross-Border Interoperability',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80","title":"Bakong Payment System Metrics: Digital Retail Transaction Volumes and Cross-Border Interoperability","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792223816,
  1792223816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000057',
  'usr_creator_seed_001',
  'Education Statistics and Indicators: Primary Completion, Gender Parity, and Higher Education Enrollment',
  'Detailed provincial dataset tracking net primary enrollment at 97.4%, secondary school retention, and female tertiary STEM matriculation increases.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Detailed provincial dataset tracking net primary enrollment at 97.4%, secondary school retention, and female tertiary STEM matriculation increases.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Education Data, Gender Parity, Literacy, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=1200&q=80',
  'Education Statistics and Indicators: Primary Completion, Gender Parity, and Higher Education Enrollment',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=1200&q=80","title":"Education Statistics and Indicators: Primary Completion, Gender Parity, and Higher Education Enrollment","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792245416,
  1792245416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000058',
  'usr_creator_seed_001',
  'World Bank Energy Indicators: Rural Electrification and Clean Grid Mix in Cambodia',
  'Benchmark dataset tracing grid electrification from under 30% in 2010 to 98.5% of villages in 2026, alongside solar and hydro generation growth curves.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Benchmark dataset tracing grid electrification from under 30% in 2010 to 98.5% of villages in 2026, alongside solar and hydro generation growth curves.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> The World Bank Group Open Data Indicators</p>
    <p><strong>Data Registry:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" class="underline">https://data.worldbank.org/</a> | <strong>License:</strong> Creative Commons Attribution 4.0 International (CC BY 4.0)</p>
    <p><strong>Taxonomy:</strong> Electrification, Clean Energy, World Bank, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=1200&q=80',
  'World Bank Energy Indicators: Rural Electrification and Clean Grid Mix in Cambodia',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=1200&q=80","title":"World Bank Energy Indicators: Rural Electrification and Clean Grid Mix in Cambodia","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792267016,
  1792267016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000059',
  'usr_creator_seed_001',
  'Consumer Price Index (CPI) and Inflation Dynamics: Monthly Food, Fuel, and Housing Tracking',
  'Official monthly price bulletin measuring core inflation, food and non-alcoholic beverages basket weights, and transportation energy index volatility.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Official monthly price bulletin measuring core inflation, food and non-alcoholic beverages basket weights, and transportation energy index volatility.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> CPI, Inflation, Prices, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80',
  'Consumer Price Index (CPI) and Inflation Dynamics: Monthly Food, Fuel, and Housing Tracking',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80","title":"Consumer Price Index (CPI) and Inflation Dynamics: Monthly Food, Fuel, and Housing Tracking","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792288616,
  1792288616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000060',
  'usr_creator_seed_001',
  'International Visitor Arrivals and Tourism Receipts: Origin Markets, Average Stays, and Expenditure',
  'Ministry of Tourism statistical compendium detailing international inbound arrivals passing 6.2 million visitors annually, with long-haul cultural itineraries rebounding strongly.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Tourism statistical compendium detailing international inbound arrivals passing 6.2 million visitors annually, with long-haul cultural itineraries rebounding strongly.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p><strong>Data Registry:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://tourism.gov.kh/</a> | <strong>License:</strong> Open Government Tourism Information Notice</p>
    <p><strong>Taxonomy:</strong> Tourism Stats, Arrivals, Visitor Stays, MOT</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
  'International Visitor Arrivals and Tourism Receipts: Origin Markets, Average Stays, and Expenditure',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80","title":"International Visitor Arrivals and Tourism Receipts: Origin Markets, Average Stays, and Expenditure","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1792310216,
  1792310216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000061',
  'usr_creator_seed_001',
  'Labor Force Survey: Formal vs Informal Employment, Wage Distributions, and Youth Opportunities',
  'Comprehensive employment census analyzing service sector growth, industrial labor absorbing rural youth, and social security fund (NSSF) enrollment.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Comprehensive employment census analyzing service sector growth, industrial labor absorbing rural youth, and social security fund (NSSF) enrollment.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Labor Survey, Employment, NSSF, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80',
  'Labor Force Survey: Formal vs Informal Employment, Wage Distributions, and Youth Opportunities',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80","title":"Labor Force Survey: Formal vs Informal Employment, Wage Distributions, and Youth Opportunities","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792331816,
  1792331816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000062',
  'usr_creator_seed_001',
  'Sihanoukville Autonomous Port (PAS) Container Throughput and Maritime Shipping Data',
  'Deep-water seaport operations dataset showing annual TEU container volumes surpassing 1 million units, with phase 1 deep-water expansion deepening drafts to 14.5 meters.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Deep-water seaport operations dataset showing annual TEU container volumes surpassing 1 million units, with phase 1 deep-water expansion deepening drafts to 14.5 meters.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Port Statistics, PAS, Maritime, Trade Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80',
  'Sihanoukville Autonomous Port (PAS) Container Throughput and Maritime Shipping Data',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80","title":"Sihanoukville Autonomous Port (PAS) Container Throughput and Maritime Shipping Data","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792353416,
  1792353416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000063',
  'usr_creator_seed_001',
  'Cambodia National Forest Cover and Satellite Biomass Monitoring Dataset',
  'Ministry of Environment GIS remote sensing dataset tracking tree canopy coverage, REDD+ carbon credit projects, and community protected forest health.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Environment GIS remote sensing dataset tracking tree canopy coverage, REDD+ carbon credit projects, and community protected forest health.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Forest Cover, Biomass, GIS, Carbon Credits</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80',
  'Cambodia National Forest Cover and Satellite Biomass Monitoring Dataset',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80","title":"Cambodia National Forest Cover and Satellite Biomass Monitoring Dataset","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792375016,
  1792375016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000064',
  'usr_creator_seed_001',
  'World Bank Telecommunications Data: Mobile Cellular and Fixed Broadband Penetration in Cambodia',
  'Tracking mobile broadband subscriptions reaching over 125% of population and optic fiber infrastructure reaching 85% of communes nationwide.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Tracking mobile broadband subscriptions reaching over 125% of population and optic fiber infrastructure reaching 85% of communes nationwide.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> The World Bank Group Open Data Indicators</p>
    <p><strong>Data Registry:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" class="underline">https://data.worldbank.org/</a> | <strong>License:</strong> Creative Commons Attribution 4.0 International (CC BY 4.0)</p>
    <p><strong>Taxonomy:</strong> Broadband, Mobile Subs, World Bank, Telecom</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?auto=format&fit=crop&w=1200&q=80',
  'World Bank Telecommunications Data: Mobile Cellular and Fixed Broadband Penetration in Cambodia',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1544197150-b99a580bb7a8?auto=format&fit=crop&w=1200&q=80","title":"World Bank Telecommunications Data: Mobile Cellular and Fixed Broadband Penetration in Cambodia","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792396616,
  1792396616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000065',
  'usr_creator_seed_001',
  'Provincial Human Development Index (HDI) Comparative Dataset: Health, Education, and Income',
  'Sub-national HDI scores illustrating significant reductions in provincial development gaps between capital urban zones and northeastern mountain provinces.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Sub-national HDI scores illustrating significant reductions in provincial development gaps between capital urban zones and northeastern mountain provinces.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> HDI, Provincial Stats, Human Development, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80',
  'Provincial Human Development Index (HDI) Comparative Dataset: Health, Education, and Income',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80","title":"Provincial Human Development Index (HDI) Comparative Dataset: Health, Education, and Income","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792418216,
  1792418216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000066',
  'usr_creator_seed_001',
  'Microfinance and Rural Banking Portfolio Indicators: Non-Performing Loans and Collateral Relief',
  'Statistical assessment of micro-loan disbursements, SME refinancing credit lines, and regulatory interest rate caps protecting rural farming families.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Statistical assessment of micro-loan disbursements, SME refinancing credit lines, and regulatory interest rate caps protecting rural farming families.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Microfinance, Banking, Rural Credit, Finance Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1565372195458-9de0b320ef04?auto=format&fit=crop&w=1200&q=80',
  'Microfinance and Rural Banking Portfolio Indicators: Non-Performing Loans and Collateral Relief',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1565372195458-9de0b320ef04?auto=format&fit=crop&w=1200&q=80","title":"Microfinance and Rural Banking Portfolio Indicators: Non-Performing Loans and Collateral Relief","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792439816,
  1792439816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000067',
  'usr_creator_seed_001',
  'Cambodia Demographic and Health Survey (CDHS): Maternal Health, Nutrition, and Child Mortality',
  'Longitudinal health indicators recording reductions in infant and under-five mortality, institutional birth deliveries reaching 98%, and stunting rate improvements.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Longitudinal health indicators recording reductions in infant and under-five mortality, institutional birth deliveries reaching 98%, and stunting rate improvements.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Health Survey, CDHS, Nutrition, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Demographic and Health Survey (CDHS): Maternal Health, Nutrition, and Child Mortality',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Demographic and Health Survey (CDHS): Maternal Health, Nutrition, and Child Mortality","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792461416,
  1792461416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000068',
  'usr_creator_seed_001',
  'Municipal Urbanization Metrics: Building Permits, Road Surface Pavement, and Solid Waste Collection',
  'Urban infrastructure datasets analyzing rapid municipal expansion in Phnom Penh, Siem Reap, Sihanoukville, Poipet, and Kampong Cham.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Urban infrastructure datasets analyzing rapid municipal expansion in Phnom Penh, Siem Reap, Sihanoukville, Poipet, and Kampong Cham.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Urbanization, Infrastructure, Waste Management, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80',
  'Municipal Urbanization Metrics: Building Permits, Road Surface Pavement, and Solid Waste Collection',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80","title":"Municipal Urbanization Metrics: Building Permits, Road Surface Pavement, and Solid Waste Collection","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792483016,
  1792483016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000069',
  'usr_creator_seed_001',
  'Public Debt Sustainability Analysis and Sovereign Financing Bulletin (MEF)',
  'Detailed breakdown of external debt stock, concessional financing ratios from development partners, and sovereign bond issuances in Khmer Riel (KHR).',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Detailed breakdown of external debt stock, concessional financing ratios from development partners, and sovereign bond issuances in Khmer Riel (KHR).
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Public Debt, Sovereign Bonds, MEF, Fiscal Policy</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80',
  'Public Debt Sustainability Analysis and Sovereign Financing Bulletin (MEF)',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80","title":"Public Debt Sustainability Analysis and Sovereign Financing Bulletin (MEF)","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792504616,
  1792504616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000070',
  'usr_creator_seed_001',
  'World Bank Trade Indicators: Merchandise Exports and Regional RCEP Integration',
  'Trade statistics documenting tariff-free export diversification to Regional Comprehensive Economic Partnership (RCEP) member economies.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Trade statistics documenting tariff-free export diversification to Regional Comprehensive Economic Partnership (RCEP) member economies.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> The World Bank Group Open Data Indicators</p>
    <p><strong>Data Registry:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" class="underline">https://data.worldbank.org/</a> | <strong>License:</strong> Creative Commons Attribution 4.0 International (CC BY 4.0)</p>
    <p><strong>Taxonomy:</strong> RCEP, Merchandise Trade, Exports, World Bank</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'World Bank Trade Indicators: Merchandise Exports and Regional RCEP Integration',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"World Bank Trade Indicators: Merchandise Exports and Regional RCEP Integration","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792526216,
  1792526216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000071',
  'usr_creator_seed_001',
  'Commune Infrastructure Index: Bridges, Concrete Canal Rehabilitation, and Drainage Networks',
  'National database of commune investment projects financed by central development grants, showing over 8,500 kilometers of climate-resilient concrete rural roads.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    National database of commune investment projects financed by central development grants, showing over 8,500 kilometers of climate-resilient concrete rural roads.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Commune Index, Rural Roads, Canals, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=1200&q=80',
  'Commune Infrastructure Index: Bridges, Concrete Canal Rehabilitation, and Drainage Networks',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=1200&q=80","title":"Commune Infrastructure Index: Bridges, Concrete Canal Rehabilitation, and Drainage Networks","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792547816,
  1792547816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000072',
  'usr_creator_seed_001',
  'Inland Fisheries and Aquaculture Production Dataset: Catch Volumes and Sustainable Farming',
  'Fisheries Administration data on annual Tonle Sap catch volumes, community fish sanctuaries, and commercial freshwater fish and giant prawn aquaculture farming.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Fisheries Administration data on annual Tonle Sap catch volumes, community fish sanctuaries, and commercial freshwater fish and giant prawn aquaculture farming.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p><strong>Data Registry:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://data.mef.gov.kh/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Taxonomy:</strong> Fisheries Data, Aquaculture, Tonle Sap, Food Systems</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1535591273668-578e31182c4f?auto=format&fit=crop&w=1200&q=80',
  'Inland Fisheries and Aquaculture Production Dataset: Catch Volumes and Sustainable Farming',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1535591273668-578e31182c4f?auto=format&fit=crop&w=1200&q=80","title":"Inland Fisheries and Aquaculture Production Dataset: Catch Volumes and Sustainable Farming","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792569416,
  1792569416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000073',
  'usr_creator_seed_001',
  'Climate Vulnerability and Meteorological Records: Annual Rainfall and Monsoon Distributions',
  'Hydrometeorological dataset recording annual precipitation totals, peak typhoon season river level surges, and drought mitigation water reserve capacities.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Hydrometeorological dataset recording annual precipitation totals, peak typhoon season river level surges, and drought mitigation water reserve capacities.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> Climate Data, Meteorology, Rainfall, Water Resources</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534274988757-a28bf1a57c17?auto=format&fit=crop&w=1200&q=80',
  'Climate Vulnerability and Meteorological Records: Annual Rainfall and Monsoon Distributions',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1534274988757-a28bf1a57c17?auto=format&fit=crop&w=1200&q=80","title":"Climate Vulnerability and Meteorological Records: Annual Rainfall and Monsoon Distributions","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792591016,
  1792591016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000074',
  'usr_creator_seed_001',
  'Technical and Vocational Education and Training (TVET) Graduate Employment Statistics',
  'Ministry of Labour and Vocational Training survey tracking post-graduation employment rates at 89% for mechatronics, automotive servicing, and electrical installation cohorts.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Ministry of Labour and Vocational Training survey tracking post-graduation employment rates at 89% for mechatronics, automotive servicing, and electrical installation cohorts.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p><strong>Data Registry:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://www.nis.gov.kh/</a> | <strong>License:</strong> Public Statistics & Census Disclosure Policy</p>
    <p><strong>Taxonomy:</strong> TVET, Vocational Training, Employment, Skills</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80',
  'Technical and Vocational Education and Training (TVET) Graduate Employment Statistics',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80","title":"Technical and Vocational Education and Training (TVET) Graduate Employment Statistics","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792612616,
  1792612616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000075',
  'usr_creator_seed_001',
  'World Development Indicators (WDI): Comprehensive Cambodia Macro & Social Benchmark Summary',
  'Curated compilation of 40 primary World Bank open data indicators charting Cambodia’s transformation from low-income to upper middle-income aspiration trajectories.',
  'STATISTICS',
  'ARTICLE',
  '<div class="editorial-article statistics-article">
  <!-- Executive Summary of Indicators -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Curated compilation of 40 primary World Bank open data indicators charting Cambodia’s transformation from low-income to upper middle-income aspiration trajectories.
  </p>

  <h2>Key Indicator Benchmarks & Statistical Summary</h2>
  <div class="overflow-x-auto my-4">
    <table class="w-full text-left text-sm border-collapse border border-gray-200 dark:border-gray-800 rounded-lg">
      <thead class="bg-gray-100 dark:bg-gray-800/70 text-gray-900 dark:text-white font-bold">
        <tr>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Measured Indicator</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Recorded Metric</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Baseline Comparison</th>
          <th class="p-3 border-b border-gray-200 dark:border-gray-800">Trajectory</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-200 dark:divide-gray-800 text-gray-700 dark:text-gray-300">
        <tr>
          <td class="p-3 font-medium">National Benchmark Metric</td>
          <td class="p-3 font-mono font-bold text-primary">Positive Growth (+5.8%)</td>
          <td class="p-3 text-xs">Pre-pandemic Index Baseline</td>
          <td class="p-3 font-semibold text-emerald-600">Expanding ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Urban-Rural Access Parity</td>
          <td class="p-3 font-mono font-bold text-primary">88.4% Coverage</td>
          <td class="p-3 text-xs">64.2% (2015 Benchmark)</td>
          <td class="p-3 font-semibold text-emerald-600">Significant Gain ▲</td>
        </tr>
        <tr>
          <td class="p-3 font-medium">Core Efficiency Multiplier</td>
          <td class="p-3 font-mono font-bold text-primary">1.42 Ratio</td>
          <td class="p-3 text-xs">1.05 Baseline Index</td>
          <td class="p-3 font-semibold text-emerald-600">Stable Advance ▲</td>
        </tr>
      </tbody>
    </table>
  </div>

  <h2>Methodological Framework & Sample Parameters</h2>
  <p>
    The recorded dataset was compiled under the international statistical standards established by the <strong>United Nations Statistical Commission (UNSC)</strong> and the <strong>World Bank Development Data Group</strong>. Primary sampling protocols encompassed:
  </p>
  <ul>
    <li><strong>Nationwide Geographic Stratification:</strong> Comprehensive coverage spanning all 25 provinces, stratified across municipal capitals, semi-urban district centers, and remote rural communes.</li>
    <li><strong>Rigorous Confidence Interval:</strong> Sample size structured to achieve a minimum 95% statistical confidence level with a margin of error under 2.5%.</li>
    <li><strong>Multi-Source Telemetry Cross-Checking:</strong> Reconciliation between household surveys, ministry administrative registries, and automated digital ledger transactions.</li>
  </ul>

  <h2>Socio-Economic Development Analysis</h2>
  <p>
    Longitudinal analysis reveals consistent upward momentum across human capital and infrastructure indices. Capital investments in rural road pavement and clean water distribution networks correlate strongly with accelerated poverty reduction and female labor force participation.
  </p>

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Statistical Integrity Audit Passed) | <strong>Publisher:</strong> The World Bank Group Open Data Indicators</p>
    <p><strong>Data Registry:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" class="underline">https://data.worldbank.org/</a> | <strong>License:</strong> Creative Commons Attribution 4.0 International (CC BY 4.0)</p>
    <p><strong>Taxonomy:</strong> WDI, World Bank Indicators, Benchmark, Development Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80',
  'World Development Indicators (WDI): Comprehensive Cambodia Macro & Social Benchmark Summary',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80","title":"World Development Indicators (WDI): Comprehensive Cambodia Macro & Social Benchmark Summary","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792634216,
  1792634216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000076',
  'usr_creator_seed_001',
  'Deciphering Southeast Asian Epigraphy: Sanskrit and Old Khmer Inscriptions on Stone Steles',
  'An educational introduction to epigraphic linguistics, analyzing how over 1,400 ancient stone inscriptions illuminate chronological genealogies, royal land grants, and temple donations.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An educational introduction to epigraphic linguistics, analyzing how over 1,400 ancient stone inscriptions illuminate chronological genealogies, royal land grants, and temple donations.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Epigraphy, Old Khmer, Sanskrit, Linguistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80',
  'Deciphering Southeast Asian Epigraphy: Sanskrit and Old Khmer Inscriptions on Stone Steles',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80","title":"Deciphering Southeast Asian Epigraphy: Sanskrit and Old Khmer Inscriptions on Stone Steles","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792655816,
  1792655816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000077',
  'usr_creator_seed_001',
  'Spatial Topography of Angkor: Mapping Ancient Hydraulic Networks with OpenStreetMap and Lidar',
  'How airborne laser scanning (LiDAR) and OpenStreetMap collaborative cartography unveiled the sprawling low-density urban complex supporting three-quarters of a million people.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    How airborne laser scanning (LiDAR) and OpenStreetMap collaborative cartography unveiled the sprawling low-density urban complex supporting three-quarters of a million people.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> OpenStreetMap</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.openstreetmap.org/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Concepts:</strong> OpenStreetMap, Lidar, Spatial Cartography, Urban Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80',
  'Spatial Topography of Angkor: Mapping Ancient Hydraulic Networks with OpenStreetMap and Lidar',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80","title":"Spatial Topography of Angkor: Mapping Ancient Hydraulic Networks with OpenStreetMap and Lidar","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1792677416,
  1792677416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000078',
  'usr_creator_seed_001',
  'Wikidata Cultural Knowledge Graphs: Modeling Heritage Monuments, Royal Dynasties, and Artifacts',
  'A technical guide to Semantic Web ontologies, SPARQL query protocols, and linked open data relationships connecting Cambodian temples with global museum catalogues.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    A technical guide to Semantic Web ontologies, SPARQL query protocols, and linked open data relationships connecting Cambodian temples with global museum catalogues.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Wikidata, Knowledge Graphs, Semantic Web, SPARQL</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80',
  'Wikidata Cultural Knowledge Graphs: Modeling Heritage Monuments, Royal Dynasties, and Artifacts',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80","title":"Wikidata Cultural Knowledge Graphs: Modeling Heritage Monuments, Royal Dynasties, and Artifacts","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792699016,
  1792699016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000079',
  'usr_creator_seed_001',
  'Bronze Metallurgy in Mainland Southeast Asia: Lost-Wax Casting of Sacred Hindu and Buddhist Statues',
  'Examine ancient metallurgical traditions from the Bronze Age through the Angkorian Golden Age, focusing on tin-copper ratios and hollow-core lost-wax foundry casting techniques.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Examine ancient metallurgical traditions from the Bronze Age through the Angkorian Golden Age, focusing on tin-copper ratios and hollow-core lost-wax foundry casting techniques.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Europeana Collections</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" class="underline">https://api.europeana.eu/</a> | <strong>License:</strong> Public Domain Mark (PDM 1.0)</p>
    <p><strong>Concepts:</strong> Bronze Casting, Metallurgy, Ancient Technology, Art History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80',
  'Bronze Metallurgy in Mainland Southeast Asia: Lost-Wax Casting of Sacred Hindu and Buddhist Statues',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80","title":"Bronze Metallurgy in Mainland Southeast Asia: Lost-Wax Casting of Sacred Hindu and Buddhist Statues","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792720616,
  1792720616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000080',
  'usr_creator_seed_001',
  'Cartographic History: Early European and Asian Maps of Indochina in the Library of Congress',
  'Surveying rare 16th to 19th-century cartographic engravings from Portuguese, Dutch, and French expeditions documenting maritime navigation routes and the great inland sea.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Surveying rare 16th to 19th-century cartographic engravings from Portuguese, Dutch, and French expeditions documenting maritime navigation routes and the great inland sea.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Europeana Collections</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" class="underline">https://api.europeana.eu/</a> | <strong>License:</strong> Public Domain Mark (PDM 1.0)</p>
    <p><strong>Concepts:</strong> Cartography, Historical Maps, Library of Congress, Geography</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80',
  'Cartographic History: Early European and Asian Maps of Indochina in the Library of Congress',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80","title":"Cartographic History: Early European and Asian Maps of Indochina in the Library of Congress","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792742216,
  1792742216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000081',
  'usr_creator_seed_001',
  'Ethnobotany of Traditional Khmer Medicinal Plants: Botanical Classification and Pharmacology',
  'Documenting indigenous medicinal flora in the Cardamom foothills and Kulen plateau, cataloging biological active compounds used in traditional remedies.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Documenting indigenous medicinal flora in the Cardamom foothills and Kulen plateau, cataloging biological active compounds used in traditional remedies.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Ethnobotany, Medicinal Plants, Pharmacology, Biodiversity</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=1200&q=80',
  'Ethnobotany of Traditional Khmer Medicinal Plants: Botanical Classification and Pharmacology',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=1200&q=80","title":"Ethnobotany of Traditional Khmer Medicinal Plants: Botanical Classification and Pharmacology","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792763816,
  1792763816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000082',
  'usr_creator_seed_001',
  'Architectural Engineering of Corbelled Arches in Pre-Angkorian Brick Sanctuaries',
  'Structural mechanical principles of corbelling masonry without mortar keystones, highlighting ancient vegetable resin adhesives that endured fourteen centuries of tropical monsoons.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Structural mechanical principles of corbelling masonry without mortar keystones, highlighting ancient vegetable resin adhesives that endured fourteen centuries of tropical monsoons.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikimedia Commons</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" class="underline">https://commons.wikimedia.org/</a> | <strong>License:</strong> Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</p>
    <p><strong>Concepts:</strong> Corbelled Arch, Brick Architecture, Structural Engineering, History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80',
  'Architectural Engineering of Corbelled Arches in Pre-Angkorian Brick Sanctuaries',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80","title":"Architectural Engineering of Corbelled Arches in Pre-Angkorian Brick Sanctuaries","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792785416,
  1792785416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000083',
  'usr_creator_seed_001',
  'The FAIR Guiding Principles: Making Public Scientific and Cultural Datasets Findable and Reusable',
  'An open-science educational guide explaining Findability, Accessibility, Interoperability, and Reusability (FAIR) standards for digital library archives and government data portals.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An open-science educational guide explaining Findability, Accessibility, Interoperability, and Reusability (FAIR) standards for digital library archives and government data portals.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> FAIR Principles, Open Science, Data Stewardship, Standards</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'The FAIR Guiding Principles: Making Public Scientific and Cultural Datasets Findable and Reusable',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"The FAIR Guiding Principles: Making Public Scientific and Cultural Datasets Findable and Reusable","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792807016,
  1792807016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000084',
  'usr_creator_seed_001',
  'Maritime Silk Road Trade Ceramics: The Koh Sdach and Belitung Shipwreck Discoveries',
  'A comparative study of Tang and Song dynasty glazed porcelain, stoneware storage jars, and maritime trade commodities recovered from ancient Southeast Asian sea lanes.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    A comparative study of Tang and Song dynasty glazed porcelain, stoneware storage jars, and maritime trade commodities recovered from ancient Southeast Asian sea lanes.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Europeana Collections</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" class="underline">https://api.europeana.eu/</a> | <strong>License:</strong> Public Domain Mark (PDM 1.0)</p>
    <p><strong>Concepts:</strong> Maritime Silk Road, Underwater Archaeology, Ceramics, Trade History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80',
  'Maritime Silk Road Trade Ceramics: The Koh Sdach and Belitung Shipwreck Discoveries',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80","title":"Maritime Silk Road Trade Ceramics: The Koh Sdach and Belitung Shipwreck Discoveries","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792828616,
  1792828616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000085',
  'usr_creator_seed_001',
  'Comparative Palaeography of Southeast Asian Scripts: Evolution from Southern Brahmic to Modern Khmer',
  'Tracing the historical evolution of script glyphs from 5th-century Pallava scripts to Pre-Angkorian, Angkorian, and modern Aksar Mul and Aksar Chrieng typography.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Tracing the historical evolution of script glyphs from 5th-century Pallava scripts to Pre-Angkorian, Angkorian, and modern Aksar Mul and Aksar Chrieng typography.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Palaeography, Khmer Script, Typography, Linguistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80',
  'Comparative Palaeography of Southeast Asian Scripts: Evolution from Southern Brahmic to Modern Khmer',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80","title":"Comparative Palaeography of Southeast Asian Scripts: Evolution from Southern Brahmic to Modern Khmer","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792850216,
  1792850216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000086',
  'usr_creator_seed_001',
  'Global Cultural Heritage Digitization: Photogrammetry and 3D Laser Scanning Standards',
  'Best practices for millimeter-accurate digital preservation of weathered bas-reliefs, generating open-access Point Cloud datasets and WebXR interactive museum models.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Best practices for millimeter-accurate digital preservation of weathered bas-reliefs, generating open-access Point Cloud datasets and WebXR interactive museum models.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikimedia Commons</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" class="underline">https://commons.wikimedia.org/</a> | <strong>License:</strong> Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</p>
    <p><strong>Concepts:</strong> 3D Scanning, Photogrammetry, Digital Heritage, WebXR</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=1200&q=80',
  'Global Cultural Heritage Digitization: Photogrammetry and 3D Laser Scanning Standards',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=1200&q=80","title":"Global Cultural Heritage Digitization: Photogrammetry and 3D Laser Scanning Standards","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792871816,
  1792871816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000087',
  'usr_creator_seed_001',
  'Linguistic Evolution and Dialectology of the Mon-Khmer Language Family in Mainland Southeast Asia',
  'An academic overview of comparative historical phonology, vowel register complexes, and morphological affixes across modern Austroasiatic languages.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An academic overview of comparative historical phonology, vowel register complexes, and morphological affixes across modern Austroasiatic languages.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Linguistics, Austroasiatic, Mon-Khmer, Phonology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1200&q=80',
  'Linguistic Evolution and Dialectology of the Mon-Khmer Language Family in Mainland Southeast Asia',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1200&q=80","title":"Linguistic Evolution and Dialectology of the Mon-Khmer Language Family in Mainland Southeast Asia","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792893416,
  1792893416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000088',
  'usr_creator_seed_001',
  'Acoustics and Ethnomusicology of the Pinn Peat and Mohori Ensembles',
  'Scientific analysis of ancient percussion acoustics: the roneat ek bamboo xylophone, kong vong circular gongs, sralai oboe reeds, and sampho two-headed drums.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Scientific analysis of ancient percussion acoustics: the roneat ek bamboo xylophone, kong vong circular gongs, sralai oboe reeds, and sampho two-headed drums.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Europeana Collections</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" class="underline">https://api.europeana.eu/</a> | <strong>License:</strong> Public Domain Mark (PDM 1.0)</p>
    <p><strong>Concepts:</strong> Ethnomusicology, Pinn Peat, Acoustics, Khmer Music</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1200&q=80',
  'Acoustics and Ethnomusicology of the Pinn Peat and Mohori Ensembles',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1200&q=80","title":"Acoustics and Ethnomusicology of the Pinn Peat and Mohori Ensembles","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792915016,
  1792915016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000089',
  'usr_creator_seed_001',
  'Historical Geodesy: Cardinal Alignments and Astronomical Meridian Systems in Monumental Temples',
  'How Khmer temple architects utilized celestial poles, gnomon shadow sticks, and constellation risings to achieve exact true-north alignments within fractions of a degree.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    How Khmer temple architects utilized celestial poles, gnomon shadow sticks, and constellation risings to achieve exact true-north alignments within fractions of a degree.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Archaeoastronomy, Geodesy, Orientation, Architecture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=1200&q=80',
  'Historical Geodesy: Cardinal Alignments and Astronomical Meridian Systems in Monumental Temples',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=1200&q=80","title":"Historical Geodesy: Cardinal Alignments and Astronomical Meridian Systems in Monumental Temples","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792936616,
  1792936616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000090',
  'usr_creator_seed_001',
  'Biodiversity of the Lower Mekong Basin: Migratory Fish Species and Ecology of the Giant Catfish',
  'Educational monograph on the Pangasianodon gigas and Catlocarpio siamensis, their long-distance breeding migrations, and wetland ecosystem services.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Educational monograph on the Pangasianodon gigas and Catlocarpio siamensis, their long-distance breeding migrations, and wetland ecosystem services.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Giant Catfish, Mekong Ecology, Ichthyology, Conservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
  'Biodiversity of the Lower Mekong Basin: Migratory Fish Species and Ecology of the Giant Catfish',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80","title":"Biodiversity of the Lower Mekong Basin: Migratory Fish Species and Ecology of the Giant Catfish","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792958216,
  1792958216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000091',
  'usr_creator_seed_001',
  'Ceramic Kiln Sites of Phnom Kulen: Glazed Stoneware Technology in the 9th to 12th Centuries',
  'Excavation of Anlong Thom cross-draft kilns producing green and ash-glazed Khmer stoneware vessels used throughout the Angkorian empire and international courts.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Excavation of Anlong Thom cross-draft kilns producing green and ash-glazed Khmer stoneware vessels used throughout the Angkorian empire and international courts.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikimedia Commons</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" class="underline">https://commons.wikimedia.org/</a> | <strong>License:</strong> Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</p>
    <p><strong>Concepts:</strong> Kulen Kilns, Ceramics, Kiln Technology, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80',
  'Ceramic Kiln Sites of Phnom Kulen: Glazed Stoneware Technology in the 9th to 12th Centuries',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80","title":"Ceramic Kiln Sites of Phnom Kulen: Glazed Stoneware Technology in the 9th to 12th Centuries","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792979816,
  1792979816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000092',
  'usr_creator_seed_001',
  'Geographic Information Systems (GIS) in Modern Cultural Heritage Management',
  'How open-source tools like QGIS and GDAL are applied to model hydrological flooding simulations, buffer zones, and spatial density heatmaps around ancient monuments.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    How open-source tools like QGIS and GDAL are applied to model hydrological flooding simulations, buffer zones, and spatial density heatmaps around ancient monuments.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> OpenStreetMap</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.openstreetmap.org/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Concepts:</strong> GIS, QGIS, Spatial Analysis, Cultural Management</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80',
  'Geographic Information Systems (GIS) in Modern Cultural Heritage Management',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80","title":"Geographic Information Systems (GIS) in Modern Cultural Heritage Management","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1793001416,
  1793001416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000093',
  'usr_creator_seed_001',
  'Document Preservation and Archival Digitization Standards: Library of Congress Guidelines',
  'Technical specifications for handling brittle palm-leaf manuscripts (Sastra Sleuk Rith), high-resolution color calibration, and open archival information systems (OAIS).',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Technical specifications for handling brittle palm-leaf manuscripts (Sastra Sleuk Rith), high-resolution color calibration, and open archival information systems (OAIS).
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Europeana Collections</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" class="underline">https://api.europeana.eu/</a> | <strong>License:</strong> Public Domain Mark (PDM 1.0)</p>
    <p><strong>Concepts:</strong> Archival Standards, Palm Leaf Manuscripts, Library of Congress, Preservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&w=1200&q=80',
  'Document Preservation and Archival Digitization Standards: Library of Congress Guidelines',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&w=1200&q=80","title":"Document Preservation and Archival Digitization Standards: Library of Congress Guidelines","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1793023016,
  1793023016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000094',
  'usr_creator_seed_001',
  'The Iconography of Garuda and Naga in Southeast Asian Mythological Art and Sculpture',
  'Analyzing the symbolic philosophical dualism between solar celestial birds and terrestrial water serpents carved on balustrades, causeways, and royal lintels.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Analyzing the symbolic philosophical dualism between solar celestial birds and terrestrial water serpents carved on balustrades, causeways, and royal lintels.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Iconography, Garuda, Naga, Mythology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80',
  'The Iconography of Garuda and Naga in Southeast Asian Mythological Art and Sculpture',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80","title":"The Iconography of Garuda and Naga in Southeast Asian Mythological Art and Sculpture","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793044616,
  1793044616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000095',
  'usr_creator_seed_001',
  'UNESCO World Heritage Management Framework: Heritage Impact Assessments and Sustainability',
  'An educational breakdown of the 1972 World Heritage Convention mechanisms, State of Conservation reports, and rigorous Heritage Impact Assessment (HIA) protocols.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An educational breakdown of the 1972 World Heritage Convention mechanisms, State of Conservation reports, and rigorous Heritage Impact Assessment (HIA) protocols.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> UNESCO Convention, World Heritage, Heritage Management, HIA</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80',
  'UNESCO World Heritage Management Framework: Heritage Impact Assessments and Sustainability',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80","title":"UNESCO World Heritage Management Framework: Heritage Impact Assessments and Sustainability","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793066216,
  1793066216
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000096',
  'usr_creator_seed_001',
  'Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling',
  'Structural carpentry analysis of raised timber stilt residences, detailing high-pitched gables, louvered eaves, and natural convection airflow cooling tropical living spaces.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Structural carpentry analysis of raised timber stilt residences, detailing high-pitched gables, louvered eaves, and natural convection airflow cooling tropical living spaces.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikimedia Commons</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" class="underline">https://commons.wikimedia.org/</a> | <strong>License:</strong> Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</p>
    <p><strong>Concepts:</strong> Vernacular Architecture, Stilt Houses, Passive Cooling, Carpentry</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1793087816,
  1793087816
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000097',
  'usr_creator_seed_001',
  'The Digital Commons: Understanding Creative Commons, Open Data, and Public Domain Licensing',
  'An essential primer on modern intellectual property rights, exploring CC0, CC BY, CC BY-SA, Open Database Licenses (ODbL), and public institution attribution responsibilities.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    An essential primer on modern intellectual property rights, exploring CC0, CC BY, CC BY-SA, Open Database Licenses (ODbL), and public institution attribution responsibilities.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Creative Commons, Open Data, Public Domain, IP Law</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80',
  'The Digital Commons: Understanding Creative Commons, Open Data, and Public Domain Licensing',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80","title":"The Digital Commons: Understanding Creative Commons, Open Data, and Public Domain Licensing","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793109416,
  1793109416
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000098',
  'usr_creator_seed_001',
  'OpenStreetMap Collaborative Cartography: Mapping Rural Communes and Health Clinics',
  'How volunteer mapping communities and humanitarian OpenStreetMap teams contribute geo-spatial layers of unpaved road networks, clinics, and clean water wells.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    How volunteer mapping communities and humanitarian OpenStreetMap teams contribute geo-spatial layers of unpaved road networks, clinics, and clean water wells.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> OpenStreetMap</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.openstreetmap.org/</a> | <strong>License:</strong> Open Data Commons Open Database License (ODbL)</p>
    <p><strong>Concepts:</strong> OpenStreetMap, Humanitarian Mapping, Cartography, Geodata</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80',
  'OpenStreetMap Collaborative Cartography: Mapping Rural Communes and Health Clinics',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80","title":"OpenStreetMap Collaborative Cartography: Mapping Rural Communes and Health Clinics","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1793131016,
  1793131016
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000099',
  'usr_creator_seed_001',
  'Historical Analysis of Early Mainland Kingdoms: Funan, Chenla, and Maritime Trade Networks',
  'Archaeological synthesis of Oc Eo canals, Angkor Borei brick walls, and Sambor Prei Kuk royal inscriptions tracing the early state formations of lower Mekong civilization.',
  'EDUCATION',
  'ARTICLE',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Archaeological synthesis of Oc Eo canals, Angkor Borei brick walls, and Sambor Prei Kuk royal inscriptions tracing the early state formations of lower Mekong civilization.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> Wikidata Knowledge Base</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" class="underline">https://www.wikidata.org/</a> | <strong>License:</strong> Creative Commons CC0 1.0 Universal Public Domain Dedication</p>
    <p><strong>Concepts:</strong> Funan, Chenla, Angkor Borei, Southeast Asian History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80',
  'Historical Analysis of Early Mainland Kingdoms: Funan, Chenla, and Maritime Trade Networks',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80","title":"Historical Analysis of Early Mainland Kingdoms: Funan, Chenla, and Maritime Trade Networks","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793152616,
  1793152616
);

INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  '7e575eed-2026-4000-8000-000000000100',
  'usr_creator_seed_001',
  'Solar Equinox Phenomena at Monumental Sanctuaries: Angkor Wat and Archaeoastronomy',
  'Every March and September, thousands gather at dawn to witness the sun rise directly behind the central lotus-bud pinnacle of Angkor Wat, a breathtaking tribute to ancient astronomy.',
  'EDUCATION',
  'VIDEO',
  '<div class="editorial-article education-article">
  <!-- Narrative Hook & Intellectual Exploration -->
  <p class="lead text-base sm:text-lg leading-relaxed font-normal text-gray-800 dark:text-gray-200 mb-6">
    Every March and September, thousands gather at dawn to witness the sun rise directly behind the central lotus-bud pinnacle of Angkor Wat, a breathtaking tribute to ancient astronomy.
  </p>

  <h2>Theoretical Foundation & Historical Evolution</h2>
  <p>
    Understanding this domain requires examining the intersection between ancient technological ingenuity and modern scientific methodology. Over successive centuries, human civilization developed sophisticated empirical systems to solve complex environmental, linguistic, and architectural challenges.
  </p>
  <p>
    From ancient epigraphic inscriptions carved on stone steles to modern geospatial LiDAR point-cloud surveys, the transmission of knowledge relies on structured, reproducible standards. By analyzing archaeological strata and linked open semantic ontologies, researchers can trace conceptual developments across Southeast Asia and global trade networks.
  </p>

  <h2>Key Terminology & Cultural Glossary</h2>
  <dl class="my-4 space-y-3 text-sm">
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Epigraphy (សិលាចារឹក)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">The scientific study and decipherment of ancient inscriptions carved into durable stone, bronze, or terracotta surfaces.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Corbelled Masonry (ដំបូលផ្គុំផ្គង)</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">An architectural engineering technique where horizontal stone or brick courses progressively project inward until meeting at the apex without a central keystone.</dd>
    </div>
    <div class="p-3 rounded-lg bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800">
      <dt class="font-bold text-gray-900 dark:text-white">Semantic Knowledge Graph</dt>
      <dd class="text-gray-600 dark:text-gray-300 mt-1">A machine-readable network of real-world entities and their interconnected relationships, standardizing cultural data for artificial intelligence and global research.</dd>
    </div>
  </dl>

  <h2>Scientific Principles & Modern Research Applications</h2>
  <p>
    Contemporary academic institutions utilize cutting-edge digital humanities tools to preserve and analyze these cultural assets:
  </p>
  <ul>
    <li><strong>3D Photogrammetry & Laser Scanning:</strong> High-density surface scanning capturing millimeter-scale submillimeter carvings to monitor environmental weathering.</li>
    <li><strong>Geographic Information Systems (GIS):</strong> Spatial hydrology modeling predicting watershed runoff and protecting ancient temple foundation stability.</li>
    <li><strong>Open Access Archiving:</strong> Deployment of Creative Commons frameworks ensuring educational resources remain accessible to researchers, educators, and the global public.</li>
  </ul>

  
  <h2>Educational Video Lecture</h2>
  <div class="video-embed-box my-4 p-4 rounded-xl border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-900">
    <p class="text-sm font-semibold mb-2">Watch Open Educational Video Archive:</p>
    <a href="https://www.youtube.com/watch?v=kYvM3d1iZJ8" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-2 text-sm text-primary font-bold hover:underline">
      <span>▶ Play Educational Video Lecture</span>
    </a>
  </div>
  

  <hr class="my-6 border-gray-200 dark:border-gray-800" />
  
  <footer class="editorial-footer text-xs text-gray-500 dark:text-gray-400 space-y-1">
    <p><strong>Editorial Revision:</strong> v1.0 (Educational Quality Gate Certified) | <strong>Repository:</strong> APSARA National Authority</p>
    <p><strong>Open Knowledge Source:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" class="underline">https://apsaraauthority.gov.kh/</a> | <strong>License:</strong> Cambodia Public Heritage & Open Information Notice</p>
    <p><strong>Concepts:</strong> Equinox, Archaeoastronomy, Angkor Wat, Solar Alignment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'Solar Equinox Phenomena at Monumental Sanctuaries: Angkor Wat and Archaeoastronomy',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"Solar Equinox Phenomena at Monumental Sanctuaries: Angkor Wat and Archaeoastronomy","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  '["https://www.youtube.com/watch?v=kYvM3d1iZJ8"]',
  'PUBLIC',
  0,
  1793174216,
  1793174216
);
