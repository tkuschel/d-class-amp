// ---------------------------------------------------------
// Typst Template: Electronic Circuit Project Description
// ---------------------------------------------------------
#import "@preview/unify:0.8.1": num, qty, unit

// Metadata, Git-Hash via CLI (--input git-hash=...)
#let author-name = "Thomas Kuschel"
#let doc-date = datetime.today().display("[year]-[month]-[day]") // Alternativ fix: "2026-11-14"
#let git-hash = sys.inputs.at("git-hash", default: "local")

#set page(
  paper: "a4",
  margin: (top: 3.5cm, bottom: 2cm, left: 2cm, right: 2cm),
  header: [
    #grid(
      columns: (auto, 1fr, auto),
      gutter: 12pt,
      align: (left + horizon, center + horizon, right + horizon),

      // 1. Left: FH Technikum Wien Logo
      image("img/FH_Technikum_Wien_logo.svg", width: 3.6cm),

      // 2. Center: Institutional Subtitle
      text(size: 8.5pt, fill: rgb("#4b5563"))[
        Electronic Systems and PCB Design\
        Bachelor in Electronic Engineering
      ],

      // 3. Right: Project Tag
      block(
        fill: rgb("#e5e7eb"),
        inset: (x: 8pt, y: 5pt),
        radius: 2pt,
        text(weight: "bold", size: 10pt, fill: rgb("#1f2937"))[Project: 73]
      )
    )
    #v(4pt)
    #line(length: 100%, stroke: 0.6pt + rgb("#9ca3af"))
  ],
  footer: [
    #line(length: 100%, stroke: 0.4pt + rgb("#d1d5db"))
    #v(2pt)
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),

      // Links: Name, Datum & Git-Hash in Grau
      text(size: 8pt, fill: rgb("#6b7280"))[
        #author-name | #doc-date | Git: #raw(git-hash)
      ],

      // Rechts: Seitenzahl
      text(size: 9pt, fill: rgb("#4b5563"))[
        #context counter(page).display("1")
      ]
    )
  ]
)

// Global Typography & Layout Settings
#set text(
  font: "New Computer Modern", // Falls back cleanly if not installed; try "Arial" or "New Computer Modern"
  size: 10.5pt,
  fill: rgb("#111827"),
  lang: "en",
  region: "US"
)

#set par(
  justify: true,
  leading: 0.65em,
  spacing: 1.1em
)

// ---------------------------------------------------------
// Document Content
// ---------------------------------------------------------

// Main Project Title
#align(center)[
  #text(size: 16pt, weight: "bold", fill: rgb("#005587"))[
    Class-D Power Amplifier (Project Lab)
  ]
]
#v(0.5em)

// ---------------------------------------------------------
// Left: img-000 + img-001, Right: prel_class_d_3.svg
// ---------------------------------------------------------
#grid(
  columns: (32%, 1fr), // Left 32% width (for the two stacked images), right remaining width for the schematic
  gutter: 8pt,         // Spacing between left and right columns
  align: (center + bottom, center + bottom),

  // Left Column: img-000.png on top, img-001.png aligned directly below
  figure(
    stack(
      dir: ttb,           // Top-to-bottom stack
      spacing: 6pt,       // Vertical spacing between both images
      image("img/img-000.png", width: 100%),
      image("img/img-001.png", width: 100%)
    ),
    caption: [Current Circuit]
  ),

  // Right Column: Proposed Circuit Schematic
  figure(
    box(height: 6.2cm, align(center + horizon)[
      #image("img/prel_class_d_3.svg", width: 100%)
    ]),
    caption: [Proposed Circuit]
  ),
)
#v(0.8em)
// ---------------------------------------------------------
// Circuit Description & Redesign Task
// ---------------------------------------------------------

This circuit represents a sub-module of a Class-D audio amplifier developed for the Electronics Project Laboratory.

Two N-channel MOSFETs arranged in a half-bridge topology serve as the power output stage to drive a low-impedance loudspeaker.
An LT1160/LT1162 gate driver IC controls the power MOSFETs, prevents shoot-through (simultaneous conduction), and generates the boosted gate drive voltage for the high-side FET via a bootstrap circuit.
For simplicity and ease of testing, all components are integrated onto a compact PCB module.

During daily laboratory use, recurring handling mishaps frequently damage individual components, resulting in time-consuming repairs.
Furthermore, the currently used FDS6612A MOSFETs have reached end-of-life (EOL), and the existing ground-path reverse polarity protection causes ground-shift issues during power-up.

*Objective & Preliminary Redesign Proposal (Open for Further Optimization):*

- *Protection & Input Conditioning:* Relocate the reverse polarity protection to the high-side supply path and add overvoltage/ESD protection on both supply and control inputs.
  Verify pull-down resistor sizing (e.g., #qty(100,"kilo ohm") vs. #qty(10,"kilo ohm")) and input behavior when long or unshielded drive wires are used.
- *Grounding & Decoupling:* Separate signal ground (`SGND`) and power ground (`PGND`) to handle output currents up to #qty(3,"A") (at #qty(4,"ohm")), and provide an explicit `SGND` reference pin directly at the signal connector. Keep low-ESR ceramic decoupling capacitors on-board while moving bulky electrolytic bulk capacitors to the external breadboard.
- *Component & Bootstrap Sizing:* Evaluate modern MOSFET replacements (e.g., BUK7Y7R0-40H in LFPAK56 or comparable DPAK/SO-8 alternatives) regarding gate charge, thermal dissipation, and solderability. Dimension the bootstrap capacitor (e.g., #qty(100,"nF") NP0/C0G or high-voltage X7R) to match the chosen FETs and switching frequency.
- *Lab Usability & Form Factor:* Integrate dedicated oscilloscope test points (`TP_*`) and ground connections. Consider expanding the PCB outline (e.g., $21.5 times qty(50,"mm")$) or adding #qty(4,"mm") power sockets to improve routing, thermal handling, and breadboard usability.
