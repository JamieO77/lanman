📂 LANMAN: Cyber-Secure Credit & Data Portal
LANMAN is a professional-grade, web-based data management suite designed for credit profiling and secure document handling. Built with a "Security-First" philosophy, it features a custom-engineered Universal Cyber Viewer that eliminates the need for external software to view or edit critical assets.

🚀 Core Capabilities
- Unified Data Intelligence: Centralized management of credit profiles using a high-performance MySQL 8/MariaDB backend.
- Zero-Footprint Document Handling: View and edit documents directly in the browser without downloading sensitive files to local machines.
- Automated Data Protection: Built-in "Heartbeat" autosave system and one-click backup generation to prevent data loss.
- Multi-Engine Rendering: Specialized decoders for spreadsheets, word documents, database scripts, and media files.

🛠 Technical Feature List
  Monaco IDE Engine
  
    Description: Full IDE-style editing environment.
    Capabilities: Full-screen editing, line numbers, and "vs-dark" theme integration.
    Syntax Highlighting: Professional-grade coloring for SQL, CSV, and Plaintext.
    Tech: Monaco Editor API

  Grid Intelligence (Spreadsheets)
  
    Description: Renders raw data files into high-contrast HTML5 tables.
    Capabilities: Auto-detection of sheets and conversion of binary data into readable grids.
    Supported Types: .csv, .xls, .xlsx.
    Tech: SheetJS (XLSX.full.min.js)

  Document Processor
  
    Description: Server-side document rendering for word processing files.
    Capabilities: Converts binary .docx structures into clean HTML while maintaining text hierarchy.
    Supported Types: .doc, .docx.
    Tech: Mammoth.js

  Secure PDF Command
  
    Description: Layered PDF viewing without browser plugins.
    Capabilities: Canvas-based rendering, zoom controls, and sidebar navigation.
    Tech: PDF.js

  Media Command Center
  
    Description: Integrated audio and video playback for digital evidence.
    Capabilities: Native playback with play/pause, volume, and seek controls.
    Supported Types: .mp4, .webm, .mp3, .wav
    Tech: HTML5 Media API

  Autosave Heartbeat
  
    Description: Background synchronization to protect user progress.
    Capabilities: Configurable 5-minute intervals with a manual toggle checkbox.
    Tech: JavaScript / AJAX

  Validation Logic
  
    Description: Pre-load integrity check for all assets.
    Capabilities: Verifies file existence on the server via fetch before initializing render engines.
    Error Handling: Custom Cyber-Red alert system for missing or corrupted resources.


🔧 Full System Explanation
  1. The Cyber Viewer Architecture
  The heart of LANMAN is the Universal Cyber Viewer. Unlike standard portals that just "download" files, LANMAN fetches the file server-side, validates its existence, and then determines the most efficient engine to render it.
  
  Spreadsheets: Are transformed from binary blobs into interactive tables.
  
  Database Scripts: Are opened in a "Developer Mode" with line numbers and syntax coloring.

  2. Security & Redundancy
  LANMAN assumes the user is working with high-stakes data.
  
  The Backup Protocol: Every time a file is edited, the system provides a one-click BACKUP option which duplicates the file into a secured /bkp/ directory with a timestamp.
  
  Integrity Checks: The system performs an asynchronous HEAD request before loading any asset to ensure no broken links or "File Not Found" errors interrupt the workflow.
  
  3. Optimized User Experience (UX)
  Toggle-View System: Users can switch between "Formatted View" (for reading) and "Edit Mode" (for modifying) with a single click.

Adaptive Dimensions: The portal detects the intended viewing size ([glo_view_size]) and centers the content for maximum readability on 1080p or 4K monitors.
