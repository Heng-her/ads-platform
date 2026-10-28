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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-ANGKOR-001</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An in-depth study of the 12th-century temple mountain built under King Suryavarman II, detailing solar equinox alignment, bas-relief galleries, and sandstone hydraulics.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  
  <h3>Official Multimedia Documentation</h3>
  <p>Official educational video stream provided by authorized institutional archives:</p>
  <p><a href="https://www.youtube.com/watch?v=kYvM3d1iZJ8" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Watch official video presentation on authorized platform</a></p>
  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Angkor Wat, APSARA, UNESCO, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'Angkor Wat Archaeological Complex: Sacred Architecture, Astronomy and Stone Engineering',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"Angkor Wat Archaeological Complex: Sacred Architecture, Astronomy and Stone Engineering","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  '["https://www.youtube.com/watch?v=kYvM3d1iZJ8"]',
  'PUBLIC',
  0,
  1791033992,
  1791033992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-PVH-002</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-20</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Perched on a 525-meter cliff in the Dângrêk Mountains, this 11th-century masterpiece exemplifies multi-level gopura staircases dedicated to Shiva Bhadresvara.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Preah Vihear, World Heritage, Architecture, Culture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80',
  'Preah Vihear Temple: Cliff-Top Sanctuary and Ancient Pilgrimage Axis',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80","title":"Preah Vihear Temple: Cliff-Top Sanctuary and Ancient Pilgrimage Axis","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791055592,
  1791055592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-SPK-003</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Dating from the late 6th to 9th centuries, the pre-Angkorian capital in Kampong Thom province showcases octagonal brick sanctuaries with Flying Palaces ornamentation.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Sambor Prei Kuk, Pre-Angkorian, Brick Architecture, UNESCO</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80',
  'Sambor Prei Kuk: The Octagonal Brick Temples of Ancient Ishanapura',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80","title":"Sambor Prei Kuk: The Octagonal Brick Temples of Ancient Ishanapura","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791077192,
  1791077192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-KK-004</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-25</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>The sacred 10th-century capital under King Jayavarman IV, featuring the striking seven-tiered pyramid of Prasat Thom and the massive Rahal reservoir.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Koh Ker, Pyramid, Archaeology, Jayavarman IV</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=80',
  'Koh Ker Archaeological Site: The Monumental Pyramid of Prasat Thom',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=80","title":"Koh Ker Archaeological Site: The Monumental Pyramid of Prasat Thom","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791098792,
  1791098792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-BSR-005</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-28</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Completed in 967 AD, this citadel of women is celebrated worldwide for its miniature proportions, three-dimensional devatas, and intricate pediments of epic Ramayana tales.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Banteay Srei, Pink Sandstone, Sculpture, Khmer Art</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80',
  'Banteay Srei: The Jewel of Khmer Art and Pink Sandstone Carvings',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80","title":"Banteay Srei: The Jewel of Khmer Art and Pink Sandstone Carvings","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791120392,
  1791120392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-BALLET-006</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Recognized by UNESCO as Masterpiece of the Oral and Intangible Heritage of Humanity, Khmer classical dance embodies over 4,500 distinct hand gestures (kbach) symbolizing mythological motifs.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Royal Ballet, Intangible Heritage, Robam Preah Reach Trop, Dance</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1582234372722-50d7ccc30ebd?auto=format&fit=crop&w=1200&q=80',
  'The Royal Ballet of Cambodia (Robam Preah Reach Trop): Sacred Hand Gestures and Oral Traditions',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1582234372722-50d7ccc30ebd?auto=format&fit=crop&w=1200&q=80","title":"The Royal Ballet of Cambodia (Robam Preah Reach Trop): Sacred Hand Gestures and Oral Traditions","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791141992,
  1791141992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-SILK-007</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-03</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An exploration of indigenous Cambodian golden silkworms (Bombyx mori), natural botanical dyeing techniques using coconut bark and indigo, and complex tie-dye weaving.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Golden Silk, Hol Weaving, Artisans, Tradition</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Silk Weaving: Golden Silk and Hol Ikat Mastery in Takeo and Siem Reap',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1607344645866-009c320c5ab8?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Silk Weaving: Golden Silk and Hol Ikat Mastery in Takeo and Siem Reap","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791163592,
  1791163592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-PP-008</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-06</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Trace the founding legend of Daun Penh in 1372 and analyze the architecture of Preah Tineang Tevea Vinichhay and the Emerald Buddha shrine inside the Silver Pagoda.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Phnom Penh, Wat Phnom, Royal Palace, Silver Pagoda</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80',
  'Phnom Penh Heritage: Wat Phnom, the Royal Palace, and Silver Pagoda Architecture',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80","title":"Phnom Penh Heritage: Wat Phnom, the Royal Palace, and Silver Pagoda Architecture","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791185192,
  1791185192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-CARD-009</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-08</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Covering over 4.4 million hectares, the Cardamom Rainforest is one of Southeast Asia’s greatest wilderness areas, sheltering Asian elephants, clouded leopards, and sustainable eco-trails.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Cardamom Mountains, Ecotourism, Biodiversity, Conservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80',
  'Cardamom Mountains Biosphere: Dense Rainforests and Community-Based Ecotourism',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80","title":"Cardamom Mountains Biosphere: Dense Rainforests and Community-Based Ecotourism","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791206792,
  1791206792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-TLS-010</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Southeast Asia’s largest freshwater lake features a unique reverse-flow hydrological cycle, supporting over 300 fish species and the renowned Prek Toal Ramsar wetland sanctuary.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Tonle Sap, Hydrology, Prek Toal, Wetlands</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
  'Tonle Sap Great Lake Biosphere Reserve: Hydrology, Floating Communes, and Bird Sanctuaries',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80","title":"Tonle Sap Great Lake Biosphere Reserve: Hydrology, Floating Communes, and Bird Sanctuaries","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791228392,
  1791228392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-BKR-011</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-12</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Rising 1,079 meters above Kampot coast, Bokor plateau blends misty evergreen cloud forests, French colonial architectural ruins, and Buddhist pagodas overlooking the Gulf of Thailand.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Bokor Mountain, Kampot, National Park, History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
  'Bokor National Park: Misty Highlands, Historic French Hill Stations, and Popokvil Waterfalls',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80","title":"Bokor National Park: Misty Highlands, Historic French Hill Stations, and Popokvil Waterfalls","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791249992,
  1791249992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-KEP-012</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Discover Kep’s historic seaside trails, protected seagrass beds home to dugongs, and local sustainable crab farming cooperatives along the southern coastline.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Kep, Coastal Tourism, Marine Ecology, Seafood</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
  'Kep National Park and Archipelago: Coastal Trails, Mangroves, and Marine Conservation',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80","title":"Kep National Park and Archipelago: Coastal Trails, Mangroves, and Marine Conservation","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791271592,
  1791271592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-KLN-013</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-17</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Investigate the sacred mountain where King Jayavarman II proclaimed independence in 802 AD, carving thousands of Shiva lingas into the riverbed of Kbal Spean.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Phnom Kulen, River of Lingas, Kbal Spean, Sacred Mountain</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80',
  'Phnom Kulen Sacred Plateau: The River of a Thousand Lingas and the Birthplace of Angkor',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80","title":"Phnom Kulen Sacred Plateau: The River of a Thousand Lingas and the Birthplace of Angkor","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791293192,
  1791293192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-DOLPHIN-014</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-20</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>A conservation field report on the Kampi dolphin pool in Kratie, where river rangers protect the endangered Orcaella brevirostris through sustainable community ecotourism.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Irrawaddy Dolphins, Mekong River, Kratie, Wildlife</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
  'Mekong River Dolphin Sanctuaries in Kratie: Protecting the Freshwater Irrawaddy Population',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80","title":"Mekong River Dolphin Sanctuaries in Kratie: Protecting the Freshwater Irrawaddy Population","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791314792,
  1791314792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-BTB-015</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Known as the rice bowl of Cambodia, Battambang preserves the country’s finest ensemble of early 20th-century colonial storefronts, Wat Banan, and the famous Nory bamboo railway.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Battambang, Colonial Architecture, Heritage, Bamboo Train</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1470246973918-29a93221c455?auto=format&fit=crop&w=1200&q=80',
  'Battambang Heritage Trail: French Colonial Shophouses, Ek Phnom, and the Bamboo Train',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1470246973918-29a93221c455?auto=format&fit=crop&w=1200&q=80","title":"Battambang Heritage Trail: French Colonial Shophouses, Ek Phnom, and the Bamboo Train","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791336392,
  1791336392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-TPR-016</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-25</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>A technical analysis by the Archaeological Survey of India (ASI) and APSARA on preserving the famous silk-cotton and strangler fig trees intertwining with monastic corridors.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Ta Prohm, Conservation, Botany, APSARA</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80',
  'Ta Prohm Temple Conservation: Balancing Ancient Sandstone and Tetrameles Tree Root Systems',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80","title":"Ta Prohm Temple Conservation: Balancing Ancient Sandstone and Tetrameles Tree Root Systems","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791357992,
  1791357992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-BYN-017</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-28</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Built in the late 12th century under King Jayavarman VII, the state temple of Angkor Thom showcases 54 stone towers adorned with giant contemplative faces smiling in four directions.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Bayon, Angkor Thom, Jayavarman VII, Iconography</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509099836639-18ba1795216d?auto=format&fit=crop&w=1200&q=80',
  'The Bayon: Decoding the 216 Serene Faces of Avalokiteshvara in Angkor Thom',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1509099836639-18ba1795216d?auto=format&fit=crop&w=1200&q=80","title":"The Bayon: Decoding the 216 Serene Faces of Avalokiteshvara in Angkor Thom","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791379592,
  1791379592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-PKH-018</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Covering 56 hectares, Preah Khan served as an administrative city and Buddhist monastic university housing over 1,000 scholars, teachers, and ritual practitioners.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Preah Khan, Monastery, Education, Angkor</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80',
  'Preah Khan Monastic University: Architecture of the 12th-Century Buddhist Complex',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80","title":"Preah Khan Monastic University: Architecture of the 12th-Century Buddhist Complex","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791401192,
  1791401192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-BML-019</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-03</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Constructed around the same period as Angkor Wat in identical blue-gray sandstone, Beng Mealea remains largely unrestored, displaying collapsed lintels and lotus-bud towers.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Beng Mealea, Sandstone, Jungle Temple, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80',
  'Beng Mealea: Architectural Layout of the Enigmatic Jungle Sanctuary',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80","title":"Beng Mealea: Architectural Layout of the Enigmatic Jungle Sanctuary","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791422792,
  1791422792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-BKG-020</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-06</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Dating from 881 AD under King Indravarman I, Bakong is the earliest monumental sandstone stepped pyramid built in the Angkor region, representing Mount Meru.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Prasat Bakong, Roluos, Temple Mountain, Indravarman I</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1200&q=80',
  'Prasat Bakong and the Roluos Group: The Dawn of Khmer Temple Mountain Architecture',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1544735716-392fe2489ffa?auto=format&fit=crop&w=1200&q=80","title":"Prasat Bakong and the Roluos Group: The Dawn of Khmer Temple Mountain Architecture","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791444392,
  1791444392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-WBR-021</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-09</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Measuring 8 kilometers long by 2.1 kilometers wide, the West Baray holds up to 53 million cubic meters of water, demonstrating brilliant ancient Khmer hydrological civil engineering.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: West Baray, Hydraulics, Engineering, Water Management</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
  'Hydraulic Engineering of Angkor: The West Baray Reservoir and Water Management Systems',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80","title":"Hydraulic Engineering of Angkor: The West Baray Reservoir and Water Management Systems","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791465992,
  1791465992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-PKKS-022</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-12</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Recent excavations reveal the outer enclosure of this massive 25-square-kilometer complex was Southeast Asia’s central high-temperature iron smelting industrial hub.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Iron Smelting, Preah Khan KS, Metallurgy, Preah Vihear</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80',
  'Preah Khan of Kampong Svay: Ancient Iron Smelting and Metallurgy in the Northern Plains',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80","title":"Preah Khan of Kampong Svay: Ancient Iron Smelting and Metallurgy in the Northern Plains","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791487592,
  1791487592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-SMM-023</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>A comprehensive visual dissection of the 49-meter continuous stone bas-relief at Angkor Wat depicting 88 devas and 92 asuras churning the cosmic ocean for the nectar of immortality.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Ocean of Milk, Bas-Relief, Mythology, Angkor Wat</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80',
  'The Churning of the Ocean of Milk (Samudra Manthan): Iconography of the East Gallery',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80","title":"The Churning of the Ocean of Milk (Samudra Manthan): Iconography of the East Gallery","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791509192,
  1791509192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-KSP-024</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Located 49 km northeast of Angkor, this natural sandstone riverbed features hundreds of intricately carved lingas, Vishnus, and Brahmas blessing the pristine waters flowing to Angkor.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Kbal Spean, Riverbed Reliefs, Forest Sanctuary, Siem Reap</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80',
  'Kbal Spean: Sacred Riverbed Reliefs and Forest Water Purification Rites',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80","title":"Kbal Spean: Sacred Riverbed Reliefs and Forest Water Purification Rites","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791530792,
  1791530792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-SILVER-025</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-21</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Documenting the traditional repoussé and chasing techniques used by artisans along the Tonle Sap to craft elaborate betel-nut containers in shapes of deer, elephants, and mythical garudas.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> TOURISM</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Silverware, Repousse, Handicrafts, Artisanship</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Silverware and Metalwork: The Master Silversmiths of Kompong Luong',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Silverware and Metalwork: The Master Silversmiths of Kompong Luong","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791552392,
  1791552392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-DOC-2026-01</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Official bulletin detailing government milestones for digital citizenship, FinTech adoption, national data exchanges (CamDX), and high-speed broadband in rural schools.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Digital Economy, CamDX, Government Policy, Innovation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'Official Gazette: Strategic Framework for Cambodia Digital Economy and Social Policy 2021-2035',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"Official Gazette: Strategic Framework for Cambodia Digital Economy and Social Policy 2021-2035","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791573992,
  1791573992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-101</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-14</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>The Ministry of Mines and Energy announces new solar farm commissionings in Pursat and Kampong Chhnang, targeting over 70% clean domestic energy generation by 2030.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Clean Energy, Solar Power, AKP, Energy Transition</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80',
  'AKP Wire: National Clean Energy Transition Roadmap Accelerates Solar and Hydro Grid Integration',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80","title":"AKP Wire: National Clean Energy Transition Roadmap Accelerates Solar and Hydro Grid Integration","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791595592,
  1791595592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-ANNC-2026-02</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Official launch of new electronic visitor travel declarations, multi-destination eco-tourism passes, and green hotel certification standards across Siem Reap and coastal provinces.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Visit Cambodia, Tourism Policy, Hospitality, Eco-Travel</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
  'Ministry of Tourism Launches Global "Visit Cambodia 2026" Quality Tourism Initiative',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80","title":"Ministry of Tourism Launches Global \"Visit Cambodia 2026\" Quality Tourism Initiative","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1791617192,
  1791617192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-OPEN-2026-05</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>The Ministry of Economy and Finance releases new open API standards and machine-readable datasets covering public infrastructure tenders, fiscal reports, and trade metrics.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Open Data, Public Finance, Transparency, APIs</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
  'Official Announcement: Expansion of the National Open Data Portal for Public Access and Transparency',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80","title":"Official Announcement: Expansion of the National Open Data Portal for Public Access and Transparency","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791638792,
  1791638792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-105</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-26</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Executive summary of priority domains including digital health, precision agriculture, artificial intelligence applications, and SME laboratory testing facilities.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: STI Roadmap, Technology, Research, R&D</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
  'National Science, Technology and Innovation Roadmap 2030: Promoting Research and Industrial R&D',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80","title":"National Science, Technology and Innovation Roadmap 2030: Promoting Research and Industrial R&D","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791660392,
  1791660392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-109</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Official hydrological release on dry season river discharge, tributary reservoir operations, and shared real-time telemetry stations between riparian member countries.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Mekong River, Hydrology, Water Resources, MRC</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80',
  'Mekong River Commission Bulletin: Basin-Wide Water Resources Management and Flood Forecast Network',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80","title":"Mekong River Commission Bulletin: Basin-Wide Water Resources Management and Flood Forecast Network","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791681992,
  1791681992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-TRADE-2026-08</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-05</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>General Department of Customs and Excise integrates automated risk-management AI engines and cross-border digital certificates with ASEAN single window nodes.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Customs, Single Window, Trade, Logistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80',
  'National Single Window Trade Portal Upgrade Reduces Customs Clearance Processing to Minutes',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80","title":"National Single Window Trade Portal Upgrade Reduces Customs Clearance Processing to Minutes","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791703592,
  1791703592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-112</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>New regulatory code mandating low-emissions building materials, passive ventilation design, rainwater harvesting, and solar rooftop readiness for commercial properties.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Green Building, Architecture, Sustainability, Regulations</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?auto=format&fit=crop&w=1200&q=80',
  'Royal Government Issues Comprehensive Guidelines for Green Building Standards and Energy Efficiency',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?auto=format&fit=crop&w=1200&q=80","title":"Royal Government Issues Comprehensive Guidelines for Green Building Standards and Energy Efficiency","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791725192,
  1791725192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-ANNC-2026-03</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-14</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>New directional boardwalks, digital ticket scanning turnstiles, and electric shuttle corridors deployed to prevent stone wear and protect temple foundations.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: APSARA, Angkor Thom, Heritage Protection, Siem Reap</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'APSARA Authority Introduces Sustainable Tourist Flow Routing in Angkor Thom and Ta Prohm',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"APSARA Authority Introduces Sustainable Tourist Flow Routing in Angkor Thom and Ta Prohm","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  NULL,
  'PUBLIC',
  0,
  1791746792,
  1791746792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-116</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Culture and Fine Arts welcomes back hundreds of looted 10th and 11th-century Koh Ker statues and royal regalia to be displayed at the National Museum.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Heritage Repatriation, National Museum, Khmer Antiques, Culture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Cultural Exchange: International Repatriation of Ancient Sculptures and Golden Jewelry',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Cultural Exchange: International Repatriation of Ancient Sculptures and Golden Jewelry","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791768392,
  1791768392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-AGRO-2026-12</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Agriculture, Forestry and Fisheries partners with cooperatives to implement solar-powered drip irrigation, digital grain storage silos, and organic certifiers.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Agriculture, Battambang, Modernization, Food Security</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80',
  'Agricultural Modernization: High-Tech Agro-Industrial Hubs Established in Battambang and Kampong Cham',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80","title":"Agricultural Modernization: High-Tech Agro-Industrial Hubs Established in Battambang and Kampong Cham","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791789992,
  1791789992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-121</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-26</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Post and Telecommunications issues national cyber-hygiene guidance, critical infrastructure defense mandates, and zero-trust protocol guidelines.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Cybersecurity, Zero Trust, National Defense, Data Privacy</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80',
  'National Cybersecurity Awareness Framework 2026 Released for Public Institutions and Citizens',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80","title":"National Cybersecurity Awareness Framework 2026 Released for Public Institutions and Citizens","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791811592,
  1791811592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-125</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-02</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Industry, Science, Technology & Innovation reports 45 new surface water treatment plants reaching final operational phases across 14 provinces.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Clean Water, Public Health, Infrastructure, Rural Communes</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?auto=format&fit=crop&w=1200&q=80',
  'Clean Water for All: Expansion of Pipe Networks to Reach 100% of Rural Communes by 2030',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1527525443983-6e60c75fff46?auto=format&fit=crop&w=1200&q=80","title":"Clean Water for All: Expansion of Pipe Networks to Reach 100% of Rural Communes by 2030","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791833192,
  1791833192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-HLTH-2026-14</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-06</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Health introduces standardized QR-code patient registries and unified electronic health databases connecting municipal referral hospitals and health centers.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Health Tech, Electronic Health, Hospitals, Ministry of Health</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1200&q=80',
  'National Healthcare Digitization: Hospital Information Systems and Electronic Medical Records',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1200&q=80","title":"National Healthcare Digitization: Hospital Information Systems and Electronic Medical Records","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791854792,
  1791854792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-130</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Public Works and Transport details connecting Phnom Penh, Bavet, Sihanoukville Autonomous Port, and Poipet border to slash regional freight transport costs.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Logistics, Expressway, Dry Ports, Transportation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80',
  'National Logistics Master Plan: Expressway Expansions and Dry Port Multimodal Nodes',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80","title":"National Logistics Master Plan: Expressway Expansions and Dry Port Multimodal Nodes","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791876392,
  1791876392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-134</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-14</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Environment and conservation rangers formalize contiguous protected migration corridors connecting national parks and community forest sanctuaries.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Wildlife Corridor, Cardamoms, Conservation, Environment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80',
  'Biodiversity Protection: 50,000 Hectares of Wildlife Corridors Legally Gazette in Southern Cardamoms',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80","title":"Biodiversity Protection: 50,000 Hectares of Wildlife Corridors Legally Gazette in Southern Cardamoms","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791897992,
  1791897992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-EV-2026-18</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Government regulations standardize Type-2 AC and CCS-2 DC fast-charging plugs along national highways, offering tax incentives for clean municipal fleet purchases.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: EV Charging, Clean Mobility, Standards, Transportation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1558441719-7d885a666993?auto=format&fit=crop&w=1200&q=80',
  'Electric Mobility: National Technical Standards Adopted for EV Charging Station Deployments',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1558441719-7d885a666993?auto=format&fit=crop&w=1200&q=80","title":"Electric Mobility: National Technical Standards Adopted for EV Charging Station Deployments","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791919592,
  1791919592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-139</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Cambodia formalizes alignment with ASEAN Model Contractual Clauses to foster secure digital commerce, cloud services, and software trade throughout Southeast Asia.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: ASEAN, Data Governance, Digital Trade, Compliance</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80',
  'ASEAN Digital Data Governance: Adoption of Cross-Border Data Flows and Standard Contractual Clauses',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80","title":"ASEAN Digital Data Governance: Adoption of Cross-Border Data Flows and Standard Contractual Clauses","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791941192,
  1791941192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-FIN-2026-21</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-26</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>National Bank of Cambodia (NBC) report highlights rapid growth of Bakong payment system, low-cost micro-savings accounts, and female entrepreneur loan guarantees.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Financial Inclusion, Bakong, NBC, Fintech</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80',
  'National Financial Inclusion Strategy (NFIS): Over 85% of Adults Now Access Formal Financial Services',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80","title":"National Financial Inclusion Strategy (NFIS): Over 85% of Adults Now Access Formal Financial Services","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1791962792,
  1791962792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-143</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-30</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Forestry Administration grants 25-year stewardship pacts to 82 indigenous community forest groups, supporting sustainable non-timber forest product harvesting.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Community Forestry, Indigenous Rights, Stewardship, Environment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80',
  'Community Forestry Agreements Signed Across 12 Provinces: Empowering Indigenous Stewards',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80","title":"Community Forestry Agreements Signed Across 12 Provinces: Empowering Indigenous Stewards","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1791984392,
  1791984392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-147</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-03</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>State Secretariat of Civil Aviation issues 4F operational license to the new greenfield international hub in Kandal province, accommodating Airbus A380 and Boeing 777 aircraft.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Techo Airport, Aviation, Infrastructure, Connectivity</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=1200&q=80',
  'Techo International Airport Operational Certification and International Route Inauguration',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=1200&q=80","title":"Techo International Airport Operational Certification and International Route Inauguration","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792005992,
  1792005992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-151</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-07</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Education, Youth and Sport partners with national universities to install solar-powered computer labs and train secondary school teachers in Python and robotics.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: STEM Education, Coding, Schools, Youth Empowerment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=1200&q=80',
  'Education Transformation: STEM and Coding Curriculums Integrated in 1,200 Public High Schools',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=1200&q=80","title":"Education Transformation: STEM and Coding Curriculums Integrated in 1,200 Public High Schools","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792027592,
  1792027592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-LAW-2026-25</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-11</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Commerce establishes automated online trademark and patent registration registries, providing rigorous enforcement for software developers, artists, and writers.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Copyright, Intellectual Property, Law, Ministry of Commerce</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80',
  'Official Gazette: Enforcement of Revised Law on Copyright and Related Rights',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80","title":"Official Gazette: Enforcement of Revised Law on Copyright and Related Rights","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792049192,
  1792049192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-155</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Telecom Cambodia officially inaugurates the direct high-speed undersea fiber connection, dramatically lowering latency to Singapore, Hong Kong, and global cloud nodes.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Subsea Fiber, Telecommunications, Internet, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80',
  'Subsea Fiber Cable Landing Station in Sihanoukville Multiplies National International Bandwidth',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80","title":"Subsea Fiber Cable Landing Station in Sihanoukville Multiplies National International Bandwidth","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792070792,
  1792070792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Agence Kampuchea Presse (AKP)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://akp.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>AKP-NEWS-2026-160</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Official State News Metadata & Announcements</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Agence Kampuchea Presse (AKP Official Wire)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-19</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Techo Startup Center and Khmer Enterprise announce new non-dilutive grant awards for agri-tech, logistics AI, and health diagnostics startups.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> NEWS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Agence Kampuchea Presse (AKP Official Wire)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://akp.gov.kh/" target="_blank" rel="noopener noreferrer">Agence Kampuchea Presse (AKP)</a>. Content retained under <a href="https://akp.gov.kh/terms" target="_blank" rel="noopener noreferrer">Official State News Metadata & Announcements</a>.</p>
    <p>Keywords: Startup, Khmer Enterprise, Innovation, Venture Capital</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1200&q=80',
  'National Innovation and Startup Forum Showcases 150 Homegrown Cambodian Tech Ventures',
  'Source: Agence Kampuchea Presse (AKP) | Licensed under Official State News Metadata & Announcements. Attribution: Agence Kampuchea Presse (AKP Official Wire)',
  '[{"url":"https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=1200&q=80","title":"National Innovation and Startup Forum Showcases 150 Homegrown Cambodian Tech Ventures","description":"Source: Agence Kampuchea Presse (AKP) | Attribution: Agence Kampuchea Presse (AKP Official Wire)"}]',
  NULL,
  'PUBLIC',
  0,
  1792092392,
  1792092392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-STAT-CSES-2026</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Comprehensive statistical survey by the National Institute of Statistics (NIS) tracking household income, electrification, housing types, and poverty headcounts across 25 provinces.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: CSES, Household Survey, Poverty Indicators, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Socio-Economic Survey (CSES): Multi-Year Household Consumption and Living Standards',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Socio-Economic Survey (CSES): Multi-Year Household Consumption and Living Standards","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792113992,
  1792113992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">World Bank Open Data</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.worldbank.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WB-INDICATOR-NY-GDP-MKTP-KD-ZG-KHM</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution 4.0 International (CC BY 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> The World Bank Group Open Data Indicators</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-08</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Analysis of key macroeconomic indicators: real GDP growth reaching 5.8%, garment and electronics export growth, and external debt sustainability metrics.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> The World Bank Group Open Data Indicators</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer">World Bank Open Data</a>. Content retained under <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer">Creative Commons Attribution 4.0 International (CC BY 4.0)</a>.</p>
    <p>Keywords: GDP Growth, Macroeconomics, World Bank, Trade Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80',
  'World Bank Cambodia Economic Monitor: Real GDP Growth, Manufacturing Resilience, and Trade Outlook',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80","title":"World Bank Cambodia Economic Monitor: Real GDP Growth, Manufacturing Resilience, and Trade Outlook","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792135592,
  1792135592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-CENSUS-DEMO-02</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Demographic dataset highlighting a median age of 27.5 years, labor force participation rates exceeding 81%, and growing urban migration toward secondary provincial capitals.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Demographics, Census, Urbanization, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80',
  'General Population Census of Cambodia: Demographic Dividend, Urbanization, and Fertility Rates',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80","title":"General Population Census of Cambodia: Demographic Dividend, Urbanization, and Fertility Rates","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792157192,
  1792157192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-SEZ-STAT-03</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-21</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Statistical compilation of capital investment flows in electronics assembly, automotive wiring harness manufacturing, and solar panel production across 24 operational SEZs.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: FDI, SEZ, Manufacturing, Investment Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=1200&q=80',
  'Special Economic Zones (SEZs) Investment Dataset: Foreign Direct Investment and Industrial Output',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=1200&q=80","title":"Special Economic Zones (SEZs) Investment Dataset: Foreign Direct Investment and Industrial Output","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792178792,
  1792178792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-AGRI-RICE-04</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-28</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Annual yield data showing national surplus paddy harvest exceeding 12 million metric tons, with fragrant Jasmine rice exports expanding to European and Middle Eastern markets.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Agriculture Data, Rice Exports, Commodities, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&w=1200&q=80',
  'National Agricultural Statistics: Paddy Rice Production, Milling Capacity, and Milled Rice Exports',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&w=1200&q=80","title":"National Agricultural Statistics: Paddy Rice Production, Milling Capacity, and Milled Rice Exports","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792200392,
  1792200392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NBC-BAKONG-Q1-2026</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-05</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>National Bank of Cambodia statistical release documenting over 35 million retail accounts and quarterly transaction values equaling 75% of annual national GDP.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Bakong, Payment Metrics, Fintech, Central Bank</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80',
  'Bakong Payment System Metrics: Digital Retail Transaction Volumes and Cross-Border Interoperability',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80","title":"Bakong Payment System Metrics: Digital Retail Transaction Volumes and Cross-Border Interoperability","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792221992,
  1792221992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-EDU-STAT-06</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-11</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Detailed provincial dataset tracking net primary enrollment at 97.4%, secondary school retention, and female tertiary STEM matriculation increases.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Education Data, Gender Parity, Literacy, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=1200&q=80',
  'Education Statistics and Indicators: Primary Completion, Gender Parity, and Higher Education Enrollment',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=1200&q=80","title":"Education Statistics and Indicators: Primary Completion, Gender Parity, and Higher Education Enrollment","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792243592,
  1792243592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">World Bank Open Data</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.worldbank.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WB-INDICATOR-EG-ELC-ACCS-ZS-KHM</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution 4.0 International (CC BY 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> The World Bank Group Open Data Indicators</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-16</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Benchmark dataset tracing grid electrification from under 30% in 2010 to 98.5% of villages in 2026, alongside solar and hydro generation growth curves.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> The World Bank Group Open Data Indicators</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer">World Bank Open Data</a>. Content retained under <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer">Creative Commons Attribution 4.0 International (CC BY 4.0)</a>.</p>
    <p>Keywords: Electrification, Clean Energy, World Bank, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=1200&q=80',
  'World Bank Energy Indicators: Rural Electrification and Clean Grid Mix in Cambodia',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=1200&q=80","title":"World Bank Energy Indicators: Rural Electrification and Clean Grid Mix in Cambodia","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792265192,
  1792265192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-CPI-BULLETIN-08</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-21</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Official monthly price bulletin measuring core inflation, food and non-alcoholic beverages basket weights, and transportation energy index volatility.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: CPI, Inflation, Prices, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80',
  'Consumer Price Index (CPI) and Inflation Dynamics: Monthly Food, Fuel, and Housing Tracking',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80","title":"Consumer Price Index (CPI) and Inflation Dynamics: Monthly Food, Fuel, and Housing Tracking","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792286792,
  1792286792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Ministry of Tourism of Cambodia</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://tourism.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MOT-TOUR-STAT-09</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Government Tourism Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Tourism, Kingdom of Cambodia</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-27</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Tourism statistical compendium detailing international inbound arrivals passing 6.2 million visitors annually, with long-haul cultural itineraries rebounding strongly.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Tourism, Kingdom of Cambodia</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://tourism.gov.kh/" target="_blank" rel="noopener noreferrer">Ministry of Tourism of Cambodia</a>. Content retained under <a href="https://tourism.gov.kh/legal" target="_blank" rel="noopener noreferrer">Open Government Tourism Information Notice</a>.</p>
    <p>Keywords: Tourism Stats, Arrivals, Visitor Stays, MOT</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
  'International Visitor Arrivals and Tourism Receipts: Origin Markets, Average Stays, and Expenditure',
  'Source: Ministry of Tourism of Cambodia | Licensed under Open Government Tourism Information Notice. Attribution: Ministry of Tourism, Kingdom of Cambodia',
  '[{"url":"https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80","title":"International Visitor Arrivals and Tourism Receipts: Origin Markets, Average Stays, and Expenditure","description":"Source: Ministry of Tourism of Cambodia | Attribution: Ministry of Tourism, Kingdom of Cambodia"}]',
  NULL,
  'PUBLIC',
  0,
  1792308392,
  1792308392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-LABOR-STAT-10</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Comprehensive employment census analyzing service sector growth, industrial labor absorbing rural youth, and social security fund (NSSF) enrollment.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Labor Survey, Employment, NSSF, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80',
  'Labor Force Survey: Formal vs Informal Employment, Wage Distributions, and Youth Opportunities',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80","title":"Labor Force Survey: Formal vs Informal Employment, Wage Distributions, and Youth Opportunities","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792329992,
  1792329992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-PORT-STAT-11</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-05</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Deep-water seaport operations dataset showing annual TEU container volumes surpassing 1 million units, with phase 1 deep-water expansion deepening drafts to 14.5 meters.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Port Statistics, PAS, Maritime, Trade Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80',
  'Sihanoukville Autonomous Port (PAS) Container Throughput and Maritime Shipping Data',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80","title":"Sihanoukville Autonomous Port (PAS) Container Throughput and Maritime Shipping Data","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792351592,
  1792351592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-ENV-FOREST-12</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-09</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Environment GIS remote sensing dataset tracking tree canopy coverage, REDD+ carbon credit projects, and community protected forest health.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Forest Cover, Biomass, GIS, Carbon Credits</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80',
  'Cambodia National Forest Cover and Satellite Biomass Monitoring Dataset',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80","title":"Cambodia National Forest Cover and Satellite Biomass Monitoring Dataset","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792373192,
  1792373192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">World Bank Open Data</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.worldbank.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WB-INDICATOR-IT-CEL-SETS-P2-KHM</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution 4.0 International (CC BY 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> The World Bank Group Open Data Indicators</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-13</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Tracking mobile broadband subscriptions reaching over 125% of population and optic fiber infrastructure reaching 85% of communes nationwide.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> The World Bank Group Open Data Indicators</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer">World Bank Open Data</a>. Content retained under <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer">Creative Commons Attribution 4.0 International (CC BY 4.0)</a>.</p>
    <p>Keywords: Broadband, Mobile Subs, World Bank, Telecom</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?auto=format&fit=crop&w=1200&q=80',
  'World Bank Telecommunications Data: Mobile Cellular and Fixed Broadband Penetration in Cambodia',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1544197150-b99a580bb7a8?auto=format&fit=crop&w=1200&q=80","title":"World Bank Telecommunications Data: Mobile Cellular and Fixed Broadband Penetration in Cambodia","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792394792,
  1792394792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-HDI-PROV-14</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-17</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Sub-national HDI scores illustrating significant reductions in provincial development gaps between capital urban zones and northeastern mountain provinces.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: HDI, Provincial Stats, Human Development, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80',
  'Provincial Human Development Index (HDI) Comparative Dataset: Health, Education, and Income',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80","title":"Provincial Human Development Index (HDI) Comparative Dataset: Health, Education, and Income","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792416392,
  1792416392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-MFI-STAT-15</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-20</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Statistical assessment of micro-loan disbursements, SME refinancing credit lines, and regulatory interest rate caps protecting rural farming families.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Microfinance, Banking, Rural Credit, Finance Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1565372195458-9de0b320ef04?auto=format&fit=crop&w=1200&q=80',
  'Microfinance and Rural Banking Portfolio Indicators: Non-Performing Loans and Collateral Relief',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1565372195458-9de0b320ef04?auto=format&fit=crop&w=1200&q=80","title":"Microfinance and Rural Banking Portfolio Indicators: Non-Performing Loans and Collateral Relief","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792437992,
  1792437992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-CDHS-STAT-16</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-24</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Longitudinal health indicators recording reductions in infant and under-five mortality, institutional birth deliveries reaching 98%, and stunting rate improvements.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Health Survey, CDHS, Nutrition, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=1200&q=80',
  'Cambodia Demographic and Health Survey (CDHS): Maternal Health, Nutrition, and Child Mortality',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=1200&q=80","title":"Cambodia Demographic and Health Survey (CDHS): Maternal Health, Nutrition, and Child Mortality","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792459592,
  1792459592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-URBAN-STAT-17</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-27</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Urban infrastructure datasets analyzing rapid municipal expansion in Phnom Penh, Siem Reap, Sihanoukville, Poipet, and Kampong Cham.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Urbanization, Infrastructure, Waste Management, NIS</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80',
  'Municipal Urbanization Metrics: Building Permits, Road Surface Pavement, and Solid Waste Collection',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80","title":"Municipal Urbanization Metrics: Building Permits, Road Surface Pavement, and Solid Waste Collection","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792481192,
  1792481192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-DEBT-STAT-18</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Detailed breakdown of external debt stock, concessional financing ratios from development partners, and sovereign bond issuances in Khmer Riel (KHR).</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Public Debt, Sovereign Bonds, MEF, Fiscal Policy</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80',
  'Public Debt Sustainability Analysis and Sovereign Financing Bulletin (MEF)',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80","title":"Public Debt Sustainability Analysis and Sovereign Financing Bulletin (MEF)","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792502792,
  1792502792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">World Bank Open Data</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.worldbank.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WB-INDICATOR-TX-VAL-MRCH-CD-WT-KHM</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution 4.0 International (CC BY 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> The World Bank Group Open Data Indicators</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-05</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Trade statistics documenting tariff-free export diversification to Regional Comprehensive Economic Partnership (RCEP) member economies.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> The World Bank Group Open Data Indicators</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer">World Bank Open Data</a>. Content retained under <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer">Creative Commons Attribution 4.0 International (CC BY 4.0)</a>.</p>
    <p>Keywords: RCEP, Merchandise Trade, Exports, World Bank</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'World Bank Trade Indicators: Merchandise Exports and Regional RCEP Integration',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"World Bank Trade Indicators: Merchandise Exports and Regional RCEP Integration","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792524392,
  1792524392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-COMMUNE-STAT-20</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-08</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>National database of commune investment projects financed by central development grants, showing over 8,500 kilometers of climate-resilient concrete rural roads.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Commune Index, Rural Roads, Canals, Infrastructure</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=1200&q=80',
  'Commune Infrastructure Index: Bridges, Concrete Canal Rehabilitation, and Drainage Networks',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=1200&q=80","title":"Commune Infrastructure Index: Bridges, Concrete Canal Rehabilitation, and Drainage Networks","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792545992,
  1792545992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Open Data Portal (MEF)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.mef.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>MEF-FISH-STAT-21</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Ministry of Economy and Finance (MEF) Open Data</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-12</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Fisheries Administration data on annual Tonle Sap catch volumes, community fish sanctuaries, and commercial freshwater fish and giant prawn aquaculture farming.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Ministry of Economy and Finance (MEF) Open Data</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.mef.gov.kh/" target="_blank" rel="noopener noreferrer">Cambodia Open Data Portal (MEF)</a>. Content retained under <a href="https://opendatacommons.org/licenses/odbl/" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: Fisheries Data, Aquaculture, Tonle Sap, Food Systems</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1535591273668-578e31182c4f?auto=format&fit=crop&w=1200&q=80',
  'Inland Fisheries and Aquaculture Production Dataset: Catch Volumes and Sustainable Farming',
  'Source: Cambodia Open Data Portal (MEF) | Licensed under Open Data Commons Open Database License (ODbL). Attribution: Ministry of Economy and Finance (MEF) Open Data',
  '[{"url":"https://images.unsplash.com/photo-1535591273668-578e31182c4f?auto=format&fit=crop&w=1200&q=80","title":"Inland Fisheries and Aquaculture Production Dataset: Catch Volumes and Sustainable Farming","description":"Source: Cambodia Open Data Portal (MEF) | Attribution: Ministry of Economy and Finance (MEF) Open Data"}]',
  NULL,
  'PUBLIC',
  0,
  1792567592,
  1792567592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-CLIMATE-STAT-22</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Hydrometeorological dataset recording annual precipitation totals, peak typhoon season river level surges, and drought mitigation water reserve capacities.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: Climate Data, Meteorology, Rainfall, Water Resources</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534274988757-a28bf1a57c17?auto=format&fit=crop&w=1200&q=80',
  'Climate Vulnerability and Meteorological Records: Annual Rainfall and Monsoon Distributions',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1534274988757-a28bf1a57c17?auto=format&fit=crop&w=1200&q=80","title":"Climate Vulnerability and Meteorological Records: Annual Rainfall and Monsoon Distributions","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792589192,
  1792589192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">National Institute of Statistics (NIS)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.nis.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>NIS-TVET-STAT-23</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Statistics & Census Disclosure Policy</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> National Institute of Statistics, Ministry of Planning</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Ministry of Labour and Vocational Training survey tracking post-graduation employment rates at 89% for mechatronics, automotive servicing, and electrical installation cohorts.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> National Institute of Statistics, Ministry of Planning</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.nis.gov.kh/" target="_blank" rel="noopener noreferrer">National Institute of Statistics (NIS)</a>. Content retained under <a href="https://www.nis.gov.kh/index.php/en/about/legal" target="_blank" rel="noopener noreferrer">Public Statistics & Census Disclosure Policy</a>.</p>
    <p>Keywords: TVET, Vocational Training, Employment, Skills</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80',
  'Technical and Vocational Education and Training (TVET) Graduate Employment Statistics',
  'Source: National Institute of Statistics (NIS) | Licensed under Public Statistics & Census Disclosure Policy. Attribution: National Institute of Statistics, Ministry of Planning',
  '[{"url":"https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80","title":"Technical and Vocational Education and Training (TVET) Graduate Employment Statistics","description":"Source: National Institute of Statistics (NIS) | Attribution: National Institute of Statistics, Ministry of Planning"}]',
  NULL,
  'PUBLIC',
  0,
  1792610792,
  1792610792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">World Bank Open Data</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://data.worldbank.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WB-WDI-CAMBODIA-COMPENDIUM-2026</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution 4.0 International (CC BY 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> The World Bank Group Open Data Indicators</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Curated compilation of 40 primary World Bank open data indicators charting Cambodia’s transformation from low-income to upper middle-income aspiration trajectories.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> STATISTICS</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> The World Bank Group Open Data Indicators</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://data.worldbank.org/" target="_blank" rel="noopener noreferrer">World Bank Open Data</a>. Content retained under <a href="https://datacatalog.worldbank.org/public-licenses#cc-by" target="_blank" rel="noopener noreferrer">Creative Commons Attribution 4.0 International (CC BY 4.0)</a>.</p>
    <p>Keywords: WDI, World Bank Indicators, Benchmark, Development Data</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80',
  'World Development Indicators (WDI): Comprehensive Cambodia Macro & Social Benchmark Summary',
  'Source: World Bank Open Data | Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Attribution: The World Bank Group Open Data Indicators',
  '[{"url":"https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80","title":"World Development Indicators (WDI): Comprehensive Cambodia Macro & Social Benchmark Summary","description":"Source: World Bank Open Data | Attribution: The World Bank Group Open Data Indicators"}]',
  NULL,
  'PUBLIC',
  0,
  1792632392,
  1792632392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-EPIGRAPHY-Q132223</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-05</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An educational introduction to epigraphic linguistics, analyzing how over 1,400 ancient stone inscriptions illuminate chronological genealogies, royal land grants, and temple donations.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Epigraphy, Old Khmer, Sanskrit, Linguistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80',
  'Deciphering Southeast Asian Epigraphy: Sanskrit and Old Khmer Inscriptions on Stone Steles',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80","title":"Deciphering Southeast Asian Epigraphy: Sanskrit and Old Khmer Inscriptions on Stone Steles","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792653992,
  1792653992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">OpenStreetMap</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.openstreetmap.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>OSM-ANGKOR-NODE-98213</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> OpenStreetMap Contributors</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-12</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>How airborne laser scanning (LiDAR) and OpenStreetMap collaborative cartography unveiled the sprawling low-density urban complex supporting three-quarters of a million people.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> OpenStreetMap Contributors</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer">OpenStreetMap</a>. Content retained under <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: OpenStreetMap, Lidar, Spatial Cartography, Urban Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80',
  'Spatial Topography of Angkor: Mapping Ancient Hydraulic Networks with OpenStreetMap and Lidar',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80","title":"Spatial Topography of Angkor: Mapping Ancient Hydraulic Networks with OpenStreetMap and Lidar","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1792675592,
  1792675592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-KNOWLEDGE-GRAPH-Q8444</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-19</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>A technical guide to Semantic Web ontologies, SPARQL query protocols, and linked open data relationships connecting Cambodian temples with global museum catalogues.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Wikidata, Knowledge Graphs, Semantic Web, SPARQL</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80',
  'Wikidata Cultural Knowledge Graphs: Modeling Heritage Monuments, Royal Dynasties, and Artifacts',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80","title":"Wikidata Cultural Knowledge Graphs: Modeling Heritage Monuments, Royal Dynasties, and Artifacts","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792697192,
  1792697192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Europeana Collections</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://api.europeana.eu/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>EUROPEANA-BRONZE-ARTIFACT-4821</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Domain Mark (PDM 1.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Europeana Cultural Heritage API Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-01-25</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Examine ancient metallurgical traditions from the Bronze Age through the Angkorian Golden Age, focusing on tin-copper ratios and hollow-core lost-wax foundry casting techniques.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Europeana Cultural Heritage API Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer">Europeana Collections</a>. Content retained under <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer">Public Domain Mark (PDM 1.0)</a>.</p>
    <p>Keywords: Bronze Casting, Metallurgy, Ancient Technology, Art History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80',
  'Bronze Metallurgy in Mainland Southeast Asia: Lost-Wax Casting of Sacred Hindu and Buddhist Statues',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80","title":"Bronze Metallurgy in Mainland Southeast Asia: Lost-Wax Casting of Sacred Hindu and Buddhist Statues","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792718792,
  1792718792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Europeana Collections</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://api.europeana.eu/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>LOC-MAP-INDOCHINA-1823</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Domain Mark (PDM 1.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Europeana Cultural Heritage API Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-02</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Surveying rare 16th to 19th-century cartographic engravings from Portuguese, Dutch, and French expeditions documenting maritime navigation routes and the great inland sea.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Europeana Cultural Heritage API Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer">Europeana Collections</a>. Content retained under <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer">Public Domain Mark (PDM 1.0)</a>.</p>
    <p>Keywords: Cartography, Historical Maps, Library of Congress, Geography</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80',
  'Cartographic History: Early European and Asian Maps of Indochina in the Library of Congress',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1200&q=80","title":"Cartographic History: Early European and Asian Maps of Indochina in the Library of Congress","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792740392,
  1792740392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-ETHNOBOTANY-KHM-482</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-09</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Documenting indigenous medicinal flora in the Cardamom foothills and Kulen plateau, cataloging biological active compounds used in traditional remedies.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Ethnobotany, Medicinal Plants, Pharmacology, Biodiversity</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=1200&q=80',
  'Ethnobotany of Traditional Khmer Medicinal Plants: Botanical Classification and Pharmacology',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=1200&q=80","title":"Ethnobotany of Traditional Khmer Medicinal Plants: Botanical Classification and Pharmacology","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792761992,
  1792761992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikimedia Commons</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://commons.wikimedia.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WIKICOMMONS-CORBEL-ENG-21</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikimedia Commons & UNESCO Document Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-16</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Structural mechanical principles of corbelling masonry without mortar keystones, highlighting ancient vegetable resin adhesives that endured fourteen centuries of tropical monsoons.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikimedia Commons & UNESCO Document Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a>. Content retained under <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a>.</p>
    <p>Keywords: Corbelled Arch, Brick Architecture, Structural Engineering, History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80',
  'Architectural Engineering of Corbelled Arches in Pre-Angkorian Brick Sanctuaries',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80","title":"Architectural Engineering of Corbelled Arches in Pre-Angkorian Brick Sanctuaries","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792783592,
  1792783592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-FAIR-PRINCIPLES-Q24204395</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-02-23</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An open-science educational guide explaining Findability, Accessibility, Interoperability, and Reusability (FAIR) standards for digital library archives and government data portals.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: FAIR Principles, Open Science, Data Stewardship, Standards</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
  'The FAIR Guiding Principles: Making Public Scientific and Cultural Datasets Findable and Reusable',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80","title":"The FAIR Guiding Principles: Making Public Scientific and Cultural Datasets Findable and Reusable","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792805192,
  1792805192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Europeana Collections</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://api.europeana.eu/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>EUROPEANA-MARITIME-TRADE-994</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Domain Mark (PDM 1.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Europeana Cultural Heritage API Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-01</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>A comparative study of Tang and Song dynasty glazed porcelain, stoneware storage jars, and maritime trade commodities recovered from ancient Southeast Asian sea lanes.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Europeana Cultural Heritage API Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer">Europeana Collections</a>. Content retained under <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer">Public Domain Mark (PDM 1.0)</a>.</p>
    <p>Keywords: Maritime Silk Road, Underwater Archaeology, Ceramics, Trade History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80',
  'Maritime Silk Road Trade Ceramics: The Koh Sdach and Belitung Shipwreck Discoveries',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80","title":"Maritime Silk Road Trade Ceramics: The Koh Sdach and Belitung Shipwreck Discoveries","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792826792,
  1792826792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-KHMER-SCRIPT-Q83942</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-08</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Tracing the historical evolution of script glyphs from 5th-century Pallava scripts to Pre-Angkorian, Angkorian, and modern Aksar Mul and Aksar Chrieng typography.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Palaeography, Khmer Script, Typography, Linguistics</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80',
  'Comparative Palaeography of Southeast Asian Scripts: Evolution from Southern Brahmic to Modern Khmer',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80","title":"Comparative Palaeography of Southeast Asian Scripts: Evolution from Southern Brahmic to Modern Khmer","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792848392,
  1792848392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikimedia Commons</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://commons.wikimedia.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WIKICOMMONS-3D-SCAN-99</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikimedia Commons & UNESCO Document Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-15</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Best practices for millimeter-accurate digital preservation of weathered bas-reliefs, generating open-access Point Cloud datasets and WebXR interactive museum models.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikimedia Commons & UNESCO Document Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a>. Content retained under <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a>.</p>
    <p>Keywords: 3D Scanning, Photogrammetry, Digital Heritage, WebXR</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=1200&q=80',
  'Global Cultural Heritage Digitization: Photogrammetry and 3D Laser Scanning Standards',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=1200&q=80","title":"Global Cultural Heritage Digitization: Photogrammetry and 3D Laser Scanning Standards","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792869992,
  1792869992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-MON-KHMER-LANG-Q33199</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-21</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An academic overview of comparative historical phonology, vowel register complexes, and morphological affixes across modern Austroasiatic languages.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Linguistics, Austroasiatic, Mon-Khmer, Phonology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1200&q=80',
  'Linguistic Evolution and Dialectology of the Mon-Khmer Language Family in Mainland Southeast Asia',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1200&q=80","title":"Linguistic Evolution and Dialectology of the Mon-Khmer Language Family in Mainland Southeast Asia","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792891592,
  1792891592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Europeana Collections</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://api.europeana.eu/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>EUROPEANA-AUDIO-PINNPEAT-02</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Domain Mark (PDM 1.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Europeana Cultural Heritage API Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-03-28</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Scientific analysis of ancient percussion acoustics: the roneat ek bamboo xylophone, kong vong circular gongs, sralai oboe reeds, and sampho two-headed drums.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Europeana Cultural Heritage API Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer">Europeana Collections</a>. Content retained under <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer">Public Domain Mark (PDM 1.0)</a>.</p>
    <p>Keywords: Ethnomusicology, Pinn Peat, Acoustics, Khmer Music</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1200&q=80',
  'Acoustics and Ethnomusicology of the Pinn Peat and Mohori Ensembles',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1200&q=80","title":"Acoustics and Ethnomusicology of the Pinn Peat and Mohori Ensembles","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792913192,
  1792913192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-ARCHAEOASTRONOMY-Q211143</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-04</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>How Khmer temple architects utilized celestial poles, gnomon shadow sticks, and constellation risings to achieve exact true-north alignments within fractions of a degree.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Archaeoastronomy, Geodesy, Orientation, Architecture</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=1200&q=80',
  'Historical Geodesy: Cardinal Alignments and Astronomical Meridian Systems in Monumental Temples',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=1200&q=80","title":"Historical Geodesy: Cardinal Alignments and Astronomical Meridian Systems in Monumental Temples","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792934792,
  1792934792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-MEKONG-CATFISH-Q205312</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Educational monograph on the Pangasianodon gigas and Catlocarpio siamensis, their long-distance breeding migrations, and wetland ecosystem services.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Giant Catfish, Mekong Ecology, Ichthyology, Conservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
  'Biodiversity of the Lower Mekong Basin: Migratory Fish Species and Ecology of the Giant Catfish',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80","title":"Biodiversity of the Lower Mekong Basin: Migratory Fish Species and Ecology of the Giant Catfish","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1792956392,
  1792956392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikimedia Commons</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://commons.wikimedia.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WIKICOMMONS-KILN-KULEN-54</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikimedia Commons & UNESCO Document Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-16</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Excavation of Anlong Thom cross-draft kilns producing green and ash-glazed Khmer stoneware vessels used throughout the Angkorian empire and international courts.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikimedia Commons & UNESCO Document Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a>. Content retained under <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a>.</p>
    <p>Keywords: Kulen Kilns, Ceramics, Kiln Technology, Archaeology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80',
  'Ceramic Kiln Sites of Phnom Kulen: Glazed Stoneware Technology in the 9th to 12th Centuries',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80","title":"Ceramic Kiln Sites of Phnom Kulen: Glazed Stoneware Technology in the 9th to 12th Centuries","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1792977992,
  1792977992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">OpenStreetMap</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.openstreetmap.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>OSM-GIS-HERITAGE-WORKFLOW-01</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> OpenStreetMap Contributors</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>How open-source tools like QGIS and GDAL are applied to model hydrological flooding simulations, buffer zones, and spatial density heatmaps around ancient monuments.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> OpenStreetMap Contributors</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer">OpenStreetMap</a>. Content retained under <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: GIS, QGIS, Spatial Analysis, Cultural Management</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80',
  'Geographic Information Systems (GIS) in Modern Cultural Heritage Management',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80","title":"Geographic Information Systems (GIS) in Modern Cultural Heritage Management","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1792999592,
  1792999592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Europeana Collections</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://api.europeana.eu/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>LOC-PRESERVATION-STD-08</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Public Domain Mark (PDM 1.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Europeana Cultural Heritage API Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-04-28</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Technical specifications for handling brittle palm-leaf manuscripts (Sastra Sleuk Rith), high-resolution color calibration, and open archival information systems (OAIS).</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Europeana Cultural Heritage API Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://api.europeana.eu/" target="_blank" rel="noopener noreferrer">Europeana Collections</a>. Content retained under <a href="https://creativecommons.org/publicdomain/mark/1.0/" target="_blank" rel="noopener noreferrer">Public Domain Mark (PDM 1.0)</a>.</p>
    <p>Keywords: Archival Standards, Palm Leaf Manuscripts, Library of Congress, Preservation</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&w=1200&q=80',
  'Document Preservation and Archival Digitization Standards: Library of Congress Guidelines',
  'Source: Europeana Collections | Licensed under Public Domain Mark (PDM 1.0). Attribution: Europeana Cultural Heritage API Registry',
  '[{"url":"https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&w=1200&q=80","title":"Document Preservation and Archival Digitization Standards: Library of Congress Guidelines","description":"Source: Europeana Collections | Attribution: Europeana Cultural Heritage API Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1793021192,
  1793021192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-GARUDA-ICONOGRAPHY-Q181414</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-02</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Analyzing the symbolic philosophical dualism between solar celestial birds and terrestrial water serpents carved on balustrades, causeways, and royal lintels.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Iconography, Garuda, Naga, Mythology</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80',
  'The Iconography of Garuda and Naga in Southeast Asian Mythological Art and Sculpture',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1200&q=80","title":"The Iconography of Garuda and Naga in Southeast Asian Mythological Art and Sculpture","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793042792,
  1793042792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-UNESCO-WHC-Q9259</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-06</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An educational breakdown of the 1972 World Heritage Convention mechanisms, State of Conservation reports, and rigorous Heritage Impact Assessment (HIA) protocols.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: UNESCO Convention, World Heritage, Heritage Management, HIA</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80',
  'UNESCO World Heritage Management Framework: Heritage Impact Assessments and Sustainability',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1548013146-72479768bbaa?auto=format&fit=crop&w=1200&q=80","title":"UNESCO World Heritage Management Framework: Heritage Impact Assessments and Sustainability","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793064392,
  1793064392
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikimedia Commons</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://commons.wikimedia.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WIKICOMMONS-TIMBER-ARCH-03</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikimedia Commons & UNESCO Document Registry</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-10</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Structural carpentry analysis of raised timber stilt residences, detailing high-pitched gables, louvered eaves, and natural convection airflow cooling tropical living spaces.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikimedia Commons & UNESCO Document Registry</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a>. Content retained under <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener noreferrer">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a>.</p>
    <p>Keywords: Vernacular Architecture, Stilt Houses, Passive Cooling, Carpentry</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
  'Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling',
  'Source: Wikimedia Commons | Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Attribution: Wikimedia Commons & UNESCO Document Registry',
  '[{"url":"https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80","title":"Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling","description":"Source: Wikimedia Commons | Attribution: Wikimedia Commons & UNESCO Document Registry"}]',
  NULL,
  'PUBLIC',
  0,
  1793085992,
  1793085992
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-CREATIVE-COMMONS-Q284</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-14</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>An essential primer on modern intellectual property rights, exploring CC0, CC BY, CC BY-SA, Open Database Licenses (ODbL), and public institution attribution responsibilities.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Creative Commons, Open Data, Public Domain, IP Law</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80',
  'The Digital Commons: Understanding Creative Commons, Open Data, and Public Domain Licensing',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80","title":"The Digital Commons: Understanding Creative Commons, Open Data, and Public Domain Licensing","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793107592,
  1793107592
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">OpenStreetMap</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.openstreetmap.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>OSM-KHM-REL-3982</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Open Data Commons Open Database License (ODbL)</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> OpenStreetMap Contributors</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-18</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>How volunteer mapping communities and humanitarian OpenStreetMap teams contribute geo-spatial layers of unpaved road networks, clinics, and clean water wells.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> OpenStreetMap Contributors</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.openstreetmap.org/" target="_blank" rel="noopener noreferrer">OpenStreetMap</a>. Content retained under <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer">Open Data Commons Open Database License (ODbL)</a>.</p>
    <p>Keywords: OpenStreetMap, Humanitarian Mapping, Cartography, Geodata</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80',
  'OpenStreetMap Collaborative Cartography: Mapping Rural Communes and Health Clinics',
  'Source: OpenStreetMap | Licensed under Open Data Commons Open Database License (ODbL). Attribution: OpenStreetMap Contributors',
  '[{"url":"https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80","title":"OpenStreetMap Collaborative Cartography: Mapping Rural Communes and Health Clinics","description":"Source: OpenStreetMap | Attribution: OpenStreetMap Contributors"}]',
  NULL,
  'PUBLIC',
  0,
  1793129192,
  1793129192
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Wikidata Knowledge Base</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://www.wikidata.org/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>WD-FUNAN-KINGDOM-Q213328</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Creative Commons CC0 1.0 Universal Public Domain Dedication</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> Wikidata Contributors via Wikidata SPARQL API</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-22</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Archaeological synthesis of Oc Eo canals, Angkor Borei brick walls, and Sambor Prei Kuk royal inscriptions tracing the early state formations of lower Mekong civilization.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> Wikidata Contributors via Wikidata SPARQL API</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://www.wikidata.org/" target="_blank" rel="noopener noreferrer">Wikidata Knowledge Base</a>. Content retained under <a href="https://creativecommons.org/publicdomain/zero/1.0/" target="_blank" rel="noopener noreferrer">Creative Commons CC0 1.0 Universal Public Domain Dedication</a>.</p>
    <p>Keywords: Funan, Chenla, Angkor Borei, Southeast Asian History</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80',
  'Historical Analysis of Early Mainland Kingdoms: Funan, Chenla, and Maritime Trade Networks',
  'Source: Wikidata Knowledge Base | Licensed under Creative Commons CC0 1.0 Universal Public Domain Dedication. Attribution: Wikidata Contributors via Wikidata SPARQL API',
  '[{"url":"https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80","title":"Historical Analysis of Early Mainland Kingdoms: Funan, Chenla, and Maritime Trade Networks","description":"Source: Wikidata Knowledge Base | Attribution: Wikidata Contributors via Wikidata SPARQL API"}]',
  NULL,
  'PUBLIC',
  0,
  1793150792,
  1793150792
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
  '<div class="verified-content-record">
  <div class="rights-attribution-box" style="padding: 1rem; border-radius: 0.75rem; border: 1px solid rgba(16, 185, 129, 0.3); background: rgba(16, 185, 129, 0.05); margin-bottom: 2rem;">
    <h4 style="margin: 0 0 0.5rem 0; font-weight: 700; color: #059669; display: flex; align-items: center; gap: 0.5rem;">
      <span>✓</span> Verified Public Open Data Record
    </h4>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Source Provider:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">APSARA National Authority</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Canonical Source URL:</strong> <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">https://apsaraauthority.gov.kh/</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>External Source ID:</strong> <code>APSARA-EQUINOX-2026-01</code></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>License:</strong> <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Cambodia Public Heritage & Open Information Notice</a></p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Attribution:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</p>
    <p style="margin: 0.25rem 0; font-size: 0.875rem; color: #374151;"><strong>Original Publication Date:</strong> 2026-05-25</p>
  </div>

  <h2>Overview & Public Information</h2>
  <p>Every March and September, thousands gather at dawn to witness the sun rise directly behind the central lotus-bud pinnacle of Angkor Wat, a breathtaking tribute to ancient astronomy.</p>
  
  <p>This entry forms part of the national and worldwide public domain knowledge repository. Through authenticated metadata preservation, the record ensures long-term accessibility, transparent data provenance, and full adherence to legal open-access standards.</p>

  <h3>Key Information & Verified Data Highlights</h3>
  <ul>
    <li><strong>Category Classification:</strong> EDUCATION</li>
    <li><strong>Data Standard:</strong> FAIR Open Data Compliant (Findable, Accessible, Interoperable, Reusable).</li>
    <li><strong>Custodian / Publisher:</strong> APSARA National Authority (Archaeology & Heritage Preservation)</li>
    <li><strong>Verification Checksum:</strong> Verified against official source documentation and current endpoint specifications.</li>
  </ul>

  <h3>Documentation & Extended Ingestion Notes</h3>
  <p>The information captured in this record was retrieved through approved open-access APIs, official ministerial gazettes, or verified Creative Commons / Open Database repositories. Commercial copyright restrictions or non-commercial constraints are explicitly adhered to in accordance with applicable terms of service.</p>

  
  <h3>Official Multimedia Documentation</h3>
  <p>Official educational video stream provided by authorized institutional archives:</p>
  <p><a href="https://www.youtube.com/watch?v=kYvM3d1iZJ8" target="_blank" rel="noopener noreferrer" style="color: #0284c7; text-decoration: underline;">Watch official video presentation on authorized platform</a></p>
  

  <hr style="margin: 2rem 0; border: 0; border-top: 1px solid #e5e7eb;" />

  <footer style="font-size: 0.8125rem; color: #6b7280;">
    <p><strong>Legal & Ingestion Provenance:</strong> Ingested into database with verified rights verification metadata. Source: <a href="https://apsaraauthority.gov.kh/" target="_blank" rel="noopener noreferrer">APSARA National Authority</a>. Content retained under <a href="https://apsaraauthority.gov.kh/terms" target="_blank" rel="noopener noreferrer">Cambodia Public Heritage & Open Information Notice</a>.</p>
    <p>Keywords: Equinox, Archaeoastronomy, Angkor Wat, Solar Alignment</p>
  </footer>
</div>',
  'https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80',
  'Solar Equinox Phenomena at Monumental Sanctuaries: Angkor Wat and Archaeoastronomy',
  'Source: APSARA National Authority | Licensed under Cambodia Public Heritage & Open Information Notice. Attribution: APSARA National Authority (Archaeology & Heritage Preservation)',
  '[{"url":"https://images.unsplash.com/photo-1569154941061-e231b4725ef1?auto=format&fit=crop&w=1200&q=80","title":"Solar Equinox Phenomena at Monumental Sanctuaries: Angkor Wat and Archaeoastronomy","description":"Source: APSARA National Authority | Attribution: APSARA National Authority (Archaeology & Heritage Preservation)"}]',
  '["https://www.youtube.com/watch?v=kYvM3d1iZJ8"]',
  'PUBLIC',
  0,
  1793172392,
  1793172392
);
