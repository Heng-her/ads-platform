import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 25 Technology topics
const techTopics = [
  {
    title: 'The Evolution of Decentralized Autonomous Organizations in Web3',
    desc: 'How DAOs are reshaping corporate governance, treasury management, and community voting mechanisms across modern decentralized networks.',
    img: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&w=1200&q=80',
    tags: ['Web3', 'Blockchain', 'Governance']
  },
  {
    title: 'Next-Gen AI Accelerators: Beyond Traditional GPU Architectures',
    desc: 'Exploring novel neuromorphic chips, photonic computing, and specialized tensor cores pushing machine learning inference speeds to unprecedented levels.',
    img: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    tags: ['Artificial Intelligence', 'Hardware', 'Semiconductors']
  },
  {
    title: 'Zero-Knowledge Cryptography: Privacy Preserving Verification for Edge Devices',
    desc: 'Deep dive into zk-SNARKs and zk-STARKs enabling cryptographic verification without exposing sensitive user telemetry or personal identity.',
    img: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80',
    tags: ['Cryptography', 'Security', 'Privacy']
  },
  {
    title: 'Building Resilient Edge Computing Architectures on Cloudflare Workers',
    desc: 'Architectural patterns for running ultra-low latency serverless APIs, globally distributed caching, and D1 database replications at edge nodes.',
    img: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80',
    tags: ['Serverless', 'Cloudflare', 'Cloud Infrastructure']
  },
  {
    title: 'Quantum Key Distribution: The Race to Safeguard Global Telecommunications',
    desc: 'How physics-based encryption and quantum entanglement protocols are preparing critical global infrastructure for post-quantum decryption threats.',
    img: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&w=1200&q=80',
    tags: ['Quantum', 'Cybersecurity', 'Networks']
  },
  {
    title: 'Modern Front-End State Hydration: Nuxt 4 Island Architecture Analyzed',
    desc: 'A comprehensive benchmark of partial hydration, server-only components, and streaming SSR optimizations in high-traffic enterprise applications.',
    img: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=1200&q=80',
    tags: ['Nuxt', 'Vue', 'Web Development']
  },
  {
    title: 'Smart Contract Auditing: Automated Static Analysis vs Formal Verification',
    desc: 'Best practices for securing multi-million dollar smart contracts using automated fuzzers, symbolic execution, and human mathematical verification.',
    img: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80',
    tags: ['Smart Contracts', 'Security', 'Ethereum']
  },
  {
    title: 'The Rise of Autonomous AI Agents in Software Engineering Workflows',
    desc: 'Evaluating developer productivity, automated bug resolution, and code generation pipelines powered by collaborative LLM sub-agents.',
    img: 'https://images.unsplash.com/photo-1677442136019-21780efad99a?auto=format&fit=crop&w=1200&q=80',
    tags: ['AI Agents', 'DevOps', 'Automation']
  },
  {
    title: 'High-Throughput Event Streaming with Apache Kafka and RabbitMQ',
    desc: 'Comparing message broker throughput, fault tolerance, and deduplication guarantees in distributed microservice architectures.',
    img: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
    tags: ['Microservices', 'Distributed Systems', 'Kafka']
  },
  {
    title: 'Decentralized Identity (DID) and Verifiable Credentials for Open Web',
    desc: 'Empowering users with sovereign digital passports, passwordless cryptographic logins, and portable cross-platform reputation standards.',
    img: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1200&q=80',
    tags: ['Identity', 'Web3', 'Standards']
  },
  {
    title: 'Real-Time Vector Search: Enhancing Retrieval-Augmented Generation (RAG)',
    desc: 'Optimizing high-dimensional embeddings indexing with HNSW algorithms to achieve sub-millisecond similarity lookups across billions of vectors.',
    img: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=1200&q=80',
    tags: ['Vector DB', 'RAG', 'Machine Learning']
  },
  {
    title: 'WebAssembly in the Browser: Running High-Performance Native Modules',
    desc: 'Harnessing Rust and C++ compiled Wasm binaries to deliver native 60fps image editing, cryptographic hashing, and audio synthesis in web apps.',
    img: 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?auto=format&fit=crop&w=1200&q=80',
    tags: ['WebAssembly', 'Rust', 'Performance']
  },
  {
    title: 'Kubernetes Cluster Hardening: Implementing Zero-Trust Mesh with Cilium',
    desc: 'Enforcing eBPF-powered network policies, mutual TLS encryption, and runtime intrusion detection across cloud-native container workloads.',
    img: 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?auto=format&fit=crop&w=1200&q=80',
    tags: ['Kubernetes', 'DevOps', 'eBPF']
  },
  {
    title: 'Cross-Chain Bridges: Security Lessons Learned from Past Protocol Exploits',
    desc: 'An architectural review of relayers, optimistic validation, and multisig threshold cryptography designed to eliminate bridge vulnerabilities.',
    img: 'https://images.unsplash.com/photo-1642104704074-907c0698cbd9?auto=format&fit=crop&w=1200&q=80',
    tags: ['Blockchain', 'CrossChain', 'Security']
  },
  {
    title: 'Micro-Frontends at Scale: Module Federation in Large Enterprise Teams',
    desc: 'Overcoming version skew, shared dependencies, and routing orchestration when decoupling giant monolithic web portals into autonomous squads.',
    img: 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80',
    tags: ['Frontend', 'Architecture', 'TypeScript']
  },
  {
    title: 'Designing High-Conversion Ad Creatives with Generative AI Systems',
    desc: 'How personalized dynamic banners and real-time contextual copy generation are lifting click-through rates across programmatic ad platforms.',
    img: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=80',
    tags: ['AdTech', 'Generative AI', 'Design']
  },
  {
    title: 'The Silicon Frontier: 2nm Gate-All-Around (GAA) Transistor Breakthroughs',
    desc: 'How extreme ultraviolet lithography and nanosheet designs are enabling chipmakers to sustain Moore’s Law into the next computing era.',
    img: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?auto=format&fit=crop&w=1200&q=80',
    tags: ['Hardware', 'Semiconductors', 'Chips']
  },
  {
    title: 'Progressive Web Apps (PWAs) in 2026: Desktop-Class Offline Experiences',
    desc: 'Utilizing background sync, Web Locks API, and File System Access to create native-feeling web applications on modern OS platforms.',
    img: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
    tags: ['PWA', 'Web Dev', 'Mobile']
  },
  {
    title: 'Secure Enclaves and Confidential Computing in Multi-Tenant Clouds',
    desc: 'Running confidential guest virtual machines with AMD SEV-SNP and Intel TDX to prevent cloud hypervisors from snooping in-memory data.',
    img: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&w=1200&q=80',
    tags: ['Confidential Computing', 'Cloud', 'Security']
  },
  {
    title: 'Spatial Computing UI/UX: Crafting Intuitive 3D Canvas Interfaces',
    desc: 'Designing ergonomics, depth cues, and eye-tracking navigation paradigms for the next generation of mixed reality headsets and wearables.',
    img: 'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Spatial Computing', 'VR', 'UI/UX']
  },
  {
    title: 'Database Sharding and Distributed Transactions with CockroachDB',
    desc: 'Achieving serializable transaction isolation across multiple global regions without sacrificing read-after-write consistency.',
    img: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Databases', 'Distributed Systems', 'SQL']
  },
  {
    title: 'The Future of WebRTC: Low-Latency P2P Video and Audio Streaming',
    desc: 'Implementing selective forwarding units (SFUs), scalable video coding (SVC), and noise suppression neural networks in browser communications.',
    img: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&q=80',
    tags: ['WebRTC', 'Streaming', 'Networking']
  },
  {
    title: 'Automated CI/CD Pipeline Security: Stopping Supply Chain Attacks Early',
    desc: 'Enforcing cryptographic provenance with Sigstore, SBOM generation, and ephemeral runner sandboxing to block malicious third-party dependencies.',
    img: 'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?auto=format&fit=crop&w=1200&q=80',
    tags: ['DevSecOps', 'CI/CD', 'Security']
  },
  {
    title: 'Next-Generation Battery Tech: Solid-State Cells Enter Commercial Testing',
    desc: 'Silicon anode breakthroughs and non-flammable solid electrolytes promising 50% greater energy density and 10-minute fast charging.',
    img: 'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?auto=format&fit=crop&w=1200&q=80',
    tags: ['CleanTech', 'Energy', 'Innovation']
  },
  {
    title: 'Designing Accessible Web Applications: A Complete WCAG 2.2 Handbook',
    desc: 'Practical strategies for keyboard navigation, screen reader ARIA landmarks, contrast ratios, and focus rings to guarantee digital inclusion.',
    img: 'https://images.unsplash.com/photo-1573164713988-8665fc963095?auto=format&fit=crop&w=1200&q=80',
    tags: ['Accessibility', 'UX', 'HTML']
  }
];

// 25 Business topics
const businessTopics = [
  {
    title: 'SaaS Unit Economics: Balancing CAC, LTV, and Net Revenue Retention',
    desc: 'How high-growth B2B software companies optimize payback periods and maintain capital-efficient growth through customer expansion cycles.',
    img: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
    tags: ['SaaS', 'Finance', 'Growth']
  },
  {
    title: 'Global Supply Chain Re-Shoring: Risk Hedging in Volatile Markets',
    desc: 'Multinational corporations are decentralizing manufacturing hubs toward near-shore suppliers to safeguard delivery timelines and margins.',
    img: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Logistics', 'Operations', 'Global Trade']
  },
  {
    title: 'Venture Capital Shifts: The End of Growth-At-All-Costs Funding',
    desc: 'Institutional investors prioritize positive cash flows, operational discipline, and clear paths to profitability over aggressive customer acquisition.',
    img: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=1200&q=80',
    tags: ['Venture Capital', 'Startups', 'Investment']
  },
  {
    title: 'Corporate Treasury in the Digital Age: Tokenized Money Market Funds',
    desc: 'Why enterprise CFOs are exploring permissioned blockchain protocols to manage overnight liquidity yields and cross-border settlements.',
    img: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&w=1200&q=80',
    tags: ['Treasury', 'Fintech', 'Markets']
  },
  {
    title: 'The Future of Remote Work Policy: Hybrid Frameworks That Retain Top Talent',
    desc: 'Analyzing data on employee productivity, asynchronous documentation cultures, and competitive international compensation packages.',
    img: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80',
    tags: ['Leadership', 'Human Resources', 'Workplace']
  },
  {
    title: 'Strategic Mergers & Acquisitions: Integrating Tech Stacks Post-Close',
    desc: 'Preventing cultural friction and technological debt when harmonizing data infrastructures between acquiring firms and startup targets.',
    img: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?auto=format&fit=crop&w=1200&q=80',
    tags: ['M&A', 'Enterprise', 'Strategy']
  },
  {
    title: 'Creator Economy Monetization: Direct-to-Consumer Subscriptions Flourish',
    desc: 'How digital creators are transitioning from fickle sponsorship deals into recurring monthly memberships, workshops, and digital products.',
    img: 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Creators', 'Monetization', 'Media']
  },
  {
    title: 'Private Equity Value Creation: Digital Transformation in Mid-Market Firms',
    desc: 'Accelerating EBITDA multiples by introducing automated ERP systems, customer lifecycle platforms, and predictive inventory forecasting.',
    img: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80',
    tags: ['Private Equity', 'Business Strategy', 'Consulting']
  },
  {
    title: 'Retail Media Networks: Why Every Supermarket is Becoming an Ad Network',
    desc: 'First-party purchase point data allows brick-and-mortar giants to sell hyper-targeted digital placements to FMCG consumer brands.',
    img: 'https://images.unsplash.com/photo-1534452203293-494d7ddbf7e0?auto=format&fit=crop&w=1200&q=80',
    tags: ['Retail', 'AdTech', 'Commerce']
  },
  {
    title: 'Sustainable ESG Disclosures: Compliance and Competitive Advantage',
    desc: 'Navigating mandatory climate reporting directives while optimizing carbon footprints and generating tangible brand loyalty among Gen Z.',
    img: 'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?auto=format&fit=crop&w=1200&q=80',
    tags: ['Sustainability', 'ESG', 'Regulation']
  },
  {
    title: 'Product-Led Growth (PLG) Playbooks: Self-Service Funnels That Convert',
    desc: 'Eliminating sales friction with frictionless freemium tiers, intuitive onboarding walkthroughs, and organic viral expansion loops.',
    img: 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?auto=format&fit=crop&w=1200&q=80',
    tags: ['PLG', 'Product Management', 'SaaS']
  },
  {
    title: 'Navigating Currency Volatility: FX Hedging Strategies for Tech Exporters',
    desc: 'Techniques for safeguarding multinational operating margins through forward currency contracts and algorithmic balance sheet rebalancing.',
    img: 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=1200&q=80',
    tags: ['Forex', 'Risk Management', 'Finance']
  },
  {
    title: 'The Evolution of High-Yield Cash Management in Corporate Banking',
    desc: 'How fintech challengers are offering automated sweep accounts, FDIC pass-through coverage, and commercial liquidity perks to modern startups.',
    img: 'https://images.unsplash.com/photo-1565372195458-9de0b320ef04?auto=format&fit=crop&w=1200&q=80',
    tags: ['Fintech', 'Banking', 'Treasury']
  },
  {
    title: 'Building Unstoppable Brands: The Psychology of Modern Consumer Loyalty',
    desc: 'Why leading brands prioritize emotional storytelling and distinct brand design systems over generic discount promotions.',
    img: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1200&q=80',
    tags: ['Marketing', 'Branding', 'Consumer Psychology']
  },
  {
    title: 'Franchising Strategy in Fast-Casual Dining: Scalable Unit Economics',
    desc: 'A case study on standardized kitchen tech, centralized ingredient sourcing, and royalty models driving expansion across multiple metro areas.',
    img: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
    tags: ['Franchise', 'Hospitality', 'Operations']
  },
  {
    title: 'B2B Sales Enablement: Equipping Account Executives with AI Intelligence',
    desc: 'Real-time call transcription, automated objection handling cheatsheets, and CRM enrichment tools shortening deal cycles by 35%.',
    img: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=1200&q=80',
    tags: ['B2B Sales', 'CRM', 'Productivity']
  },
  {
    title: 'Intellectual Property Protection for Cross-Border E-Commerce Brands',
    desc: 'Guarding trademark portfolios, design patents, and copyright registrations against counterfeits across major international online marketplaces.',
    img: 'https://images.unsplash.com/photo-1450133064473-71024230f91b?auto=format&fit=crop&w=1200&q=80',
    tags: ['Legal', 'Intellectual Property', 'Ecommerce']
  },
  {
    title: 'Subscription Fatigue: How Streaming and App Services Win Re-engagement',
    desc: 'Innovative tier structures including ad-supported options, annual discount lock-ins, and curated content bundles preventing subscriber churn.',
    img: 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?auto=format&fit=crop&w=1200&q=80',
    tags: ['Media', 'Retention', 'Subscriptions']
  },
  {
    title: 'Real Estate Crowdfunding: Democratizing Commercial Asset Ownership',
    desc: 'How fractional property investments and digital syndication platforms are enabling retail investors to participate in tier-one developments.',
    img: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80',
    tags: ['Real Estate', 'Crowdfunding', 'Wealth']
  },
  {
    title: 'The Global Semiconductor Landscape: Government Subsidies and Fab Wars',
    desc: 'An examination of multi-billion dollar industrial subsidy programs funding advanced domestic chip fabrication across Europe and North America.',
    img: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    tags: ['Economics', 'Policy', 'Semiconductors']
  },
  {
    title: 'Customer Success Operations: Transforming Cost Centers into Growth Drivers',
    desc: 'Proactive onboarding health scores and customer journey automation identifying upselling opportunities before contract renewal windows.',
    img: 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=1200&q=80',
    tags: ['Customer Success', 'B2B', 'Retention']
  },
  {
    title: 'The Direct-to-Consumer (DTC) Pivot: Re-Entering Wholesale Retail Channels',
    desc: 'Why former digital-only lifestyle brands are aggressively negotiating shelf space in retail chains to reduce customer acquisition costs.',
    img: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=1200&q=80',
    tags: ['DTC', 'Retail', 'Consumer Goods']
  },
  {
    title: 'Angel Investing Syndicate Dynamics: Due Diligence Checklists for Early Stage',
    desc: 'How angel groups structure Special Purpose Vehicles (SPVs), evaluate technical co-founders, and assess total addressable markets (TAM).',
    img: 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Angel Investing', 'Startups', 'Venture']
  },
  {
    title: 'Managing Organizational Burnout: Modern Executive Coaching Interventions',
    desc: 'Fostering psychological safety, structured focus sprints, and boundary-setting habits that improve leader retention in hypergrowth firms.',
    img: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
    tags: ['Executive Leadership', 'Wellness', 'Management']
  },
  {
    title: 'Dynamic Pricing Algorithms: Maximizing Yield Without Alienating Consumers',
    desc: 'Ethical considerations and machine learning elasticity models adjusting prices based on demand surges, weather, and real-time inventory.',
    img: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=1200&q=80',
    tags: ['Pricing', 'Analytics', 'Machine Learning']
  }
];

// 25 News topics
const newsTopics = [
  {
    title: 'Global Climate Summit Concludes with Landmark Renewable Energy Pacts',
    desc: 'Delegates from 140 nations agree on binding targets to triple solar and offshore wind capacity while establishing climate transition funds.',
    img: 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=1200&q=80',
    tags: ['Global News', 'Climate', 'Renewable Energy']
  },
  {
    title: 'Central Banks Announce Synchronized Interest Rate Adjustments',
    desc: 'Financial authorities signal steadying inflation trends while balancing labor market dynamics in a landmark quarterly monetary review.',
    img: 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1200&q=80',
    tags: ['Economy', 'Central Bank', 'Monetary Policy']
  },
  {
    title: 'International Space Agency Unveils Deep Lunar Exploration Roadmap',
    desc: 'New collaborative lunar outpost missions slated for late 2027 aim to study permafrost ice reserves and test autonomous surface habitats.',
    img: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80',
    tags: ['Space', 'Science', 'Astronomy']
  },
  {
    title: 'Breakthrough Cancer Immunotherapy Trial Yields 80% Remission Rate',
    desc: 'Clinical researchers present promising phase-3 results for customized CAR-T cell infusions targeting stubborn solid tumor cancers.',
    img: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?auto=format&fit=crop&w=1200&q=80',
    tags: ['Health', 'Medicine', 'Biotech']
  },
  {
    title: 'Global Maritime Trade Routes Stabilize Following New Security Accords',
    desc: 'International naval task forces deploy advanced escort corridors, restoring commercial container shipping schedules through vital canals.',
    img: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=1200&q=80',
    tags: ['Trade', 'Shipping', 'World News']
  },
  {
    title: 'Historic High-Speed Rail Corridor Opens Connecting Major Regional Metros',
    desc: 'The newly inaugurated electrified transit line cuts commute times by over two hours, reducing highway congestion and transport emissions.',
    img: 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?auto=format&fit=crop&w=1200&q=80',
    tags: ['Infrastructure', 'Transit', 'Urban Development']
  },
  {
    title: 'Tech Leaders Sign Multilateral AI Safety and Verification Treaty',
    desc: 'Leading artificial intelligence labs pledge transparent model evaluations, red-teaming benchmarks, and watermarking for synthetic media.',
    img: 'https://images.unsplash.com/photo-1507146426996-ef05306b995a?auto=format&fit=crop&w=1200&q=80',
    tags: ['AI Governance', 'Tech News', 'Policy']
  },
  {
    title: 'Archeologists Discover Well-Preserved Ancient Commercial Hub Dating 3,000 BCE',
    desc: 'Groundbreaking excavations reveal intricate stone aqueducts, artisan workshops, and maritime trade goods from an ancient Bronze Age trading post.',
    img: 'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=1200&q=80',
    tags: ['History', 'Archeology', 'Culture']
  },
  {
    title: 'Urban Reforestation Programs Reverse Heat Island Effect in Major Metros',
    desc: 'Planting two million indigenous trees and vegetative green rooftops reduces downtown summer temperatures by an average of 3.4 degrees Celsius.',
    img: 'https://images.unsplash.com/photo-1511497584788-87676104235f?auto=format&fit=crop&w=1200&q=80',
    tags: ['Environment', 'Urban Planning', 'Sustainability']
  },
  {
    title: 'Global Tourism Surges Past Pre-Pandemic Benchmarks with Eco-Travel Surge',
    desc: 'Travelers favor carbon-neutral lodges, localized cultural heritage tours, and scenic passenger rail journeys over crowded resort hubs.',
    img: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
    tags: ['Travel', 'Tourism', 'Lifestyle']
  },
  {
    title: 'Desalination Plants Powered by Concentrated Solar Open in Arid Regions',
    desc: 'Revolutionary clean-energy reverse osmosis facilities supply over 200 million gallons of fresh drinking water daily without fossil fuels.',
    img: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80',
    tags: ['Water', 'GreenTech', 'Engineering']
  },
  {
    title: 'International Film Festival Celebrates Breakthrough Independent Cinema',
    desc: 'A diverse slate of global filmmakers captivate festival audiences with compelling humanist narratives exploring identity and technology.',
    img: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=80',
    tags: ['Entertainment', 'Cinema', 'Arts']
  },
  {
    title: 'Agricultural Drones and Satellite Soil Sensors Double Crop Yields',
    desc: 'Farmers adopt precision agronomy tools to optimize micro-fertilization and irrigation, cutting waste and increasing resilience against drought.',
    img: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1200&q=80',
    tags: ['Agriculture', 'AgTech', 'Food Security']
  },
  {
    title: 'Global Literacy Initiative Distributes 10 Million Offline E-Learning Tablets',
    desc: 'Solar-charged educational tablets preloaded with multilingual interactive curriculums bring digital classrooms to remote rural communities.',
    img: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=1200&q=80',
    tags: ['Education', 'Philanthropy', 'Global Impact']
  },
  {
    title: 'Major Breakthrough in Ocean Cleanup: Over 100 Tons of Plastics Recovered',
    desc: 'Autonomous barrier vessels complete their largest maritime sweeping mission, extracting macro-plastics from ocean gyres for recycling.',
    img: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    tags: ['Oceans', 'Ecology', 'Conservation']
  },
  {
    title: 'World Health Organization Approves Next-Generation Dengue Vaccine',
    desc: 'The single-dose immunization provides broad protection across all four serotypes, offering vital defense for over 100 tropical countries.',
    img: 'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&w=1200&q=80',
    tags: ['Global Health', 'Vaccines', 'Science']
  },
  {
    title: 'Youth Orchestra Tops Global Classical Charts with Contemporary Symphony',
    desc: 'Bridging timeless orchestral arrangements with electronic ambient textures, the ensemble draws millions of streaming listeners worldwide.',
    img: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=1200&q=80',
    tags: ['Music', 'Culture', 'Classical']
  },
  {
    title: 'Robotics Team Deploys Autonomous Search Submersibles to Deep Trench',
    desc: 'Robotic vehicles navigate extreme hydrostatic pressure to document bioluminescent marine species in uncharted abyss ecosystems.',
    img: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
    tags: ['Marine Biology', 'Exploration', 'Robotics']
  },
  {
    title: 'Renewable Microgrids Provide 100% Reliable Power to Remote Island Communities',
    desc: 'Combining distributed solar arrays, flow battery storage, and smart meters to replace costly imported diesel generators permanently.',
    img: 'https://images.unsplash.com/photo-1508873696983-2df5703bc20d?auto=format&fit=crop&w=1200&q=80',
    tags: ['Energy Transition', 'Islands', 'Solar']
  },
  {
    title: 'International Architecture Award Honors Carbon-Neutral Timber Skyscraper',
    desc: 'Engineered cross-laminated timber replaces structural steel in a breathtaking 30-story commercial tower setting new green building standards.',
    img: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
    tags: ['Architecture', 'Green Building', 'Engineering']
  },
  {
    title: 'Wildlife Conservationists Report Dramatic Recovery of Endangered Mountain Gorillas',
    desc: 'Intensive community ranger patrols and veterinary interventions allow wild populations to climb past historic recovery thresholds.',
    img: 'https://images.unsplash.com/photo-1534567153574-2b12153a87f0?auto=format&fit=crop&w=1200&q=80',
    tags: ['Wildlife', 'Conservation', 'Nature']
  },
  {
    title: 'New Digital Copyright Framework Enacted to Protect Independent Songwriters',
    desc: 'Legislation mandates fair revenue splits from streaming algorithms and establishes standardized micro-royalty auditing protocols.',
    img: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1200&q=80',
    tags: ['Media Law', 'Music Industry', 'Copyright']
  },
  {
    title: 'Global Cyber Coalition Neutralizes Transnational Ransomware Infrastructure',
    desc: 'Coordinated law enforcement strikes seize command-and-control servers, restoring encrypted systems for dozens of targeted hospitals.',
    img: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1200&q=80',
    tags: ['Cybersecurity', 'Crime', 'Law Enforcement']
  },
  {
    title: 'Smart City Sensor Network Reduces Municipal Water Leaks by 40%',
    desc: 'Acoustic monitoring sensors along municipal distribution mains pinpoint underground fractures before catastrophic sinkholes occur.',
    img: 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?auto=format&fit=crop&w=1200&q=80',
    tags: ['Smart Cities', 'IoT', 'Utilities']
  },
  {
    title: 'Ancient Recipe Discovered in Monastic Archives Sparks Culinary Renaissance',
    desc: 'Artisan bakers reconstruct fermented sourdough bread methods from 14th-century manuscripts, delighting modern gastronomy enthusiasts.',
    img: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=1200&q=80',
    tags: ['Gastronomy', 'History', 'Culinary']
  }
];

// 25 Sports topics
const sportsTopics = [
  {
    title: 'Championship Final Thriller: Buzzer-Beater Basket Decides Historic Title',
    desc: 'A stunning 35-foot three-pointer with 0.8 seconds remaining caps an unforgettable quadruple-overtime showdown in front of 22,000 roaring fans.',
    img: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=1200&q=80',
    tags: ['Basketball', 'Championship', 'Highlights']
  },
  {
    title: 'World Marathon Record Shattered in Berlin: Sub-Two-Hour Barrier Approached',
    desc: 'Paced by aerodynamic drafting and customized carbon-plated shoes, the champion clocks 2:00:25 in an awe-inspiring athletic performance.',
    img: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?auto=format&fit=crop&w=1200&q=80',
    tags: ['Running', 'Marathon', 'Athletics']
  },
  {
    title: 'Grand Slam Final: Five-Set Tennis Epic Bridges Two Generations of Legends',
    desc: 'A grueling four-hour and forty-five minute battle on center court features unforgettable baseline rallies and masterclass drop shots.',
    img: 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&w=1200&q=80',
    tags: ['Tennis', 'Grand Slam', 'Sports']
  },
  {
    title: 'Formula Racing Season Finale: Dramatic Wet-Weather Strategy Clinches Crown',
    desc: 'A daring intermediate tire swap during a late safety car restart propels the challenger from fifth to first on the penultimate lap.',
    img: 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1200&q=80',
    tags: ['Motorsport', 'Formula 1', 'Racing']
  },
  {
    title: 'Champions League Drama: Underdog Club Stuns European Powerhouse 3-2',
    desc: 'Flawless counter-attacking football and sensational defensive goalkeeping deliver one of the greatest upsets in modern tournament history.',
    img: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&w=1200&q=80',
    tags: ['Football', 'Soccer', 'Champions League']
  },
  {
    title: 'Olympic Swimming Trials: 17-Year-Old Phenom Breaks 100m Butterfly Record',
    desc: 'Blistering underwater dolphin kicks and explosive stroke frequency announce the arrival of a generational swimming sensation.',
    img: 'https://images.unsplash.com/photo-1530549387789-4c1017266635?auto=format&fit=crop&w=1200&q=80',
    tags: ['Swimming', 'Olympics', 'Records']
  },
  {
    title: 'The Science of Athletic Recovery: Cryotherapy, HRV, and Sleep Optimization',
    desc: 'Elite sports scientists explain how wearable biometric sensors and infrared saunas reduce soft-tissue injury risk by 40%.',
    img: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=1200&q=80',
    tags: ['Sports Science', 'Recovery', 'Fitness']
  },
  {
    title: 'Tour Stage Concluded with Mountain Solo Attack in the High Alps',
    desc: 'Attacking 40 kilometers from the finish line, the yellow jersey contender rides solo over punishing mountain passes to seize the overall lead.',
    img: 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=1200&q=80',
    tags: ['Cycling', 'Alps', 'Tour']
  },
  {
    title: 'Extreme Big Wave Surfing: Riding 80-Foot Monsters at Nazaré Canyon',
    desc: 'Tow-in surf daredevils confront massive Atlantic winter swells, showcasing incredible balance and fearless courage on the open ocean.',
    img: 'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=1200&q=80',
    tags: ['Surfing', 'Extreme Sports', 'Ocean']
  },
  {
    title: 'Global Cricket Cup: Electrifying Super Over Decides Inaugural Champion',
    desc: 'Tied after 50 overs each, the teams produce an unbelievable spectacle of boundary hitting and yorker deliveries in the sudden-death frame.',
    img: 'https://images.unsplash.com/photo-1531415074868-036b1c57e335?auto=format&fit=crop&w=1200&q=80',
    tags: ['Cricket', 'World Cup', 'Highlights']
  },
  {
    title: 'Women’s Professional Soccer League Sets Record Television Viewership',
    desc: 'Skyrocketing stadium attendance and primetime broadcast contracts highlight the tremendous global momentum of women’s football.',
    img: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?auto=format&fit=crop&w=1200&q=80',
    tags: ['Womens Sports', 'Soccer', 'Growth']
  },
  {
    title: 'Winter Extreme Games: Quadruple Cork Landed in Snowboard Big Air Final',
    desc: 'Flawless execution of four off-axis rotations at 65 feet in the air earns a perfect 100 score from stunned contest judges.',
    img: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?auto=format&fit=crop&w=1200&q=80',
    tags: ['Snowboarding', 'Winter Sports', 'Extreme']
  },
  {
    title: 'CrossFit Championship Crowds New Fittest Athlete on Earth',
    desc: 'Over four days of grueling clean-and-jerks, obstacle course sprints, and ocean swims, perseverance crowns a new fitness icon.',
    img: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80',
    tags: ['CrossFit', 'Fitness', 'Strength']
  },
  {
    title: 'Golf Major Championship: Veteran Pro Sinks 25-Foot Birdie on the 18th Hole',
    desc: 'Ending an eight-year championship drought, a vintage iron shot from the fairway sets up the winning putt at Augusta National.',
    img: 'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?auto=format&fit=crop&w=1200&q=80',
    tags: ['Golf', 'PGA', 'Majors']
  },
  {
    title: 'World Rugby Championship: Defense Holds Strong at the Goal Line in Stoppage Time',
    desc: 'Heroic forward pack tackles in the 83rd minute repel seven consecutive phases to secure a thrilling one-point tournament victory.',
    img: 'https://images.unsplash.com/photo-1544298621-35a9686e0821?auto=format&fit=crop&w=1200&q=80',
    tags: ['Rugby', 'World Cup', 'Sports']
  },
  {
    title: 'The Rise of Hybrid Trail Running: Conquering 100-Mile Mountain Ultramarathons',
    desc: 'How ultra-runners train mental grit, caloric intake pacing, and navigation strategies to survive self-supported wilderness races.',
    img: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1200&q=80',
    tags: ['Ultra Running', 'Trail', 'Outdoors']
  },
  {
    title: 'Youth Gymnastics Championship Showcases Daring New Vault Difficulties',
    desc: 'Incredible aerial acrobatics and rock-solid landings demonstrate the rising caliber of international artistic gymnasts.',
    img: 'https://images.unsplash.com/photo-1566241142559-40e1dab266c6?auto=format&fit=crop&w=1200&q=80',
    tags: ['Gymnastics', 'Olympics', 'Acrobatics']
  },
  {
    title: 'Tactical Revolution in Basketball: The Demise of the Traditional Center',
    desc: 'Analyzing how positionless play, stretch-five perimeter shooting, and switch-heavy defensive schemes have revolutionized modern hoops.',
    img: 'https://images.unsplash.com/photo-1519766304817-4f37bda74a29?auto=format&fit=crop&w=1200&q=80',
    tags: ['Basketball', 'Analytics', 'Strategy']
  },
  {
    title: 'Global Esports Tournament Arena Sells Out 60,000 Seats in 15 Minutes',
    desc: 'Tens of millions stream the high-stakes tactical MOBA finals as international rivalries collide for a multimillion-dollar prize pool.',
    img: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1200&q=80',
    tags: ['Esports', 'Gaming', 'Competition']
  },
  {
    title: 'Speed Skating World Cup: Track Record Obliterated in 500m Sprint',
    desc: 'Flawless blade transition through tight banked corners carries the sprinter across the line in a breathtaking 33.92 seconds.',
    img: 'https://images.unsplash.com/photo-1516726817505-f5ed825624d8?auto=format&fit=crop&w=1200&q=80',
    tags: ['Speed Skating', 'Winter Sports', 'Records']
  },
  {
    title: 'Rock Climbing World Cup: Dynamic Dyno Solves Improbable Boulder Problem',
    desc: 'Only one climber completes the overhang sequence with a flying two-handed catch that electrifies the stadium audience.',
    img: 'https://images.unsplash.com/photo-1522163182402-834f871fd851?auto=format&fit=crop&w=1200&q=80',
    tags: ['Climbing', 'Bouldering', 'Outdoors']
  },
  {
    title: 'Volleyball Nations League: Comeback from Two Sets Down Stuns Finalists',
    desc: 'Incredible service aces and ferocious outside spikes fuel a dramatic reverse sweep in front of a passionate home crowd.',
    img: 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?auto=format&fit=crop&w=1200&q=80',
    tags: ['Volleyball', 'Nations League', 'Team Sports']
  },
  {
    title: 'Modern Sport Nutrition: Periodized Carb Loading and Plant-Based Protein',
    desc: 'Investigating how modern championship athletes fuel intense double-session training blocks while speeding gut absorption.',
    img: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80',
    tags: ['Nutrition', 'Diet', 'Athletics']
  },
  {
    title: 'Sailing Regatta: Foiling Monohulls Fly Above the Waves at 50 Knots',
    desc: 'Cutting-edge aerospace hydrofoils and computer-controlled wing sails push sailing race boats to blinding speeds in coastal conditions.',
    img: 'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?auto=format&fit=crop&w=1200&q=80',
    tags: ['Sailing', 'Regatta', 'Yachting']
  },
  {
    title: 'Combat Sports Superfight: Masterful Counter-Striking Clinches Unanimous Decision',
    desc: 'Distance control, precise jab feints, and elusive head movement dictate the pace over twelve intense championship rounds.',
    img: 'https://images.unsplash.com/photo-1517438322307-e67111335449?auto=format&fit=crop&w=1200&q=80',
    tags: ['Boxing', 'Combat Sports', 'Championship']
  }
];

// Helper to escape SQL string literal
function sqlEscape(str) {
  if (str === null || str === undefined) return 'NULL';
  return "'" + str.replace(/'/g, "''") + "'";
}

// Generate rich HTML content
function generateRichContent(topic, category) {
  return `
<h2>Executive Summary: ${topic.title}</h2>
<p>${topic.desc}</p>
<p>In recent years, the sector of <strong>${category}</strong> has experienced unprecedented acceleration. Organizations, researchers, and creators worldwide are adopting cutting-edge methodologies to keep pace with rapid developments. Today's insights demonstrate key inflection points that every forward-looking practitioner should monitor closely.</p>
<blockquote>"Innovation distinguishes between a leader and a follower. By embracing data-driven architecture and relentless iteration, digital platforms can unlock lasting value."</blockquote>
<h3>Core Breakthroughs & Industry Implications</h3>
<p>When analyzing the trajectory of this shift, several foundational patterns emerge:</p>
<ul>
  <li><strong>Enhanced Scalability:</strong> Modern infrastructure enables real-time throughput with minimal operational overhead.</li>
  <li><strong>Decentralized Resilience:</strong> Eliminating single points of failure fosters greater user trust and platform longevity.</li>
  <li><strong>User-Centric Design:</strong> Prioritizing seamless user experience ensures high engagement and sustainable growth loops.</li>
</ul>
<p>As we advance further into this cycle, collaboration between cross-functional teams will remain the ultimate differentiator. Stay tuned for continuous updates and deep-dive technical breakdowns on our platform.</p>
`.trim();
}

// Combine all 100 items (25 each)
const allCategories = [
  { name: 'TECHNOLOGY', topics: techTopics },
  { name: 'BUSINESS', topics: businessTopics },
  { name: 'NEWS', topics: newsTopics },
  { name: 'SPORTS', topics: sportsTopics }
];

const totalRecords = 100;
const seedStatements = [];

// Staggered timestamps in SECONDS for SQLite integer timestamp mode
const baseTimestamp = Math.floor(Date.now() / 1000); // Unix timestamp in seconds
const staggerSec = 25 * 60; // 25 mins in seconds

let recordIndex = 0;

for (const cat of allCategories) {
  for (let i = 0; i < cat.topics.length; i++) {
    recordIndex++;
    const topic = cat.topics[i];
    
    // Deterministic UUID matching standard v4 format: 7e575eed-2026-4000-8000-000000000001
    const hexId = recordIndex.toString(16).padStart(12, '0');
    const id = `7e575eed-2026-4000-8000-${hexId}`;
    
    const userId = 'usr_creator_seed_001';
    const title = topic.title;
    const description = topic.desc;
    const category = cat.name;
    
    // Most are ARTICLE, occasional VIDEO or NEWS
    let contentType = 'ARTICLE';
    if (recordIndex % 20 === 0) contentType = 'VIDEO';
    else if (recordIndex % 15 === 0) contentType = 'NEWS';
    else if (recordIndex % 33 === 0) contentType = 'BANNER';
    
    const content = generateRichContent(topic, cat.name);
    const imageUrl = topic.img;
    const imageTitle = topic.title;
    const imageDescription = topic.desc;
    
    // Multi-images array (some items get 2 gallery images)
    let images = null;
    if (recordIndex % 3 === 0) {
      images = JSON.stringify([
        { url: topic.img, title: topic.title, description: topic.desc },
        { url: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=800&q=80', title: 'Global Connectivity', description: 'Real-time telemetry and network overview' }
      ]);
    }
    
    // Video URLs (some items get sample video)
    let videoUrls = null;
    if (contentType === 'VIDEO' || recordIndex % 10 === 0) {
      videoUrls = JSON.stringify(['https://www.youtube.com/watch?v=dQw4w9WgXcQ']);
    }
    
    const status = 'PUBLIC';
    const isDeleted = 0;
    const createdAt = baseTimestamp - ((totalRecords - recordIndex) * staggerSec);
    const updatedAt = createdAt;
    
    const insertSql = `INSERT OR REPLACE INTO campaigns (
  id, user_id, title, description, category, content_type, content,
  image_url, image_title, image_description, images, video_urls,
  status, is_deleted, created_at, updated_at
) VALUES (
  ${sqlEscape(id)},
  ${sqlEscape(userId)},
  ${sqlEscape(title)},
  ${sqlEscape(description)},
  ${sqlEscape(category)},
  ${sqlEscape(contentType)},
  ${sqlEscape(content)},
  ${sqlEscape(imageUrl)},
  ${sqlEscape(imageTitle)},
  ${sqlEscape(imageDescription)},
  ${sqlEscape(images)},
  ${sqlEscape(videoUrls)},
  ${sqlEscape(status)},
  ${isDeleted},
  ${createdAt},
  ${updatedAt}
);`;

    seedStatements.push(insertSql);
  }
}

// Ensure Creator has an avatar
const updateCreatorAvatarSql = `UPDATE users SET avatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&q=80' WHERE id = 'usr_creator_seed_001' AND avatar IS NULL;`;

const fullSql = `-- =========================================================================
-- SEED DATA: 100 RANDOM ARTICLES FOR /article PAGE
-- Created with identifiable prefix: 7e575eed-2026-4000-8000-xxxxxxxxxxxx
-- Author Account: usr_creator_seed_001 (creator@adsplatform.com)
-- To delete these 100 records in the future, run:
--   pnpm run db:clean:articles
-- Or execute apps/backend/seeds/clean_seed_articles.sql
-- =========================================================================

${updateCreatorAvatarSql}

${seedStatements.join('\n\n')}
`;

const cleanSql = `-- =========================================================================
-- CLEANUP SCRIPT: DELETE ALL SEED ARTICLES GENERATED FOR /article
-- Target ID pattern: 7e575eed-2026-4000-8000-%
-- Author Account: usr_creator_seed_001
-- =========================================================================

-- 1. Remove impressions referencing seed campaigns
DELETE FROM impressions WHERE campaign_id LIKE '7e575eed-%';

-- 2. Remove translations referencing seed campaigns
DELETE FROM campaign_translations WHERE campaign_id LIKE '7e575eed-%';

-- 3. Remove all 100 seeded campaigns
DELETE FROM campaigns WHERE id LIKE '7e575eed-%';
`;

const seedsDir = path.resolve(__dirname, '../seeds');
fs.writeFileSync(path.join(seedsDir, 'seed_articles_100.sql'), fullSql, 'utf8');
fs.writeFileSync(path.join(seedsDir, 'clean_seed_articles.sql'), cleanSql, 'utf8');

console.log(`Successfully generated ${totalRecords} seed records into apps/backend/seeds/seed_articles_100.sql`);
console.log(`Successfully generated cleanup script into apps/backend/seeds/clean_seed_articles.sql`);

